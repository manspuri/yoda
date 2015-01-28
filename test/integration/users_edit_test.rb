require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup 
		@user = users(:michael)
	end

	test "unsuccessful edit" do
		log_in_as(@user) 
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), user: {name: "", 
														email: "foo@invalid", 
														password: "foo", 
														password_confirmation: "bar" }
		assert_template 'users/edit'
	end

	test "successful edit" do
		log_in_as(@user) 
		get edit_user_path(@user)
		assert_template 'users/edit'
		name = "Michaelangelo"
		email = "michael@gmail.com"
		patch user_path(@user), user: {name: name, 
																	 email: email,
																	 passwword: "",
																	 password_confirmation: ""
		}
		assert_not flash.empty?
		assert_redirected_to @user
		# reload the user's values from the database and confirm they they 
		# were successfully activated
		@user.reload
		assert_equal @user.name, name
		assert_equal @user.email, email
	end

end
