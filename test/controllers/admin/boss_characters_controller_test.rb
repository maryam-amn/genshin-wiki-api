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

  test "Should be able to delete a boss character" do
    boss_character = boss_characters(:andrius_from_mondsatdt)

    assert_difference -> { Character.count } => -1, -> { BossCharacter.count } => -1 do
      delete admin_boss_character_path(boss_character.id)
    end
    assert_response :redirect

    assert_redirected_to admin_characters_path
    assert_equal flash[:notice], I18n.t("boss_characters.destroy.notice")
  end

  test "Shouldn't be able to delete a boss character if the character is a legendary one" do
    boss_character = boss_characters(:signora_from_mondsatdt)

    assert_difference -> { Character.count } => 0, -> { BossCharacter.count } => 0 do
      delete admin_boss_character_path(boss_character.id)
    end
    assert_response :redirect

    assert_redirected_to admin_boss_character_path(boss_character.id)
    assert_includes flash[:error], boss_character.character.errors[:base].to_a.join
  end

  test "Shouldn't be able to delete a boss character if the character doesn't exist" do
    assert_difference -> { Character.count } => 0, -> { BossCharacter.count } => 0 do
      delete admin_boss_character_path(0)
    end
    assert_response :redirect

    assert_redirected_to admin_characters_path
    assert_includes flash[:error], I18n.t("boss_characters.active_record_error.record_not_found")
  end

  test "Should be able to update a boss character using a PATCH request" do
    boss_character = boss_characters(:signora_from_mondsatdt)

    patch admin_boss_character_path(id: boss_character.id), params: {
      boss_character: {
        description: "Signora ou par son alias « La Demoiselle », était la Huitième Exécutrice des Fatui.",
        rarity: 4,
        is_weekly_boss: false,
        fight_exact_location: "Donjon «Chambre d'Or»"
      }
    }

    assert_response :redirect
    assert_redirected_to admin_boss_character_path(boss_character.id)

    boss_character.reload
    assert_equal flash[:notice], I18n.t("boss_characters.update.notice")

    assert_equal 4, boss_character.rarity
    assert_equal "Donjon «Chambre d'Or»", boss_character.fight_exact_location
  end

  test "Shouldn't be able to update a boss character when a required field is missing using a PATCH request" do
    boss_character = boss_characters(:andrius_from_mondsatdt)

    patch admin_boss_character_path(boss_character.id), params: {
      boss_character: {
        description: "Andrius, aussi connu sous le nom de “Loup du Nord” ou “Borée”, est un ancien dieu de Mondstadt.",
        rarity: 3,
        is_weekly_boss: false,
        fight_region_location: ""
      }
    }

    assert_response :redirect
    assert_redirected_to edit_admin_boss_character_path

    boss_character.reload

    assert_includes flash[:error], I18n.t("boss_characters.update.record_invalid")

    assert_not_equal 3, boss_character.rarity
    assert_not_equal false, boss_character.is_weekly_boss
  end

  test "Shouldn't be able to update a boss character when a validation failed using the PATCH request" do
    boss_characters = boss_characters(:signora_from_mondsatdt)

    patch admin_boss_character_path(boss_characters.id), params: {
      boss_character: {
        description: "Signora ou par son alias « La Demoiselle », était la Huitième Exécutrice des Fatui.",
        rarity: 9,
        is_weekly_boss: false
      }
    }

    assert_response :redirect
    assert_redirected_to edit_admin_boss_character_path(boss_characters.id)

    assert_includes flash[:error], I18n.t("boss_characters.update.record_invalid")

    assert_not_equal 9, boss_characters.rarity
    assert_not_equal false, boss_characters.is_weekly_boss
  end

  test "Should be able to update a boss character using a PUT request" do
    boss_character = boss_characters(:signora_from_mondsatdt)

    put admin_boss_character_path(boss_character.id), params: {
      boss_character: {
        name: "Signora",
        region: "Montstadt",
        rarity: 3,
        description: "Rosalyne-Kruzchka Lohefalter, également appelée Signora, était la Huitième Exécutrice des Fatui.",
        is_weekly_boss: true,
        recommended_level: 30,
        fight_region_location: "Inazuma",
        fight_exact_location: "Donjon «Chambre d'Or»"
      }
    }

    assert_response :redirect
    assert_redirected_to admin_boss_character_path(boss_character.id)

    boss_character.reload
    assert_equal flash[:notice], I18n.t("boss_characters.update.notice")

    assert_equal 3, boss_character.rarity
    assert_equal "Donjon «Chambre d'Or»", boss_character.fight_exact_location
  end

  test "Shouldn't be able to update a boss character when a required field is missing using a PUT request" do
    boss_character = boss_characters(:signora_from_mondsatdt)

    put admin_boss_character_path(boss_character.id), params: {
      boss_character: {
        name: "Signora",
        region: "Montstadt",
        rarity: 3,
        description: "Rosalyne-Kruzchka Lohefalter, également appelée Signora, était la Huitième Exécutrice des Fatui.",
        is_weekly_boss: true,
        recommended_level: 30,
        fight_region_location: "Montstadt",
        fight_exact_location: ""
      }
    }

    assert_response :redirect

    assert_redirected_to edit_admin_boss_character_path(boss_character.id)
    boss_character.reload
    assert_includes flash[:error], I18n.t("boss_characters.update.record_invalid")

    assert_not_equal 3, boss_character.rarity
    assert_not_equal "Montstadt", boss_character.fight_region_location
  end

  test "Shouldn't be able to update a boss character when a validation failed using a PUT request" do
    boss_character = boss_characters(:signora_from_mondsatdt)

    put admin_boss_character_path(boss_character.id), params: {
      boss_character: {
        name: "Stormterror",
        region: "Montstadt",
        rarity: 3,
        description: "Rosalyne-Kruzchka Lohefalter, également appelée Signora, était la Huitième Exécutrice des Fatui.",
        is_weekly_boss: true,
        recommended_level: 32,
        fight_region_location: "Liyue",
        fight_exact_location: "l'île Narukami «Tenshukaku»"
      }
    }
    assert_response :redirect
    assert_redirected_to edit_admin_boss_character_path(boss_character.id)

    assert_includes flash[:error], I18n.t("boss_characters.update.record_invalid")

    assert_not_equal 3, boss_character.rarity
    assert_not_equal 32, boss_character.recommended_level
  end
end
