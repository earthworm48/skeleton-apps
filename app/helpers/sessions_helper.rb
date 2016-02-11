module SessionsHelper
	# Log in the user
	def log_in(user)
		session[:user_id] = user.id
	end

	# Log out the current user
	def log_out
		forget(current_user)
		# delete the info saved in the key 'user_id' in the session hash
		session.delete(:user_id)
		@current_user = nil		
	end

	# Returns the current user if any
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)

		# if the user_id and remember token is stored in the cookies
		elsif (user_id = cookies.signed[:user_id])
			# raise
			user = User.find_by(id: user_id)
			# This would work also with the string ’activation’, but using a symbol is more conventional
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	# Returns true if the user is logged in
	def logged_in?
		!current_user.nil?
	end

	def remember(user)
		# separate it into two methods because session controller cannot access some of the 
		# user method User.new_token in other class
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	# stores the url trying to be accessed
	def store_location
		# should save the request url if there is any request
		session[:forwarding_url] = 	request.url if request.get?
	end

	# redirects to stored location (or to default)
	def redirect_back_or(default)
		# unless there is no forwarding_url, only redirect to default
		redirect_to(session[:forwarding_url] || default)
		# delete the info in the session hash
		session.delete(:forwarding_url)
	end
end
