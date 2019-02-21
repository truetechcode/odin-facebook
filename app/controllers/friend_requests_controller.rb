class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  def create
    request =
      current_user.sent_requests.build(requestee_id: params[:requestee_id])
    if request.save
      flash[:notice] = 'Friend request sent!'
    else
      flash[:error] = "Friend request couldn't be sent:
        #{request.errors.full_messages}"
    end
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
