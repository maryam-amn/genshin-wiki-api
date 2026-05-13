require "test_helper"

class Admin::CharactersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "Should get index and show information of all characters when the user is logged in " do
    sign_in users(:admin_users)

    get admin_characters_url

    assert_response :success
    character = characters(:charlotte_from_fontaine_region)
    assert_includes response.body, character.name
    assert_select("td.col.col-description", character.description)
  end

  test "shouldn't get index and show information when the user isn't logged in" do
    sign_out :user

    get admin_characters_url

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "we should be able to create a new user" do
    sign_in users(:admin_users)

    assert_difference -> { Character.count } => +1 do
      post admin_characters_path, params: {
        character: {
          name: "Fischl",
          region: "Montstadt",
          rarity: "3",
          description: "un personnage 3 étoiles" }
      }
    end

    assert_response :redirect

    assert_includes Character.last&.name.to_s, "Fischl"
  end

  test "we shouldn't be able to create a new character when the user isn't logged in" do
    sign_out :user

    assert_difference -> { Character.count } => 0 do
      post admin_characters_path, params: {
        character: {
          name: "Yelan",
          region: "Montstadt",
          rarity: "3",
          description: "un personnage 3 étoiles" }
      }
    end

    assert_response :redirect
    assert_not_includes Character.last&.name.to_s, "Yelan"
  end

  test "Can't create a new character when a field is blank " do
    sign_in users(:admin_users)

    character = Character.new(name: "Ganyu", region: "Liyue", description: "un personnage 5 étoiles", rarity: "")

    assert_predicate character, :invalid?
    assert_equal :rarity, character.errors.first.attribute
    assert_equal :blank, character.errors.first.type
    assert_not_includes Character.last&.name.to_s, "Ganyu"
  end
end
