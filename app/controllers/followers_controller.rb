class FollowersController < ApplicationController
  def index
    @title = t ".followers"
    @user = User.find_by id: params[:id]
    @users = @user.followers.page(params[:page]).per Settings.per_page
    render "users/show_follow"
  end
end
