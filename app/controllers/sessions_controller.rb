class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		if user.activated? 
	  		log_in user
	  		params[:session][:remember_me] == '1' ? remember(user) : forget(user)
	  		flash[:success] = "Welcome back"
	  		redirect_back_or user
	  	else
	  		flash[:danger] = "Please check your email for the activation link"
	  		redirect_to root_url
	  	end
  	elsif !user.activated?
  		flash.now[:danger] = "Invalid email/password combination"
	  	render 'new'
	end	
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end
end
