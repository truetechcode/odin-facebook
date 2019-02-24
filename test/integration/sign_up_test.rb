require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test 'New user sign up process' do
    get new_user_registration_url
    assert_select 'input[name=?]', 'user[email]'
    assert_select 'input[name=?]', 'user[name]'
    assert_select 'input[name=?]', 'user[password]'
    assert_select 'input[name=?]', 'user[password_confirmation]'

    assert_difference 'User.count', 1 do
      post user_registration_path, params: {user: {email: 'test123@example.com',
        name: 'Jason Test', password: 'password', password_confirmation: 'password'}}
    end
    assert_response :redirect

    assert_not_nil User.find_by(email: 'test123@example.com')

  end


end
