require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase

  def setup
    getusers
  end

  test 'Friend Request created, duplicate not allowed' do
    jason_received_requests = @jason.received_requests.count
    request = @hodja.sent_requests.build(requestee:@jason)
    assert_difference 'FriendRequest.count', 1 do
      request.save
    end
    assert_equal jason_received_requests + 1, @jason.received_requests.count
    request2 = @hodja.sent_requests.build(requestee:@jason)
    assert_not request2.valid?
  end

end
