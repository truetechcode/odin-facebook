require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @comment = comments(:one)
    getposts
    getusers
  end


  test "should create comment" do
    sign_in @jason
    assert_difference('Comment.count') do
      post post_comments_url(@post1), params: { comment: { body: 'Testing' } }
    end

    assert_redirected_to post_url(@post1)
  end



  test "should update comment" do
    sign_in @jason
    patch comment_url(@comment), params: { comment: {  body: 'Testing' } }
    assert_redirected_to post_path(@comment.commentable)
  end

  test "should destroy comment" do
    sign_in @jason
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment)
    end
    assert_response :redirect
  end
end
