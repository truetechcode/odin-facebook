ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def assert_logged_out_links
    assert_select 'a[href=?]', new_user_session_path
    assert_select 'a[href=?]', new_user_registration_path
    assert_select 'a[href=?]', users_path, count: 0

    assert_select 'a[href=?]', destroy_user_session_path, count: 0
  end
  def assert_logged_in_links
    assert_select 'a[href=?]', new_user_session_path, count: 0
    assert_select 'a[href=?]', new_user_registration_path, count: 0

    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', friends_path
    assert_select 'a[href=?]', destroy_user_session_path
    assert_select 'a[href=?]', edit_user_registration_path
  end

  def assert_login_form
    assert_select 'input[name=?]', 'user[email]'
    assert_select 'input[name=?]', 'user[password]'
    assert_select 'input[name=?]', 'user[remember_me]'
    assert_select 'input[type=?]', 'submit'
  end

  def getusers
    @jason = users(:jason)
    @hodja = users(:hodja)
    @yeti = users(:yeti)
    @kirk = users(:kirk)
  end

  def getposts
    @post1 = posts(:first)
    @post2 = posts(:second)
    @post3 = posts(:third)
  end

  def getcomments
    @comment1 = comments(:one)
    @comment2 = comments(:two)
    @comment3 = comments(:three)

  end
end
