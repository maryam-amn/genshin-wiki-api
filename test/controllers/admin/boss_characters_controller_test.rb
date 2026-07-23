require "test_helper"

class Admin::BossCharactersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin_users)
  end

  test "Should render information about a boss character when the user is logged in" do
    boss_character = boss_characters(:signora_from_mondsatdt)

    get admin_boss_character_url(boss_character.id)

    assert_response :success

    assert_includes response.body, boss_character.name
    assert_select("td", boss_character.description)
  end

  test "Shouldn't render information about a boss character when the user is not logged in" do
    sign_out :user

    boss_character = boss_characters(:signora_from_mondsatdt)

    get admin_boss_character_url(boss_character.id)

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
end
