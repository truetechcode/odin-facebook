require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    getusers
    getposts
  end

  test 'can comment on own post' do
    comment = @post1.comments.build(author: @jason, body: 'Testing 123')
    assert_difference "Comment.count", +1 do
      comment.save
    end

  end

  test 'can comment on friend post' do
    comment = @post2.comments.build(author: @jason, body: ' Testing 123')
    assert_difference "Comment.count", +1 do
      comment.save
    end
  end


  test 'comment > 255 characters fails' do
    body = 'Testing 123.  Testing 123.  Testing 123.  Testing 123.
    Testing 123.  Testing 123.  Testing 123.  Testing 123.  Testing 123.
    Testing 123.  Testing 123.  Testing 123.  Testing 123.  Testing 123.
    Testing 123.  Testing 123.  Testing 123.  Testing 123.  Testing 123.
    Testing 123.  Testing 123.  Testing 123.  Testing 123.  Testing 123.
    Testing 123.  Testing 123.  Testing 123.  Testing 123.  Testing 123.  '
    comment = @post1.comments.build(author: @jason, body: body)
    assert_difference "Comment.count", +0 do
      comment.save
    end
  end

  test 'empty comment fails' do
    comment = @post1.comments.build(author: @jason, body: '')
    assert_difference "Comment.count", +0 do
      comment.save
    end
  end

  test 'blank comment fails' do
    comment = @post1.comments.build(author: @jason, body: '     ')
    assert_difference "Comment.count", +0 do
      comment.save
    end
  end
end
