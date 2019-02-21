require 'test_helper'

class FriendRequestsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    getusers
    @jason_yeti = friend_requests(:jason_yeti)
  end

  test 'should create a friend_request' do
    sign_in @jason
    get users_path
    assert_select "input[type=hidden][value=#{@hodja.id}]"
    assert_difference '@hodja.received_requests.count', 1 do
      post friend_requests_path, params: {requestee_id: @hodja.id}
    end
    assert_response :redirect
  end

  test 'should destroy a friend_request if logged in as the sender' do
    sign_in @yeti
    get users_path
    assert_select "a[href=?][data-method=delete]", friend_request_path(@jason_yeti)
    assert_difference '@yeti.sent_requests.count', -1 do
      delete friend_request_path(@jason_yeti)
    end
    assert_response :redirect
  end

  test 'should not destroy a friend request if signed in as another user' do
    sign_in @hodja
    get users_path
    assert_select "a[href=?][data-method=delete]", friend_request_path(@jason_yeti), count: 0

    assert_difference '@jason.received_requests.count', 0 do
      delete friend_request_path(@jason_yeti)
    end
    assert_response :redirect
  end
end
