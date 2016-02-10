require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
		# log_in_as(@user)
	end

	test "unsuccessful edit" do	
		log_in_as(@user)
		get edit_user_path(@user)
		assert_template "users/edit"
		patch user_path(@user), user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar" }	
		assert_template "users/edit"
	end

	test "successful edit with friendly forwarding" do
		get edit_user_path(@user)
		# then fail because haven't log in
		# ... so we log them in
		log_in_as(@user)
		assert_redirected_to edit_user_path(@user)

		# assert_template "users/edit" <- substituted
		name = "hello"
		email = "hello@gmail.com"
		patch user_path(@user), user: { name: name, email: email, password: "", password_confirmation: ""}
		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal name, @user.name
		assert_equal email, @user.email
	end
end
