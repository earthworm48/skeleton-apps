class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
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
  end

  def update
  	if params[:user][:password].empty?
  		@user.errors.add(:password, "can't be empty")
  		render 'edit'
  	elsif @user.update_attributes(user_params)
  		log_in @user
  		flash[:success] = "Password reset successfully"
  		redirect_to @user
  	else  #wrong format of password
  		render 'edit'
  	end
  end

  private
  	def user_params
  		params.require(:user).permit(:password,:password_confirmation)
  	end

  	def get_user
  		@user = User.find_by(email: params[:email])
  	end

  	def valid_user
  		redirect_to root_url unless @user && @user.authenticated?(:reset, params[:id]) && @user.activated?
  	end

  	def check_expiration
  		if @user.password_reset_expired?
  			flash[:danger] = "Password reset has expired"
  			redirect_to new_password_reset_url
  		end
  	end
end
