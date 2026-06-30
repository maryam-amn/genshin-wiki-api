# frozen_string_literal: true

require "test_helper"

class Api::V1::PlayableCharactersControllerTest < ActionDispatch::IntegrationTest
  test "Should get all playable characters" do
    get api_v1_playable_characters_url

    assert_response :success
    assert_match(/json/, response.header["Content-Type"])

    playable_character = playable_characters(:yanfei_from_fontaine_region)
    playable_characters_to_json = PlayableCharacterJson.new(playable_character:).to_h

    assert_includes response.parsed_body["playable_characters"], playable_characters_to_json.as_json
    assert_equal PlayableCharacter.count,  response.parsed_body["playable_characters"].count
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

  test "Should be able to create a playable character on the api " do
    assert_difference [ -> { PlayableCharacter.count }, -> { Character.count } ], +1  do
    post api_v1_playable_characters_path, params: {  "name": "Venti",
                                                       "description": "Venti est un barde à l'esprit libre, un amateur du vin de Mondstadt et la forme mortelle actuelle de Barbatos, l'Archon Anémo",
                                                       "rarity": 5,
                                                       "region": "Montstadt",
                                                       "base_hp": 819.86,
                                                       "base_defense": 52.05,
                                                       "base_attack": 20.48,
                                                       "is_limited": true
                                                    }
    end

    assert_response :success

    playable_character = PlayableCharacter.last

    playable_character_to_json = PlayableCharacterJson.new(playable_character:).to_h

    assert_equal response.parsed_body, playable_character_to_json.as_json
  end

  test "Shouldn't be able to create a playable character if there are multiple missing required fields" do
    assert_difference [ -> { PlayableCharacter.count }, -> { Character.count } ], 0 do
    post api_v1_playable_characters_path, params: {  "name": "",
                                                     "description": "Charlotte est un personnage Cryo 4 étoile, journaliste pour L'Oiseau de vapeur, le célébre journal de Fontaine",
                                                     "rarity": 4,
                                                     "region": "Monstadt",
                                                     "base_hp": "",
                                                     "base_defense": 1.78,
                                                     "base_attack": 1.51,
                                                     "is_limited": true
    }
    end

    assert_response :unprocessable_entity

    error_message = { error: I18n.t("Playable_Characters.create.record_invalid"), details: { field: [ "Validation failed: Base hp can't be blank" ] } }

    assert_equal response.parsed_body, error_message.as_json

    assert_not_equal  PlayableCharacter.last&.base_defense.to_f, 1.78
    assert_not_equal  PlayableCharacter.last&.name.to_s, ""
  end

  test "Shouldn't be able to create a playable characters if a character's field is missing" do
    assert_difference [ -> { PlayableCharacter.count }, -> { Character.count } ], 0 do
    post api_v1_playable_characters_path, params: {  "name": "",
                                                     "description": "Charlotte est un personnage Cryo 4 étoile, journaliste pour L'Oiseau de vapeur, le célébre journal de Fontaine",
                                                     "rarity": 3,
                                                     "region": "Fontaine",
                                                     "base_hp": 35.6,
                                                     "base_defense": 45.78,
                                                     "base_attack": 14.51,
                                                     "is_limited": true
    }
    end

    assert_response :unprocessable_entity

    error_message = { error: I18n.t("Playable_Characters.create.record_invalid"), details: { field: [ "Validation failed: Name can't be blank" ] } }

    assert_equal response.parsed_body, error_message.as_json

    assert_not_equal PlayableCharacter.last&.name.to_s, ""
    assert_not_equal PlayableCharacter.last&.base_hp.to_s, 35.6
  end

  test "Shouldn't create a playable character with the same name as another one" do
    assert_difference [ -> { PlayableCharacter.count }, -> { Character.count } ], 0 do
    post api_v1_playable_characters_path, params: { "name": "Charlotte",
                                                     "description": "Charlotte est un personnage Cryo 4 étoile, journaliste pour L'Oiseau de vapeur, le célébre journal de Fontaine",
                                                     "rarity": 3,
                                                     "region": "Fontaine",
                                                     "base_hp": 50,
                                                     "base_defense": 45.78,
                                                     "base_attack": 14.51,
                                                     "is_limited": true
    }
    end

    assert_response :unprocessable_entity

    error_message = { error: I18n.t("Playable_Characters.create.record_invalid"), details: { field: [ "Validation failed: Name has already been taken" ] } }

    assert_equal response.parsed_body, error_message.as_json

    assert_not_equal  PlayableCharacter.last&.rarity.to_f, 3
    assert_not_equal  PlayableCharacter.last&.base_hp.to_f, 50
  end
end
