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
end
