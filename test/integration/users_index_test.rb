require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
	
	def setup 
		@admin = users(:michael)
	 	@other_user = users(:archer)
	end 

	test "index including pagination" do 
		log_in_as(@admin)
		get users_path
		assert_template 'users/index'
		assert_select 'div.pagination'
		# checking for a div with the required pagination class and verifying
		# that the first page of users is present.
		User.paginate(page: 1).each do |user|
			assert_select 'a[href=?]', user_path(user), text: user.name
		end
	end

	# testing to see that, if logged in as admin, admin is able to see the delete
	# links next to each user and that when they click 'delete', a user is 
	# deleted and user count drops by 1. 
	test "index as admin including pagination and delete links" do 
		log_in_as(@admin)
		get users_path
		assert_template 'users/index'
		assert_select 'div.pagination'
		first_page_of_users = User.paginate(page: 1)
		first_page_of_users.each do |user|
			assert_select'a[href=?]', user_path(user), text: user.name
			unless user == @admin
				assert_select'a[href=?]', user_path(user), text: 'delete',
																									 method: :delete
			end
		end
		assert_difference 'User.count', -1 do 
			delete user_path(@other_user)
		end
	end

	# testing to see that no delete option is available to a logged in user who is not
	# who is non-admin.
	test "index as non-admin" do 
		log_in_as(@other_user)
		get users_path
		assert_select 'a', text: 'delete', count: 0
	end

end
