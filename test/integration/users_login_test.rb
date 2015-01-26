require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup 
		@user = users(:michael)
	end

	test "login with invalid email/password" do 
		get login_path
		assert_template 'sessions/new'
		post login_path, session: { email: " ", password: " "}
		assert_template 'sessions/new'
		assert_not flash.empty?
		get root_path
		assert flash.empty?
	end

# Need to make sure the following happens upon login with valid information:
# 1. Visit the login path.
# 2. Post valid information to the sessions path.
# 3. Verify that the login link disappears.
# 4. Verify that a logout link appears.
# 5. Verify that a profile link appears.

# Then when they click the logout button we need to test the following:
# 1. Issue a delete request to the logout path.
# 2. Verify that user is logged out. 
# 3. Verify that the user is redirected to the root URL.
# 4. Verify that the login link reappears.
# 5. Verify that the logout and profile links disappear. 

	test "login with valid information" do 
		get login_path
		post login_path, session: {email: @user.email, password: "password"}
		assert is_logged_in?
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		# the count option allows us to test to make sure there are not login_path links shown 
		# on the page if upon successful login
		assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    delete logout_path 
    assert_not is_logged_in?
    assert_redirected_to root_path
    # simulates a user clicking the logout in a second window (to make sure there are no errors if user is logged in two windows, logs out in one, and doesn't in the other)
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', logout_path, count:0
    assert_select 'a[href=?]', user_path(@user), count:0 
    assert_select 'a[href=?]', login_path 
	end

	test "login with remembering" do
		log_in_as(@user, remember_me: "1")
		assert_not_nil cookies['remember_token']
	end
 
 	test "login without remembering" do 
 		log_in_as(@user, remember_me: "0")
 		assert_nil cookies['remember_token']
 	end
end
