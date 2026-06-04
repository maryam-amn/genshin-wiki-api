require "test_helper"

class PlayableCharacterTest < ActiveSupport::TestCase
  test "Should create a new playable character" do
    playable_character  = PlayableCharacter.create(base_hp: 1000, base_defense: 2000, base_attack: 20, is_limited: true)
    assert playable_character.valid?
  end

  test "Shouldn't create a new playable character if there isn't a base health" do
    playable_character  = PlayableCharacter.create(base_defense: 2000, base_attack: 20)
    assert_not playable_character.valid?
  end

  test " Shouldn create a playable character if there isn't a base attack" do
    playable_character = PlayableCharacter.create(base_hp: 100, base_defense: 2000)
    assert_not playable_character.valid?
  end

  test "Shouldn't create a new playable character if there isn't a base defense" do
    playable_character = PlayableCharacter.create(base_hp: 100, base_attack: 2000, is_limited: true)
    assert_not playable_character.valid?
  end
end
