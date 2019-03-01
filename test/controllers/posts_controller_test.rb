require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @post = posts(:first)
    @post2 = posts(:second)
    @post3 = posts(:third)
    getusers
    @new_body = 'The quick brown fox jumped over the lazy dogs'

  end

  test "should get index with own posts" do
    sign_in @jason
    get posts_url
    assert_response :success
    assert_match @post.preview, response.body
  end

  test "should get index with friends posts" do
    sign_in @jason
    get posts_url
    assert_response :success
    assert_match @post2.preview, response.body
  end

  test "should not see non friend posts" do
    sign_in @jason
    get posts_url
    assert_response :success
    assert_no_match @post3.preview, response.body
  end

  test "should get own posts index only if signed in" do
    sign_in @jason
    get user_posts_url(@jason)
    assert_response :success
  end

  test "should get friends posts index" do
    sign_in @kirk
    get user_posts_url(@jason)
    assert_response :success
  end

  test "should get friends posts index only if signed in" do
    get user_posts_url(@jason)
    assert_redirected_to new_user_session_path
  end

  test "can't get index of non friend" do
    sign_in @hodja
    get user_posts_url(@jason)
    assert_redirected_to new_user_session_path
  end


  test "should get index only if signed in" do
    get posts_url
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    sign_in @jason
    get new_user_post_url(@jason)
    assert_response :success
  end

  test "should get new only if signed in" do
    get new_user_post_url(@jason)
    assert_response :redirect
  end

  test "should create post" do
    sign_in @jason
    assert_difference('Post.count', 1) do
      post user_posts_url(@jason), params: {
        post: {body: 'Hello World!  Hellow World!'  } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should create post only if signed in" do
    assert_difference('Post.count', 0) do
      post user_posts_url(@jason), params: {
        post: {body: 'Hello World!  Hellow World!'  } }
    end

    assert_redirected_to new_user_session_path
  end

  test "should show post belonging to user" do
    sign_in @jason
    get post_url(@post)
    assert_response :success
  end

  test "should show post belonging to friend" do
    sign_in @kirk
    get post_url(@post)
    assert_response :success
  end

  test "should not show post belonging to stranger" do
    sign_in @hodja
    get post_url(@post)
    assert_response :redirect
  end

  test "should get edit" do
    sign_in @jason
    get edit_post_url(@post)
    assert_response :success
  end

  test "should get edit only if signed in as user" do
    get edit_post_url(@post)
    assert_response :redirect
  end

  test "should not get edit for a friend" do
    sign_in @kirk
    get edit_post_url(@post)
    assert_response :redirect
  end


  test "should update post" do
    sign_in @jason
    patch post_url(@post), params: { post: { body:  @new_body }  }
    assert_redirected_to post_url(@post)
    @post.reload
    assert_equal @post.body,  @new_body
  end

  test "should not update post if not signed in" do
    patch post_url(@post), params: { post: {body: @new_body  }}
    assert_redirected_to new_user_session_path
    @post.reload
    assert_not_equal @post.body,  @new_body
  end


  test "should destroy post" do
    sign_in @jason
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end
    assert_redirected_to posts_url
  end

  test "should destroy post only if signed in" do
    assert_difference('Post.count',0) do
      delete post_url(@post)
    end
    assert_redirected_to new_user_session_path
  end

  test "should destroy post only if signed in as author" do
    sign_in @kirk
    assert_difference('Post.count',0) do
      delete post_url(@post)
    end
    assert_redirected_to root_url
  end
end
