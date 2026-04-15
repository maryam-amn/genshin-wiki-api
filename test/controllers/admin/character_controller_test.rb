require "test_helper"

class Admin::CharacterControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin_users)
  end

  test "Should get index and show information of all character when the user is log in " do
    get admin_characters_url
    assert_response :success
    character = characters(:charlotte)
    assert_includes response.body, character.name
    assert_select("td.col.col-description", character.description)
  end

  test "shouldn't get index and show information when the user isn't logged in" do
    sign_out :user
    get admin_characters_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
end
