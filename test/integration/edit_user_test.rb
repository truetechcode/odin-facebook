require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    getusers
  end

  test 'change email' do
      sign_in @jason
      get edit_user_registration_path
      assert_select 'input[name=?]', "user[email]"
      patch user_registration_path  , params: {user:{name: @jason.name,
        email: 'testcase15@example.com', password:'',
        password_confirmation: '', current_password: 'password'}}
      assert_response :redirect
      @jason.reload
      assert_match 'testcase15@example.com', @jason.unconfirmed_email
  end


  test 'change email 2' do
      test_change_field(email: 'testcase15@example.com', test: 'email')
      assert_match 'testcase15@example.com', @jason.unconfirmed_email
  end

  test 'change name' do
      test_change_field(name: 'Hodja Hodja', test: 'name')
      assert_match 'Hodja Hodja', @jason.name
  end

  test 'change password' do
      password = @jason.encrypted_password
      test_change_field(password: 'Hodja Hodja', test: 'password')
      assert_no_match password, @jason.encrypted_password
  end
  private

  def test_change_field(email: @jason.email, password: '',
    name: @jason.name, test:'')
    sign_in @jason
    get edit_user_registration_path
    assert_select 'input[name=?]', "user[#{test}]"
    patch user_registration_path, params: {user:{name: name,
      email: email, password: password,
      password_confirmation: password,
      current_password: 'password'}}
    assert_response :redirect
    @jason.reload


  end

end
