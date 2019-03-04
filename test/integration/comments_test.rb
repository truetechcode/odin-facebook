require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    getusers
    getposts
    getcomments
  end

  test 'comment appears on relevant post' do
    sign_in @jason
    get post_path(@post1)
    assert_match @comment1.body, response.body

  end

  test "comment doesn't appear on another post" do
    sign_in @jason
    get post_path(@post2)
    assert_no_match @comment1.body, response.body
  end

  test 'can comment on own post' do
    comment = 'This is a test 543210!!'
    sign_in @jason
    get post_path(@post1)
    assert_select 'form[action=?]', post_comments_path(@post1)
    assert_difference 'Comment.count', 1 do
      post post_comments_path(@post1), params: {comment: {body: comment}}
    end
    assert_redirected_to post_path(@post1)
    follow_redirect!
    assert_match comment, response.body

  end

  test 'can comment on friend post' do
    comment = 'This is a test 543210!!'
    sign_in @kirk
    get post_path(@post1)
    assert_select 'form[action=?]', post_comments_path(@post1)
    assert_difference 'Comment.count', 1 do
      post post_comments_path(@post1), params: {comment: {body: comment}}
    end
    assert_redirected_to post_path(@post1)
    follow_redirect!
    assert_match  comment, response.body

  end

  test "can't comment on non friend post" do
    comment = 'This is a test 543210!!'
    sign_in @hodja
    get post_path(@post1)
    assert_response :redirect
    assert_difference 'Comment.count', 0 do
      post post_comments_path(@post1), params: {comment: {body: comment}}
    end
    assert_response :redirect
  end

  test "can delete own comment " do
    sign_in @jason
    get post_path(@post1)
    assert_select 'a[data-method="delete"][href=?]', comment_path(@comment1)
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment1)
    end
    assert_redirected_to post_path(@post1)

  end

  test "can't delete other user comment " do
    comment = @comment2
    sign_in @jason
    get post_path(@post1)
    assert_select 'a[data-method="delete"][href=?]', comment_path(@comment2), count: 0
    assert_difference 'Comment.count', 0 do
      delete comment_path(@comment2)
    end
    assert_redirected_to post_path(@post1)
    follow_redirect!
    assert_no_match  comment, response.body
  end

  test "can edit own comment " do
    new_body = 'Testing 123, testing, 3.1459'
    old_body = @comment1.body
    sign_in @jason
    get post_path(@post1)
    assert_select 'a[href=?]', edit_comment_path(@comment1)
    patch comment_path(@comment1), params: {comment:{body: new_body}}
    assert_redirected_to post_path(@post1)
    follow_redirect!
    assert_match new_body, response.body
    assert_no_match old_body, response.body
  end

  test "can't edit someone else's comment " do
    new_body = 'Testing 123, testing, 3.1459'
    old_body = @comment1.body
    sign_in @kirk
    get post_path(@post1)
    assert_select 'a[href=?]', edit_comment_path(@comment1), count: 0
    patch comment_path(@comment1), params: {comment:{body: new_body}}
    assert_redirected_to post_path(@post1)
    follow_redirect!
    assert_no_match new_body, response.body
    assert_match old_body, response.body

  end

  test "blank comment doesn't work " do
    new_body = '   '
    old_body = @comment1.body
    sign_in @jason
    get post_path(@post1)
    assert_select 'a[href=?]', edit_comment_path(@comment1)
    patch comment_path(@comment1), params: {comment:{body: new_body}}
    get post_path(@post1)
    assert_match old_body, response.body
  end
end
