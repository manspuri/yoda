module SessionsHelper

	# logs in the given user. 
	def log_in(user)
		session[:user_id] = user.id
	end

  # returns the current logged in user if they exist. 
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # checks if a user is logged in
  def logged_in?
  	!current_user.nil?
  end

  # logs out the current user
  def log_out 
    session.delete(:user_id)
    @current_user = nil
  end

end
