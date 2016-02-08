require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	test "invalid signup information" do 
		get sign_up_path
		assert_no_difference 'User.count' do
			post users_path, user: { name: "  ", email: "user@invalid", password: "lala", password_confirmation: "lalaa"}
		end
		assert_template 'users/new'
	end

	test "valid signup information" do
		get sign_up_path
		assert_difference "User.count", 1 do
			# Performs a POST request, following any subsequent redirect
			post_via_redirect users_path, user:{ name: "Example User", email: "sam@gmail.com", password: "123456", password_confirmation: "123456"}
		end
		assert_template 'users/show'
		assert is_logged_in?
	end
end
