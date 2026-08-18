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
end
