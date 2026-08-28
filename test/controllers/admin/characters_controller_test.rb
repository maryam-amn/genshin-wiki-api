require "test_helper"

class Admin::CharactersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin_users)
  end

  test "Should get index and show information of all characters when the user is logged in " do
    get admin_characters_url

    assert_response :success
    character = characters(:charlotte_from_fontaine_region)
    assert_includes response.body, character.name
    assert_select("td.col.col-description", character.description)
  end

  test "shouldn't get index and show information when the user isn't logged in" do
    sign_out :user

    get admin_characters_url

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "Should redirect to the playable character show page" do
    playable_character = characters(:charlotte_from_fontaine_region)

    get admin_character_url(playable_character.id)

    assert_response :redirect

    assert_redirected_to admin_playable_character_path(playable_character.characterable_id)
  end

  test "Should redirect to the playable character edit page when a user is logged in" do
    playable_character = characters(:charlotte_from_fontaine_region)

    get edit_admin_character_url(playable_character.id)

    assert_response :redirect

    assert_redirected_to edit_admin_playable_character_path(playable_character.characterable_id)
  end

  test "Should redirect to the boss character show page" do
    boss_character = characters(:signora_from_mondsatdt)

    get admin_character_url(boss_character.id)

    assert_response :redirect

    assert_redirected_to admin_boss_character_path(boss_character.characterable_id)
  end

  test "Should redirect to the boss edit page when a user is logged in" do
    boss_character = characters(:signora_from_mondsatdt)

    get edit_admin_character_url(boss_character.id)

    assert_response :redirect

    assert_redirected_to edit_admin_boss_character_path(boss_character.characterable_id)
  end
end
