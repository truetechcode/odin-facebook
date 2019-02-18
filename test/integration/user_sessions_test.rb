require 'test_helper'

class UserSessionsTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

   def setup
     @jason = users(:jason)
     @hodja = users(:hodja)
   end



   test 'User must login to see logout' do
     #Get home page and check correct links are visible / not visible
     get root_url
     assert_logged_out_links

     #Get login form and confirm it is correctly returned

     get new_user_session_url

     assert_login_form

     #Login and confirm correct links are visible
     post user_session_path, params: {user: {email: @jason.email, password: 'password'}}

     get root_url
     assert_logged_in_links


     #Log out and confirm back to normal
     delete destroy_user_session_path
     follow_redirect!

     assert_logged_out_links


   end

   test 'New user must register before logging in' do
     post user_session_path, params: {user: {email: @hodja.email, password: 'password'}}

     get root_url
     assert_logged_out_links
   end
end
