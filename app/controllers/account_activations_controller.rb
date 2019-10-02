class AccountActivationsController < ApplicationController
  before_action :find_user

  def edit
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t ".activated"
      redirect_to @user
    else
      flash[:danger] = t ".invalid"
      redirect_to root_url
    end
  end

  private

  def find_user
    @user = User.find_by email: params[:email]
    
    return if @user
    flash[:danger]= t ".cant_find"
    redirect_to root_url
  end
end
