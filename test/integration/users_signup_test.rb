require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	def setup
		# Because the deliveries array is global, 
		# we have to reset it in the setup method to prevent our code from breaking 
		# if any other tests deliver email
		ActionMailer::Base.deliveries.clear	
	end

	test "invalid signup information" do 
		get sign_up_path
		assert_no_difference 'User.count' do
			post users_path, user: { name: "  ", email: "user@invalid", password: "lala", password_confirmation: "lalaa"}
		end
		assert_template 'users/new'
	end

	test "valid signup information with account activation" do
		get sign_up_path
		assert_difference "User.count", 1 do
			# Performs a POST request, following any subsequent redirect
			post users_path, user:{ name: "Example User", email: "sam@gmail.com", password: "123456", password_confirmation: "123456"}
		end
		# The amount of letter sent out is 1
		assert_equal 1, ActionMailer::Base.deliveries.size

		# access the @user variable defined in Users controller’s create action  
		user = assigns(:user)
		assert_not user.activated?
		# Try log in before activation
		log_in_as(user)
		assert_not is_logged_in?

		# Invalid activation token to be passed 
		get edit_account_activation_path("invalid token")
		assert_not is_logged_in?

		# Valid token, wrong email
		get edit_account_activation_path(user.activation_token , email: "wrong")
		# because the account activation controller can't get the correct params
		assert_not is_logged_in?

		# Valid token and email
		get edit_account_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?
		# edit method leads them to redirect path
		follow_redirect!
		assert_template 'users/show'
		assert is_logged_in?
	end
end
