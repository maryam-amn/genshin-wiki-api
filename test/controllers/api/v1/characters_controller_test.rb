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

    assert_equal [ "Fontaine" ], response.parsed_body[:characters].map { |character| character[:region] }.uniq
  end

  test "Should be able to filter by rarity and render all character from that rarity"  do
    get api_v1_characters_url(rarity: 4)

    assert_response :success

    assert_equal [ 4 ], response.parsed_body[:characters].map { |character| character[:rarity] }.uniq
  end

  test "Should be able to filter by type of character and render all character from that type"  do
    get api_v1_characters_url(characterable_type: "PlayableCharacter")

    assert_response :success

    assert_equal [ "PlayableCharacter" ], response.parsed_body[:characters].map { |character| character[:character_type] }.uniq
  end

  test "Should be able to filter using two different filters and return all matching objects"  do
    get api_v1_characters_url(rarity: 4, region: "Fontaine")

    assert_response :success

    assert_equal [ 4 ], response.parsed_body[:characters].map { |character| character[:rarity] }.uniq
    assert_equal [ "Fontaine" ], response.parsed_body[:characters].map { |character| character[:region] }.uniq
  end


  test "Should return an empty array if no characters are found for the given filters" do
    get api_v1_characters_url(rarity: 7)

    assert_response :ok

    expected_result = []

    assert_equal expected_result, response.parsed_body[:characters]
  end

  test "Should render an message when the the spelling of the search query is incorrect" do
    get api_v1_characters_url(region: "Fontain")

    assert_response :unprocessable_entity

    details_message = "Invalid parameter 'region'"

    assert_includes response.parsed_body[:error], details_message
  end

  test "index should be able to paginate" do
    get api_v1_characters_url(page: 1, per_page: 3)

    assert_response :success
    expected_pagination = {
      next_page: 2,
      last_page: 2,
      current_page: 1
    }

    assert_equal 3, response.parsed_body[:characters].count
    assert_equal expected_pagination.as_json, response.parsed_body[:pagination].as_json
  end

  test "Should be able to paginate and filter " do
    get api_v1_characters_url(page: 1, per_page: 1, rarity: 4)

    assert_response :success
    expected_pagination = {
      next_page: 2,
      last_page: 2,
      current_page: 1
    }

    assert_equal 1, response.parsed_body[:characters].count
    assert_equal [ 4 ], response.parsed_body[:characters].map { |character| character[:rarity] }.uniq
    assert_equal expected_pagination.as_json, response.parsed_body[:pagination].as_json
  end

  test "Should render an error message when the parameter 'per_page' is set to zero" do
    get api_v1_characters_url(page: 1, per_page: 0)

    assert_response :unprocessable_entity

    expected_error_message = I18n.t("Api.error.pagination.value_per_page_is_set_to_zero")
    expected_details_message = "Current page was incalculable"

    assert_equal expected_error_message.as_json, response.parsed_body[:error]

    assert_includes response.parsed_body[:details][:field].to_s, expected_details_message
  end

  test "Should return an error message if the value of a parameter has no value or is nil" do
    get api_v1_characters_url + "?page=nil"

    assert_response :unprocessable_entity

    expected_error_message = "Invalid parameter 'page'"
    assert_includes response.parsed_body[:error], expected_error_message
  end
end
