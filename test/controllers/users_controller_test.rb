require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	def setup
		@user = users(:michael)
		@other_user = users(:carmen)
	end

	test " index: should redirect to login page when not logged in" do
		get :index
		assert_redirected_to login_url
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

  test "edit: should redirect to login page when other user request to edit" do
  	log_in_as(@other_user)
  	get :edit, id: @user
  	assert flash.empty?
  	assert_redirected_to root_url
  end

  test "update: should redirect to login page when other user request to update" do
  	log_in_as(@other_user)
  	patch :update, id: @user, user: { name: @user.name, email: @user.email}
  	assert flash.empty?
  	assert_redirected_to root_url
  end

  test "destroy: should redirect to login page if not logged in" do
  	assert_no_difference 'User.count' do
  		delete :destroy, id: @user
  	end
  	assert_redirected_to login_url
  end

  test "destroy: should redirect to root url if not an admin" do
  	log_in_as @other_user
  	assert_no_difference 'User.count' do
  		delete :destroy, id: @user
  	end
  	assert_redirected_to root_url
  end
end
