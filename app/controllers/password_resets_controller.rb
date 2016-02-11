class PasswordResetsController < ApplicationController
  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
	  	# 1) create digest
	  	@user.create_reset_digest
	  	# 2) send email
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
  end

  def update
  	
  end
end
