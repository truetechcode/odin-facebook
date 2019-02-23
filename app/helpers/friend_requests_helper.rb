module FriendRequestsHelper

  def new_friend_request(requestee_id)
    request =
      current_user.sent_requests.build(requestee_id: requestee_id)
    if request.save
      flash[:notice] = 'Friend request sent!'
    else
      flash[:error] = "Friend request couldn't be sent:
        #{request.errors.full_messages}"
    end
  end
end
