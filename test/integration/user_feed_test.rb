require 'test_helper'

class UserFeedTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    getusers
    getposts
  end

  test 'First post appears on first page' do
    sign_in @jason
    get posts_url
    assert_match @post1.preview, response.body
  end

  test 'Last post doesnt appear on page' do
    sign_in @jason
    get posts_url
    assert_no_match @jason.posts.last.preview, response.body
  end


end
