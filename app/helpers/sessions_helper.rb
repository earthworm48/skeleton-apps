module SessionsHelper
	# Log in the user
	def log_in(user)
		session[:user_id] = user.id
	end

	# Log out the current user
	def log_out
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
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
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


end
