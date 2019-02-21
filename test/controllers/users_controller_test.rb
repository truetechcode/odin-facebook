require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    getusers
    sign_in @jason
  end

  test 'shows index of users only if logged in' do
    get users_url

    assert_response :success

    assert_select 'a[href=?]', user_path(@hodja)

    sign_out @jason

    get users_url

    assert_response :redirect

    follow_redirect!

    assert_select 'a[href=?]', user_path(@hodja), count:0

  end


end
