require 'test_helper'

class UserPageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    getusers
    getposts
  end

  test 'should not get user page if not signed in' do
    get user_path @jason
    assert_redirected_to new_user_session_path
  end

  test 'should not get user page for non friended user' do
    sign_in @jason
    get user_path @hodja
    assert_redirected_to root_url

  end

  test 'can get user page of friend' do
    sign_in @jason
    get user_path @kirk
    assert_response :success

  end

  test 'can get own user page' do
    sign_in @jason
    get user_path @jason
    assert_response :success
    assert_select 'a[href=?]', edit_user_registration_path(@jason)
  end

  test 'should not display link of non friends on user index' do
    sign_in @jason
    get users_path
    assert_select 'a[href=?]', user_path(@kirk)
    assert_select 'a[href=?]', user_path(@hodja), count: 0

  end

  test 'user page displays only that users posts' do
    sign_in @kirk
    get user_path @jason
    assert_response :success
    assert_select 'a[href=?]', post_path(@post1), count: 1
    assert_select 'a[href=?]', post_path(@post2), count: 0
    assert_select 'a[href=?]', post_path(@post3), count: 0

  end
end
