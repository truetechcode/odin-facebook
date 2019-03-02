require 'test_helper'

class PostsTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    getusers
    getposts
  end

  test 'can see edit on own post' do
    sign_in @jason
    get post_path @post1
    assert_select 'a[href=?]', edit_post_path(@post1)

  end

  test ' can see destroy on own post' do
    sign_in @kirk
    get post_path @post2
    assert_select 'a[href=?][data-method=delete]', post_path(@post2)

  end

  test "can't see edit on friend post" do
    sign_in @kirk
    get post_path @post1
    assert_select 'a[href=?]', edit_post_path(@post1), count: 0

  end

  test "can't see destroy on friend post" do
    sign_in @jason
    get post_path @post2
    assert_select 'a[href=?][data-method=delete]', post_path(@post2), count: 0

  end

  test "can't see non friend post" do
    sign_in @jason
    get post_path(@post3)
    assert_response :redirect

  end

  test 'redirected from nil author post' do
    sign_in @jason
    get post_path(posts(:author_less))
    assert_redirected_to posts_path
  end

end
