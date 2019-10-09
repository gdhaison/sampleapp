class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".sent"
      redirect_to root_url
    else
      flash.now[:danger] = t ".not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add password: t(".cant_empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t ".reseted"
      redirect_to @user
    else
      flash[:danger] = t ".fails"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::PASSWORD_RESET_PARAMS
  end

  def get_user
    @user = User.find_by email: params[:email]

    return if @user
    flash[:danger] = t ".cant_find"
    redirect_to root_url
  end

  def valid_user
    unless @user&.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".exprire"
    redirect_to new_password_reset_url
  end
end
