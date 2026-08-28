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
    characters_per_page = Character.all.page(1).per(3)

    expected_pagination = {
      next_page: characters_per_page.next_page,
      total_page: characters_per_page.total_pages,
      current_page: characters_per_page.current_page
    }

    assert_equal 3, response.parsed_body[:characters].count
    assert_equal expected_pagination.as_json, response.parsed_body[:pagination]
  end

  test "Should be able to paginate and filter " do
    get api_v1_characters_url(page: 1, per_page: 1, rarity: 4)

    assert_response :success
    expected_pagination = {
      next_page: 2,
      total_page: Character.where(rarity: 4).all.page(1).per(1).total_pages,
      current_page: 1
    }

    assert_equal 1, response.parsed_body[:characters].count
    assert_equal [ 4 ], response.parsed_body[:characters].map { |character| character[:rarity] }.uniq
    assert_equal expected_pagination.as_json, response.parsed_body[:pagination]
  end

  test "Should render an error message when the parameter 'per_page' is set to zero" do
    get api_v1_characters_url(page: 1, per_page: 0)

    assert_response :unprocessable_entity

    expected_error_message = I18n.t("api.error.pagination.value_per_page_is_set_to_zero")
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

  test "Should return an empty array when there are no characters on the page you're on" do
    get api_v1_characters_url(page: 600, per_page: Character.count)
    assert_response :ok

    expected_result = {
      next_page: nil,
      total_page: 1,
      current_page: 600
     }

    assert_equal [], response.parsed_body[:characters]
    assert_equal expected_result.as_json, response.parsed_body[:pagination]
  end
end
