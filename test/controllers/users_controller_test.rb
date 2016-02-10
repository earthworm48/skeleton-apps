require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	def setup
		@user = users(:michael)
	end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "edit : should redirect to login page when not logged in" do
  	# This uses the Rails convention of id: @user, which (as in controller redirects) automatically uses @user.id.
  	get :edit, id: @user
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  test "update : should redirect to login page when not logged in" do
  	# we need to supply an additional user hash in order for the routes to work properly. 
  	# refer to toy app
  	patch :update, id: @user, user: { name: @user.name, email: @user.email}
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end
end
