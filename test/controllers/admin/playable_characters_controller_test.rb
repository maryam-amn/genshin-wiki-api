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

  test "Should be able to update a playable character if we change the value of a field" do
    sign_in users(:admin_users)
    playable_character = playable_characters(:yanfei_from_fontaine_region)

    patch admin_playable_character_path(id: playable_character.id), params: {
        playable_character: {
          description: "Yanfei est un personnawwwge Pyro 4 étoiles de Gens...",
          name: "Yanfei",
          rarity: 4,
          region: "Fontaine",
          base_hp: 150,
          base_defense: 150,
          base_attack: 159
          } }

    assert_response :redirect

    assert_redirected_to admin_playable_character_path(playable_character.id)

     playable_character.reload

    assert_includes flash[:notice], I18n.t("Playable_Characters.update.notice")

    assert_equal 150.0, playable_character.base_hp
    assert_equal "Fontaine", playable_character.character.region
  end

  test "Could be able to update a playable character if we change the value of a field" do
    sign_in users(:admin_users)
    playable_character = playable_characters(:charlotte_from_fontaine_region)

    patch admin_playable_character_path(id: playable_character.id), params: {
      playable_character: {
        description: "Charlotte est un personnage Cryo 4 étoile, journaliste pour L'Oiseau de vapeur, le célébre journal de Fontaine",
        name: "Charlotte",
        rarity: 4,
        region: "Liyue",
        base_hp: 159,
        base_defense: 45.78,
        base_attack: 	14.51
      } }

    assert_response :redirect

    assert_redirected_to admin_playable_character_path(playable_character.id)

    playable_character.reload

    assert_includes flash[:notice], I18n.t("Playable_Characters.update.notice")

    assert_equal 159.0, playable_character.base_hp
    assert_equal "Liyue", playable_character.character.region
  end

  test "Shouldn't be able to update a playable character if the field is blank" do
    sign_in users(:admin_users)
    playable_character = playable_characters(:yanfei_from_fontaine_region)

    patch admin_playable_character_path(id: playable_character.id), params: {
      playable_character: {
        description: "Yanfei est un personnawwwge Pyro 4 étoiles de Gens...",
        name: "Yanfei",
        rarity: 4,
        region: "",
        base_hp: 150,
        base_defense: 150,
        base_attack: ""
      } }
    assert_response :redirect

    assert_redirected_to edit_admin_playable_character_path

    playable_character.reload
    assert_includes flash[:alert], I18n.t("Playable_Characters.update.record_invalid")

    assert_not_equal "", playable_character.region
    assert_not_equal "", playable_character.base_attack
  end

  test "Can't update a playable character if the field is blank" do
    sign_in users(:admin_users)
    playable_character = playable_characters(:yanfei_from_fontaine_region)

    put admin_playable_character_path(id: playable_character.id), params: {
      playable_character: {
        description: "Charlotte est un personnage Cryo 4 étoile, journaliste pour L'Oiseau de vapeur, le célébre journal de Fontaine",
        name: "Charlotte",
        rarity: 4,
        region: "",
        base_hp: 159,
        base_defense: 45.78,
        base_attack: 	""
      }
    }

    assert_response :redirect

    assert_redirected_to edit_admin_playable_character_path

    playable_character.reload
    assert_includes flash[:alert], I18n.t("Playable_Characters.update.record_invalid")

    assert_not_equal "", playable_character.region
    assert_not_equal "", playable_character.base_attack
  end
end
