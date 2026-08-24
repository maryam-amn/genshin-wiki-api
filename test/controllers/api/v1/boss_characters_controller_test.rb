# frozen_string_literal: true

require "test_helper"

class Api::V1::BossCharacterControllerTest < ActionDispatch::IntegrationTest
  test "Should get all boss characters" do
    get api_v1_boss_characters_url

    assert_response :success
    assert_match(/json/, response.header["Content-Type"])

    boss_character = boss_characters(:andrius_from_mondsatdt)
    boss_character_to_json = BossCharacterJson.new(boss_character:).to_h

    assert_includes response.parsed_body["boss_characters"], boss_character_to_json.as_json
    assert_equal BossCharacter.count,  response.parsed_body["boss_characters"].count
  end

  test "Should render a boss character if we can find the boss character's ID" do
    boss_character = boss_characters(:andrius_from_mondsatdt)

    get api_v1_boss_character_url(id: boss_character.id)

    assert_response :success

    expected_response = BossCharacterJson.new(boss_character:).to_h

    assert_equal expected_response.as_json, response.parsed_body
  end

  test "Should render an error message if we cannot find the boss character's ID" do
    get api_v1_boss_character_url(id: 0)

    assert_response :not_found

    expected_error_message = I18n.t("boss_characters.active_record_error.record_not_found")

    assert_equal expected_error_message.as_json, response.parsed_body[:error]
  end

  test "Should be able to create a new boss character" do
    assert_difference [ -> { BossCharacter.count }, -> { Character.count } ], +1  do
      post api_v1_boss_characters_url, params: {
          name: "lll",
          region: "Montstadt",
          rarity: 3,
          description: "Rosalyne-Kruzchka Lohefalter, également appelée Signora, était la Huitième Exécutrice des Fatui.",
          is_weekly_boss: true,
          recommended_level: 32,
          fight_region_location: "Liyue",
          fight_exact_location: "l'île Narukami «Tenshukaku»"
      }
    end
    assert_response :success

    boss_character = BossCharacter.last
    boss_character_to_json =  BossCharacterJson.new(boss_character:).to_h
    assert_equal response.parsed_body, boss_character_to_json.as_json
  end

  test "Should not be able to create a boss character if a character's field validation failed" do
    assert_difference -> { Character.count } => 0, -> { BossCharacter.count } => 0 do
      post api_v1_boss_characters_url, params: {
        name: "",
        region: "Montstadt",
        rarity: 3,
        description: "Rosalyne-Kruzchka Lohefalter, également appelée Signora, était la Huitième Exécutrice des Fatui.",
        is_weekly_boss: true,
        recommended_level: 32,
        fight_region_location: "Liyue",
        fight_exact_location: "l'île test"
      }
    end
    assert_response :unprocessable_entity

    expected_error_message = { error: I18n.t("boss_characters.new.record_invalid"), details: { field: [ "Validation failed: Name can't be blank" ] } }
    assert_equal response.parsed_body,  expected_error_message.as_json

    assert_not_equal BossCharacter.last.fight_exact_location, "l'île test"
    assert_not_equal BossCharacter.last.name, ""
  end

  test "Should not be able to create a boss character if validation of a boss character's field failed" do
    assert_difference -> { Character.count } => 0, -> { BossCharacter.count } => 0 do
      post api_v1_boss_characters_url, params: {
        name: "test_02",
        region: "Montstadt",
        rarity: 3,
        description: "Rosalyne-Kruzchka Lohefalter, également appelée Signora, était la Huitième Exécutrice des Fatui.",
        is_weekly_boss: false,
        recommended_level: 30,
        fight_region_location: "Liyue",
        fight_exact_location: "l'île !!"
      }
    end
    assert_response :unprocessable_entity

    expected_error_message = { error: I18n.t("boss_characters.new.record_invalid"), details: { field: [ "Validation failed: Fight exact location is invalid" ] } }
    assert_equal response.parsed_body,  expected_error_message.as_json

    assert_not_equal BossCharacter.last.fight_exact_location, "l'île !!"
    assert_not_equal BossCharacter.last.name, "test_02"
  end

  test "Should be able to delete a boss character" do
    boss_character = boss_characters(:andrius_from_mondsatdt)

    assert_difference [ -> { BossCharacter.count }, -> { Character.count } ], -1 do
      delete api_v1_boss_character_url(id: boss_character.id)
    end

    assert_response :ok
    expected_success_message = { message: I18n.t("boss_characters.destroy.notice") }
    assert_equal response.parsed_body, expected_success_message.as_json
  end

  test "Shouldn't be able to delete a boss character that doesn't exist in the database" do
    assert_difference -> { Character.count } => 0, -> { BossCharacter.count } => 0 do
      delete api_v1_boss_character_url(id: 0)
    end

    assert_response :not_found

    assert_equal response.parsed_body[:error], I18n.t("boss_characters.active_record_error.record_not_found")
  end

  test "Shouldn't be able to delete a boss character who's a legendary one" do
    boss_character = boss_characters(:signora_from_mondsatdt)

    assert_difference -> { Character.count } => 0, -> { BossCharacter.count } => 0 do
      delete api_v1_boss_character_url(id: boss_character.id)
    end

    assert_response :unprocessable_entity

    assert_includes response.parsed_body[:error], I18n.t("boss_characters.active_record_error.record_not_destroyed")

    assert_includes response.parsed_body[:details][:field].to_json, I18n.t("characters.destroy.should_not_delete_legendary_character")
  end
end
