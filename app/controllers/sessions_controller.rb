class SessionsController < ApplicationController
  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
      # methods in sessions_helper file
      log_in(@user)
  		redirect_to @user
  	else
  		# flash.now is used because if we just used flash, the flash content message would
  		# persist for one request longer than we want.  This is b/c 'render' is not a new request
  		# so the message stays until a new request is submitted.  In order to get around this, 
  		# flash.now is used -- it is specifically designed for displaying flash messages on rendered pages. 
  		flash.now[:danger] = "Invalid email/password combo, friend."
  		render 'new'
  	end
  end

  def destroy
    # methods in sessions_helper file
    log_out 
    redirect_to root_path
  end
end
