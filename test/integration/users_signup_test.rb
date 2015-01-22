require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "invalid signup information" do 
		get signup_path
# we are wrapping the post request in the assert_no_difference method which allows us 
# to compare the User.count before and after the post request and assert that there was 
# no change in the count of users. 
		assert_no_difference 'User.count' do 
			post users_path, user: { name: " ", 
															 email: "mansi.invalid",
															 password: "bla", 
															 password_confirmation: "blue"
			}
		end
		# we are testing to make sure that, because the user attributes are invalid,
		# the application will redirect to the users/new page or the signin page
		assert_template 'users/new'
	end

	test "valid signup information" do 
		get signup_path
		assert_difference 'User.count', 1 do 
			# the post_via_redirect arranges to follow the redirect path specified after the user was created
			post_via_redirect users_path, user: { name: "Mansi", 
															 email: "test@email.com",
															 password: "doggies",
															 password_confirmation: "doggies"
			}
		end
		assert is_logged_in?
		assert_template 'users/show'
	end

end
