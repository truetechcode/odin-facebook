class FriendshipsController < ApplicationController
include FriendRequestsHelper
  before_action :authenticate_user!
  def index
    @friends = current_user.friends.order(:id)
  end

  def create
    friend = User.find_by_id(params[:friend_id])
    if request = FriendRequest.find_by(requestor_id:friend.id,
      requestee_id:current_user.id)
      #current_user.friends << friend
      friendship = current_user.friendships.build(friend_id: friend.id)
      if friendship.save
        request.destroy
        flash[:success] = "You just made friends with #{friend.name}"
        redirect_to users_path
      else
        flash[:error] = 'Something went wrong'
      end
    else
      flash[:notice] = "Friend request sent to #{friend.name}"
      new_friend_request(friend.id)
      redirect_to users_path
    end


  end

  def destroy
    if friendship = current_user.friendships.find_by_id(params[:id])
      friendship.destroy
      flash[:warning] = "Friend removed"
      redirect_to friends_path
    else
      flash[:warning] = 'Cannot find friendship'
      redirect_to friends_path
    end
  end
end
