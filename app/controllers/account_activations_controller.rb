class AccountActivationsController < ApplicationController

	def edit
		byebug
		@user = User.find_by(email: params[:email])

		if @user && @user.authenticated?(params[:id])
		 redirect_to @user
		end
	end

end
