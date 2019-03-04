class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]
  def index
    @users = current_user.not_friend_list.order(:id).
      paginate(page: params[:users_page], per_page:10)
    @friends = current_user.friends.order(:id).paginate(page: params[:friends_page], per_page:10)
  end

  def show
    @user = User.find(params[:id])

    unless current_user.friends.include?(@user) || current_user == @user
      flash[:warning] = "You can only see your friends' profiles"
      redirect_to root_url
    end

    @posts = Post.where(author_id: @user).paginate(page: params[:page],
      per_page:10)
  end


end
