require 'test_helper'

class FriendshipsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    getusers
    @jason_yeti = friend_requests(:jason_yeti)
  end

  test 'Friendship creation' do
    sign_in @jason
    assert_difference '@jason.friends.count', 1 do
      post friendships_path, params: {friend_id: @yeti.id}
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get friends_path
    assert_select 'a[href=?]', user_path(@yeti)
    assert_not_nil @jason.friends.find_by(id:@yeti.id)
    assert_not_nil @jason.friendships.find_by(user_id: @jason.id,
      friend_id: @yeti.id)
    assert_nil @jason.received_requests.find_by(requestor_id: @hodja.id)

  end

  test 'Cannot create friendship without outstanding request' do
    sign_in @jason
    assert_difference '@jason.friends.count', 0 do
      post friendships_path, params: {friend_id: @hodja.id}
    end
    assert_response :redirect
    get friends_path
    assert_select 'a[href=?]', user_path(@hodja), 0
    assert_nil @jason.friends.find_by(id:@hodja.id)
    assert_not_nil @jason.sent_requests.find_by(requestee_id: @hodja.id)

  end

  test 'Friendship destruction' do
    sign_in @jason
    assert_difference '@jason.friends.count', -1 do
      delete friendship_path(@jason.friendships.find_by(friend_id:@kirk))
    end
    assert_response :redirect
    get friends_path
    assert_select 'a[href=?]', user_path(@kirk), count:0
    assert_nil @jason.friends.find_by(id:@kirk.id)
  end

  test 'No Friendship destruction unless signed in' do
    assert_difference '@jason.friends.count', 0 do
      delete friendship_path(@jason.friendships.find_by(friend_id:@kirk))
    end
    get friends_path
    assert_select 'a[href=?]', user_path(@kirk), count:0
    assert_not_nil @jason.friends.find_by(id:@kirk.id)
  end



  test 'Get friends list' do
    sign_in @jason
    get friends_path
    @jason.friends.each do |friend|
      assert_select 'a[href=?]', user_path(friend)
      assert_select 'a[href=?][data-method=delete]', friendship_path(
        @jason.friendships.find_by(friend_id: friend.id)
      )
    end
  end

  test 'Check friends correctly displayed for users' do
    sign_in @jason
    get users_path
    @jason.friends.each do |friend|
      assert_select 'a[href=?]', user_path(friend)
      assert_select "input[type=hidden][value=#{friend.id}]", count: 0
      assert_select 'a[href=?][data-method=delete]', friendship_path(
        @jason.friendships.find_by(friend_id: friend.id)
      )
    end
  end

end
