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
  test "Should view a playable character if we find their ID" do
    playable_character = playable_characters(:charlotte_from_fontaine_region)
    get api_v1_playable_character_url(id: playable_character.id)

    assert_response :success

    playable_character_to_json = PlayableCharacterJson.new(playable_character:).to_h

    assert_equal response.parsed_body, playable_character_to_json.as_json
  end

  test "Shouldn't be able to see a playable character if we can't find their ID and should return an error" do
    get api_v1_playable_character_url(id: 0)

    assert_response :not_found

    error_message = I18n.t("Playable_Characters.errors.record_not_found")

    assert_includes response.parsed_body[:error], error_message.as_json
  end
end
