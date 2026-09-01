require "test_helper"
class Users::RegistrationsControllerTest <  ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "Should be able to access to sign up page and create an account" do
    get new_user_registration_path
    assert_response :success

    assert_includes response.body, "Sign up"

    post user_registration_path, params: { user: { email: "test@gmail.com", password: "12345678", password_confirmation: "12345678" } }
    assert_response :redirect

    assert_redirected_to user_registration_path
    assert_equal "test@gmail.com", User.last.email
  end
end
