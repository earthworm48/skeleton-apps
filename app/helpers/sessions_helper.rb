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
		@current_user ||= User.find_by(id: session[:user_id])
	end

	# Returns true if the user is logged in
	def logged_in?
		!current_user.nil?
	end


end
