require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
		@user = users(:michael)
	end

	test "Password Resets" do
		get new_password_reset_path
		assert_template 'password_resets/new'

		# valid email
		post password_resets_path, password_reset: { email: ""}
		assert_not 	flash.empty?
		assert_template 'password_resets/new'
		
		# invalid email
		post password_resets_path, password_reset: { email: @user.email }
		# reset_digest is created
		assert_not_equal @user.reset_digest, @user.reload.reset_digest
		# email is sent
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_not flash.empty?
		assert_redirected_to root_url

		# password reset form
		user = assigns(:user)

		# wrong email
		get edit_password_reset_path(user.reset_token, email: "")
		assert_redirected_to root_url

		# right email, wrong token
		get edit_password_reset_path("wrong token", email: user.email)
		assert_redirected_to root_url

		# inactive user
		user.toggle!(:activated)
		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_redirected_to root_url
		user.toggle!(:activated)

		# right email, right token
		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_template "password_resets/edit"
		assert_select "input[name=email][type=hidden][value=?]", user.email

		# invalid password & confirmation
		# must sent with email or else will be redirect to root_url instead
		patch password_reset_path(user.reset_token), email: user.email, 
		user: { password: "", password_confirmation: ""}
		   
		assert_template "password_resets/edit"
		assert_select 'div#error_explanation'

		# valid password & confirmation
		patch password_reset_path(user.reset_token), email: user.email,
		user: { password: "foobaz", password_confirmation: "foobaz"}
		assert is_logged_in?
		assert_not flash.empty?
		assert_redirected_to user
	end
end
