class AccountActivationsController < ApplicationController

	def edit
		@user = User.find_by(email: params[:email])
		# params[:id] = activation_token

		# !@user.activated? => only activate user who has not been activated
		# because we’ll be logging in users upon confirmation and 
		# we don’t want to allow attackers who manage to obtain the activation link to log in as the user.
		if @user && @user.authenticated?(:activation, params[:id]) && !@user.activated?
			@user.activate
			# you can use session helper everywhere because we have include it 
			# in application controller
			log_in @user
			flash[:success] = "Welcome to the apps"
			redirect_to @user
		else
			flash[:danger] = "Activated failed: Invalid activation link"
			redirect_to root_url
		end
	end

end
