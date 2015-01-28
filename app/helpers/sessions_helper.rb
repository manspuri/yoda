module SessionsHelper

	# logs in the given user. 
	def log_in(user)
		session[:user_id] = user.id
	end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # returns the current logged in user if they exist. 
  def current_user
    # checks if session of user id exists and sets user_id equal to that 
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      @user = User.find_by(id: cookies.signed[:user_id])
      if @user && @user.authenticated?(cookies[:remember_token])
        log_in(@user)
        @current_user = @user
      end
    end
  end

  # checks if a user is logged in
  def logged_in?
  	!current_user.nil?
  end

  # forgets a persistent session
  def forget(user) 
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # logs out the current user
  def log_out 
    # current_user is the method above
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user  
  end

end
