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

  test "Should create a new boss character if all the fields have been completed" do
    assert_difference -> { Character.count } => +1, -> { BossCharacter.count } => +1 do
      post admin_boss_characters_path, params: {
        boss_character: {
          name: "Fischl",
          region: "Montstadt",
          rarity: 3,
          description: "un personnage 3 étoiles",
          is_weekly_boss: true,
          recommended_level: 50,
          fight_region_location: "Fontaine",
          fight_exact_location: "la chambre des secret"
        }
      }
    end

    assert_response :redirect

    assert_redirected_to admin_boss_character_path(BossCharacter.last.id)

    assert_equal flash[:notice], I18n.t("boss_characters.new.notice")

    assert_equal  BossCharacter.last&.recommended_level, 50
    assert_equal  BossCharacter.last&.name.to_s, "Fischl"
  end

  test "Shouldn't be able to create a boss character if the character's field aren't valid" do
    assert_difference -> { Character.count } => 0, -> { BossCharacter.count } => 0 do
      post admin_boss_characters_path, params: {
        boss_character: {
          name: "Fischl",
          region: "",
          rarity: "",
          description: "un personnage 3 étoiles",
          is_weekly_boss: true,
          recommended_level: 50,
          fight_region_location: "Fontaine",
          fight_exact_location: "la chambre des secret "
        }
      }
      end

    assert_response :redirect

    assert_redirected_to new_admin_boss_character_path

    assert_includes flash[:error], "#{I18n.t("boss_characters.new.record_invalid")}, Validation failed:"
  end

  test "Shouldn't be able to create a boss character if the boss's filed aren't valid" do
    assert_difference -> { Character.count } => 0, -> { BossCharacter.count } => 0 do
      post admin_boss_characters_path, params: {
        boss_character: {
          name: "Fischl",
          region: "Fontaine",
          rarity: 2,
          description: "un personnage 3 étoiles",
          is_weekly_boss: true,
          recommended_level: "",
          fight_region_location: "Montstadt",
          fight_exact_location: ""
        }
      }
    end

    assert_response :redirect
    assert_redirected_to new_admin_boss_character_path
    assert_includes flash[:error], "#{I18n.t("boss_characters.new.record_invalid")}, Validation failed:"
  end
end
