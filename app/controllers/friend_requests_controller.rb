class FriendRequestsController < ApplicationController
  include FriendRequestsHelper
  before_action :authenticate_user!
  def create
    new_friend_request(params[:requestee_id])
    redirect_to users_path
  end

  def index
    @sent_requests = current_user.sent_requests
  end

  def destroy
    if (request = current_user.sent_requests.find_by_id(params[:id])) ||
      (request = current_user.received_requests.find_by_id(params[:id]))
      request.destroy
      flash[:notice] = 'Friend request cancelled'
      redirect_to users_path
    else
      flash[:notice] = "Friend couldn't be found"
      redirect_to users_path
    end
  end
end
