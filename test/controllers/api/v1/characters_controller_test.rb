# frozen_string_literal: true

require "test_helper"

class Api::V1::CharactersControllerTest < ActionDispatch::IntegrationTest
  test "Should get all characters" do
    get api_v1_characters_url

    assert_response :success

    assert_match(/json/, response.header["Content-Type"])

    character = characters(:yanfei_from_fontaine_region)
    character_to_json = CharacterJson.new(character:).to_h

    assert_includes response.parsed_body["characters"], character_to_json.as_json

    result_expected = Character.count
    assert_equal result_expected, response.parsed_body["characters"].count
  end

  test "Should render a character" do
    character = characters(:yanfei_from_fontaine_region)
    get api_v1_character_url(id: character.id)

    assert_response :success

    character_to_json = CharacterJson.new(character:).to_h

    assert_equal response.parsed_body, character_to_json.as_json
  end

  test "Should render a error if the character isn't found" do
    get api_v1_character_url(id: 0)

    assert_response :not_found

    error_message = { "message" => "Character not found" }

    assert_equal response.parsed_body, error_message.as_json
  end

  test "Should create a character and render it when all fields are filled in" do
    post api_v1_characters_url params: { character: { name: "xxxxxxx", description: "xxxxxx est un personnage Hydro jouable dans Genshin Impact", rarity: 2, region: "Liyue" } }

    assert_response :created

    character = Character.last
    character_to_json = CharacterJson.new(character:).to_h

    assert_equal response.parsed_body, character_to_json.as_json
  end

  test "Shouldn't create a character with the same name as another one" do
    post api_v1_characters_url params: { character: { name: "Yanfei", description: "Yanfei est un personnage Pyro 4 étoiles de Genshin Impact qui utilise un catalyseur", rarity: 4, region: "Liyue" } }

    assert_response :unprocessable_entity

    error_message = {
      "name": [
        "has already been taken"
      ]
    }

    assert_equal response.parsed_body, error_message.as_json
  end

  test "Shouldn't create a character when a required field is blank" do
    post api_v1_characters_url params: { character: { name: "xxxx", description: "C'est un personnage Cyro 4 étoiles", rarity: 4, region: "" } }

    assert_response :unprocessable_entity

    error_message = {
      "region": [
        "choose a region from the list, can't be blank"
      ]
    }

    assert_equal response.parsed_body, error_message.as_json
  end

  test "Should be able to delete a character" do
    character = characters(:yanfei_from_fontaine_region)

    delete api_v1_character_url(id: character.id)

    assert_response :ok

    message = { message: "Character deleted" }
    assert_equal response.parsed_body, message.as_json
  end

  test "Shouldn't be able to delete a character that doesn't exist" do
    delete api_v1_character_url(id: 0)

    assert_response :not_found

    message = { message: "Character not found" }

    assert_equal response.parsed_body, message.as_json
  end

  test "Should render a message when the character is a 5 star and was not destroy from the database" do
    character = characters(:eula_from_mondsatdt)

    delete api_v1_character_url(id: character.id)

    assert_response :unprocessable_entity

    error_message = I18n.t("Characters.destroy.should_not_delete_legendary_character")

    assert_includes response.parsed_body[:message], error_message.as_json
  end

  test "Should be able to update a character" do
    character = characters(:eula_from_mondsatdt)

    patch api_v1_character_url(id: character.id),
          params: { description: "Eula Lawrence est un personnage Cryo jouable dans Genshin Impact" }

    assert_response :success

    character.reload

    character_to_json = CharacterJson.new(character:).to_h

    assert_equal response.parsed_body, character_to_json.as_json
  end

   test "Shouldn't be able to update a character that doesn't exist" do
     patch api_v1_character_url(id: 0),
           params: { description:  "Eula Lawrence est un personnage Cryo jouable dans Genshin Impact" }

     assert_response :not_found

     message = { message: "Character not found" }

     assert_equal response.parsed_body, message.as_json
   end

  test "Shouldn't be able to update a character with the same name as another one" do
    character = characters(:eula_from_mondsatdt)

    patch api_v1_character_url(id: character.id), params: { name: "Yanfei" }

    assert_response :unprocessable_entity

    error_message =  "has already been taken"

    assert_includes response.parsed_body[:message], error_message.as_json
  end

  test "Should update a character" do
    character = characters(:eula_from_mondsatdt)

    put api_v1_character_url(id: character.id),
          params: { description: "Eula Lawrence est un personnage Cryo jouable dans Genshin Impact", rarity: 4, region: "Fontaine", name: "Eula" }

    assert_response :success

    character.reload

    character_to_json = CharacterJson.new(character:).to_h

    assert_equal response.parsed_body, character_to_json.as_json
  end

  test "Can't update a character that doesn't exist" do
    put api_v1_character_url(id: 0),
          params: { description:  "Eula Lawrence est un personnage Cryo jouable dans Genshin Impact", name: "Charlotte", rarity: 4, region: "Fontaine" }

    assert_response :not_found

    message = { message: "Character not found" }

    assert_equal response.parsed_body, message.as_json
  end

  test "Can't update a character with the same name as another one with" do
    character = characters(:eula_from_mondsatdt)

    put api_v1_character_url(id: character.id), params: { name: "Yanfei", description: "Eula Lawrence est un personnage Cryo jouable dans Genshin Impact", rarity: 4, region: "Fontaine" }

    assert_response :unprocessable_entity

    error_message = "has already been taken"

    assert_includes response.parsed_body[:message], error_message.as_json
  end

  test "Should be able to filter by region and render all character from that region" do
    get api_v1_characters_url(region: "Fontaine")

    assert_response :success
    assert_equal response.parsed_body[:characters].count, Character.where(region: "Fontaine").count

    assert_equal response.parsed_body[:characters].first[:region], Character.find_by(region: "Fontaine").region

    assert_equal response.parsed_body[:characters].first[:description], Character.find_by(region: "Fontaine").description
  end

  test "Should be able to filter by rarity and render all character from that rarity"  do
    get api_v1_characters_url(rarity: 4)

    assert_response :success
    assert_equal response.parsed_body[:characters].count, Character.where(rarity: 4).count

    assert_equal response.parsed_body[:characters].first[:rarity], Character.find_by(region: "Fontaine").rarity
    assert_equal response.parsed_body[:characters].first[:description], Character.find_by(region: "Fontaine").description
  end

  test "Should be able to filter by type of character and render all character from that type"  do
    get api_v1_characters_url(characterable_type: "PlayableCharacter")

    assert_response :success
    assert_equal response.parsed_body[:characters].count, Character.where(characterable_type: "PlayableCharacter").count

    assert_equal response.parsed_body[:characters].first[:character_type], Character.find_by(region: "Fontaine").characterable_type
    assert_equal response.parsed_body[:characters].first[:description], Character.find_by(region: "Fontaine").description
  end

  test "Should return an error message if no character is found using a filter" do
    get api_v1_characters_url(rarity: 7)

    assert_response :not_found

    error_message = "#{I18n.t("Characters.filter.no_characters_found")}"

    assert_equal response.parsed_body[:message], error_message
  end

  test "Should render an message when the the spelling of the search query is incorrect" do
    get api_v1_characters_url(region: "Fontain")

    assert_response :bad_request

    details_message = "invalid input value for enum regions"

    assert_includes response.parsed_body[:details][:field], details_message

    error_message = "#{I18n.t("Characters.filter.no_characters_found")}, #{I18n.t("Characters.filter.check_spelling")}"
    assert_equal response.parsed_body[:error], error_message
  end
end
