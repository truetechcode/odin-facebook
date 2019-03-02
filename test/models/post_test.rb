require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    getusers
    getposts

  end
  test 'Post can exist with no author' do
    assert_difference 'Post.count', 1 do
      Post.create!(author_id: nil, body: 'Testing 123 123.')
    end
  end

  test 'Post must have minimum 10 characters' do
    assert_difference 'Post.count', 0 do
      @jason.posts.create(body: '123456789')
    end
  end

  test 'Post can have more than 255 characters' do
    assert_difference 'Post.count', 1 do
      @jason.posts.create(body: 'Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..
        Testing 123456789..Testing 123456789..Testing 123456789..')
    end
  end

  test 'Post preview cuts off posts with more than specified characters' do
    assert_match((@post3.body[0...20] + "..."), @post3.preview(letters:20))
  end

  test 'Post preview shows posts with less than specified characters' do
    assert_match @post1.body, @post1.preview(letters:20)
  end
end
