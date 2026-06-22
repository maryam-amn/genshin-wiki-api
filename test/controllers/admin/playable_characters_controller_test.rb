require "test_helper"

class Admin::PlayableCharactersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "Should be able to create a playable characters when the user is logged in and all the field are fill in" do
    sign_in users(:admin_users)

    assert_difference -> { Character.count && PlayableCharacter.count } => +1 do
      post admin_playable_characters_path, params: {
        playable_character: {
          name: "Fischl",
          region: "Montstadt",
          rarity: "3",
          description: "un personnage 3 étoiles",
          base_hp: 150,
          base_defense: 150,
          base_attack: 150
        }
      }
    end

    assert_response :redirect

    assert_redirected_to admin_playable_character_path(PlayableCharacter.last.id)
    assert_includes flash[:notice], I18n.t("Playable_Characters.create.notice")

    assert_equal  PlayableCharacter.last&.base_hp.to_f, 150.0
    assert_equal  PlayableCharacter.last&.name.to_s, "Fischl"
    end

  test "Shouldn't be able to create a playable characters when the user is not logged in" do
    sign_out :user

    assert_difference -> { Character.count && PlayableCharacter.count } => 0 do
      post admin_playable_characters_path, params: {
        playable_character: {
          name: "Fischl",
          region: "Montstadt",
          rarity: "3",
          description: "un personnage 3 étoiles",
          base_hp: 150,
          base_defense: 150,
          base_attack: 150
        }
      }
    end
    assert_response :redirect

    assert_redirected_to new_user_session_url

    assert_not_equal  PlayableCharacter.last&.base_hp.to_f, 150.0
    assert_not_equal  PlayableCharacter.last&.name.to_s, "Fischl"
  end

  test "we shouldn't be able to create a playable characters if the character's field are not valid" do
    sign_in users(:admin_users)

    assert_difference -> { Character.count && PlayableCharacter.count } => 0 do
      post admin_playable_characters_path, params: {
        playable_character: {
          name: "Fischl",
          region: "",
          rarity: "",
          description: "un personnage 3 étoiles",
          base_hp: 150,
          base_defense: 150,
          base_attack: 150
        }
      }
    end

    assert_response :redirect

    assert_redirected_to new_admin_playable_character_path

    assert_includes flash[:alert], I18n.t("Playable_Characters.create.record_invalid")
  end

  test "we shouldn't be able to create a playable characters if the playable character's field are not valid" do
    sign_in users(:admin_users)

    assert_difference -> { Character.count && PlayableCharacter.count } => 0 do
      post admin_playable_characters_path, params: {
        playable_character: {
          name: "Fischl",
          region: "Fontaine",
          rarity: "2",
          description: "un personnage 3 étoiles",
          base_hp: "",
          base_defense: "",
          base_attack: ""
        }
      }
    end

    assert_response :redirect

    assert_redirected_to new_admin_playable_character_path

    assert_includes flash[:alert], I18n.t("Playable_Characters.create.record_invalid")
  end
  test "Should be able to delete a playable character" do
    sign_in users(:admin_users)
    character = playable_characters(:yanfei_from_fontaine_region)

    assert_difference -> { PlayableCharacter.count  && Character.count }, -1  do
      delete admin_playable_character_path(id: character.id)
    end

    assert_response :redirect
    assert_redirected_to admin_characters_path

    assert_includes flash[:notice], I18n.t("Playable_Characters.destroy.notice")
  end

  test "Shouldn't be able to delete a playable character who is a 5 star" do
    sign_in users(:admin_users)
    character = playable_characters(:eula_from_mondsatdt)

    assert_difference -> { PlayableCharacter.count  && Character.count }, 0 do
      delete admin_playable_character_path(id: character.id)
    end

    assert_response :redirect
    assert_redirected_to admin_characters_path

    assert_includes flash[:alert], I18n.t("Characters.destroy.record_not_destroyed")
  end
end
