class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy]
  before_action :correct_user, only: %i[edit update show destroy]
  before_action :admin_user, only: :destroy

  def index
    @users = User.order_user.page(params[:page]).per Settings.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t ".wel"
      redirect_to @user
    else
      flash[:danger] = t ".signup_err"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".delete"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".pls"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by params[:id]
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
