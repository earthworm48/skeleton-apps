require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
	def setup
		@admin = users(:michael)
		@non_admin = users(:carmen)
	end

	test "index as admin including pagination and delete link" do	
		log_in_as(@admin)
		get users_path
		assert_template 'users/index'

		# once using pagination, there will be a div with the class of pagination
		assert_select 'div.pagination'
		# access the first page
		first_page = User.paginate(page: 1)
		first_page.each do |user|
			# there will be a hyperlink <a></a> with the href to the users_path 
			# and display which is the name of the user
			assert_select 'a[href=?]', user_path(user), text: user.name
			# check the display -> is it 'delete user' ?
		    assert_select 'a[href=?]', user_path(user), text: 'delete user' if user == @admin
		end	

		assert_difference 'User.count', -1 do
			delete user_path(@non_admin)
		end
	end

	test "index as non-admin" do
		log_in_as(@non_admin)
		get users_path
		# to ensure that there is no delete method 
		assert_select 'a[href=?]', text: 'delete user', count: 0
	end
end
