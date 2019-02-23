require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    getusers
  end

  test 'Creating a new friendship results in a two way friendship' do
    assert_difference 'Friendship.count', 2 do
      @jason.friendships.create(friend_id: @hodja.id)
    end
    assert_not_nil @hodja.friends.find_by(id: @jason.id)
  end

  test 'Destroying a friendship destroys both sides' do
    assert_difference 'Friendship.count', -2 do
      @jason.friendships.find_by(friend_id: @kirk.id).destroy
    end

    assert_nil @kirk.friends.find_by(id: @jason.id)
  end



end
