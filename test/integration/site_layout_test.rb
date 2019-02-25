require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    getusers
  end

  test 'Get home page' do
    get root_url
    assert_response :success
  end
  test 'Get password confirmation' do
    get new_user_confirmation_url
    assert_response :success
  end
  test 'Get sign in' do
    get new_user_session_url
    assert_response :success
  end

  test 'Get new user password' do
    get new_user_password_url
    assert_response :success
  end
  test 'Edit user password' do
    get edit_user_password_url
    assert_response :redirect
  end



end
