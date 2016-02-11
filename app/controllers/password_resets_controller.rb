class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

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
	
	byebug
	if 
		render 'password_resets/edit'
	else
		flash[:danger] = "Wrong Authentication Link"
		redirect_to root_url
	end
  end

  def update
  	
  end

  private
  	def get_user
  		@user = User.find_by(email: params[:email])
  	end

  	def valid_user
  		redirect_to root_url unless @user && @user.authenticated?(:reset, params[:id]) && @user.activated?
  	end
end
