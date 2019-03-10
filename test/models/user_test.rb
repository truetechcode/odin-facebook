require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    getusers
    @post1 = posts(:first)
    @post2 = posts(:second)
    @post3 = posts(:third)
  end

  test 'exists_request returns true only if there is an existing friend request' do
    assert_not @jason.exists_request?(@hodja)
    assert @jason.exists_request?(@yeti)
    assert @yeti.exists_request?(@jason)
  end

  test 'user with related objects can be deleted' do
    assert_difference 'User.count', -1 do
      @jason.destroy
    end
  end

  test 'deleting user causes friendship to be deleted' do
    friendship_id = Friendship.find_by(friend: @kirk, user: @jason).id
    @kirk.destroy
    assert_nil Friendship.find_by(id: friendship_id)
  end

  test 'deleting user causes friendship to be deleted 2' do
    friendship_id = Friendship.find_by(friend: @kirk, user: @jason).id
    @jason.destroy
    assert_nil Friendship.find_by(id: friendship_id)
  end

  test 'deleting user causes friend request to be deleted' do
    request_id = FriendRequest.find_by(requestee: @jason, requestor: @yeti ).id
    @yeti.destroy
    assert_nil FriendRequest.find_by(id: request_id)
  end

  test 'deleting user causes post author to be nullified ' do
    post_id = Post.find_by(author: @jason)
    @jason.destroy
    p = Post.find_by(id: post_id)
    assert_not_nil p
    assert_nil p.author
  end

  test 'can see own posts in feed' do
    assert_includes(@jason.feed, @post1 )
  end

  test 'can see friends posts in feed' do
    assert_includes(@jason.feed, @post2)
  end

  test 'cant see non friend posts in feed' do
    assert_not_includes(@jason.feed, @post3)
  end

  test 'last activity date returns last post created' do
    assert_equal(@kirk.last_activity,
      @post2.created_at.strftime("#{@post2.created_at.day.ordinalize} %b %Y")
      )
  end

  test 'last activity date returns user created if no action' do
    assert_equal(@yeti.last_activity,
      @yeti.created_at.strftime("#{@yeti.created_at.day.ordinalize} %b %Y")
     )
  end

end
