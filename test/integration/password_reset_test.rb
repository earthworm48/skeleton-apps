require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
		@user = users(:michael)
	end

	test "Password Resets" do
		get new_password_reset_path
	end
end
