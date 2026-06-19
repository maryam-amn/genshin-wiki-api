require "test_helper"

class Admin::PlayableCharactersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "Should be able to create a playable characters when the user is logged in" do
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

  test "we shouldn't be able to create a playable characters when a field is blank" do
    sign_in users(:admin_users)

    playable_characters =  PlayableCharacter.new(base_hp: "150", base_defense: 150, base_attack: "")
    character = Character.create(name: "Ganyu", region: "", description: "un personnage 5 étoiles", rarity: "3", characterable: playable_characters)

    assert_predicate playable_characters, :invalid?
    assert_predicate character, :invalid?

    assert_equal :region, character.errors.first.attribute
    assert_equal :blank, character.errors.first.type

    assert_equal :base_attack, playable_characters.errors.first.attribute
    assert_equal :blank, playable_characters.errors.first.type

    assert_not_includes Character.last&.name.to_s, "Ganyu"
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
