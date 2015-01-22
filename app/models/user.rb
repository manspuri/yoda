
class User < ActiveRecord::Base
	before_save {self.email = self.email.downcase}
	validates :name,  presence: true, length: { maximum: 50 } 
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 250 }, 
										format: { with: VALID_EMAIL_REGEX }, 
										# rails infers that uniqueness should be true and that it is 
										# not case-sensitive using the statement below
										uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }
	# has_secure_password adds the following functionality: 

	# 1. Ability to save a securely hashed password_digest attribute to the database
	# (the input password is hashed and compared to this stored hashed password_digest)

	# 2. Virtual attributes (password and password_confirmation) which include presence 
	# validations when the user is being created and a validation requiring that they 
	# match. 

	# 3. An 'authenticate' method which returns the user if the password is correct.

	# this method allows us to create a hashed password_digest for our user fixture (test)
	# 'string' is the string to be hashed and 'cost' represents the computational cost to 
	# calculate the hashed password_digest. The cost can be MIN_COST because we are in a test
	# environment rather than production environment which requires an intractable password_hash
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
																									BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end
end
