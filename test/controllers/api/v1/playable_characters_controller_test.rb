# frozen_string_literal: true

require "test_helper"

class Api::V1::PlayableCharactersControllerTest < ActionDispatch::IntegrationTest
  test "Should get all playable characters" do
    get api_v1_playable_characters_url

    assert_response :success
    assert_match(/json/, response.header["Content-Type"])

    playable_character = playable_characters(:yanfei_from_fontaine_region)
    playable_characters_to_json = PlayableCharacterJson.new(playable_character:).to_h

    assert_includes response.parsed_body["playable_character"], playable_characters_to_json.as_json
    assert_equal PlayableCharacter.count,  response.parsed_body["playable_character"].count
  end
end
