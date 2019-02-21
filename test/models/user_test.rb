require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    getusers
  end

  test 'exists_request returns true only if there is an existing friend request' do
    assert_not @jason.exists_request?(@hodja)
    assert @jason.exists_request?(@yeti)
    assert @yeti.exists_request?(@jason)
  end
end
