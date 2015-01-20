class AddIndexToUsersEmail < ActiveRecord::Migration
	# This adds an index to the email column of the users table so when traffic is heavy and a user quickly adds
	# an email address twice, the second one is not valid. Prevents two identical email addresses from being added
	# to the database under heavy traffic times. 

	# This also improves efficiency because now, when finding a user by their email address, you don't
	# need to do a full table scan, just searches the index. 
  def change
  	add_index :users, :email, unique: true
  end
end
