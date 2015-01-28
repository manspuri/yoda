class AddAdminToUsers < ActiveRecord::Migration
  def change
  	# set as false which means that users will not be administrators 
  	# by default
    add_column :users, :admin, :boolean, default: false
  end
end
