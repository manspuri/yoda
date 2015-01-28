class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in(@user)
      flash[:success] = "Welcome to Mansi's first TDD Rails App"
      # @user, in this case, is the same as writing user_path(@user)
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
      @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find_by(params[:id]).destroy
    flash[:success] = "User has been deleted."
    redirect_to users_url
  end

  private

  # strong params are used to prevent mass assignment vulnerability 
  def user_params
  	params.require(:user).permit(:name, :email, :password, 
  															 :password_confirmation)
  end

  def user_login_params
  	params.require(:user).permit(:name, :email, :password)
  end

  # confirms a logged-in user (used in the before filters so someone who is 
  # not logged in cannot change a user's information)
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Gots to log in first..."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
end
