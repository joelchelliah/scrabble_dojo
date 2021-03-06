class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index, :show, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @memos = @user.memos.paginate(page: params[:page])
  end

  def new
    if logged_in?
      redirect_to root_url, notice: "You already have an account"
    else
  	 @user = User.new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def create
    if logged_in?
      redirect_to root_url
    else
      @user = User.new(user_params)
      if @user.save
        log_in @user
        flash[:success] = "Welcome to Scrabble Dojo!"
        redirect_to root_url
      else
        render 'new'
      end
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.admin?
      flash[:error] = "Admins cannot be destroyed"
      redirect_to root_url
    else
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
end