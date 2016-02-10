require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
	end

	test "index including pagination" do	
		log_in_as(@user)
		get users_path
		assert_template 'users/index'

		# once using pagination, there will be a div with the class of pagination
		assert_select 'div.pagination'
		User.paginate(page: 1).each do |user|
			# there will be a hyperlink <a></a> with the href to the users_path 
			# and alt which is the name of the user
			assert_select 'a[href=?]', user_path(user), text: user.name
		end	
	end
end
