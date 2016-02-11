class PasswordResetsController < ApplicationController
  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
	  	# 1) create digest
	  	@user.create_reset_digest
	  	# 2) send email -> you can check the email in user_mailer_preview.rb
		@user.send_reset_email
	  	# flash info
	  	flash[:info] = "Email have been send to your account"
	  	# redirect
	  	redirect_to root_url
	else
		flash[:danger] = "No such user existing"
		render 'new'
	end
  end

  def edit
	@user = User.find_by(email: params[:email])

	if @user && @user.authenticated?(:reset, params[:id])
		render 'password_resets/edit'
	else
		flash.now[:danger] = "Wrong Authentication Link"
		redirect_to root_url
	end
  end

  def update
  	
  end
end
