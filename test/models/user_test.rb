require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		# generate sample user for testing
		@user = User.new(name:"Example User",email:"user@example.com", password: "foobar", password_confirmation: "foobar")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = "     "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "    "
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 244 + "@gmail.com"
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
		valid_addresses = %w[user@example.com USER@FOO.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |valid_address|
			@user.email = valid_address
			assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	test "email validation should not accept invalid address" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address.inspect} is invalid"
		end
	end

	test "email address should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = duplicate_user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "password should be present" do
		@user.password = @user.password_confirmation = "    "
		assert_not @user.valid?
	end

	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = "A" * 5 
		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with nil digest" do 
		assert_not @user.authenticated?(:remember,"")
	end

	test "authenticated? should return true for a user with correct digest" do
		@user.remember
		@user.reload
		token = @user.remember_token
		assert @user.authenticated?(:remember, token)
	end
end