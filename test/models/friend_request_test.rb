require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase

  def setup
    @hodja = users(:hodja)
    @jason = users(:jason)
  end

  test 'Friend Request created, duplicate not allowed' do
    request = @hodja.sent_requests.build(requestee:@jason)
    assert_difference 'FriendRequest.count', 1 do
      request.save
    end
    assert_equal 1, @jason.received_requests.count
    request2 = @hodja.sent_requests.build(requestee:@jason)
    assert_not request2.valid?
  end
end
