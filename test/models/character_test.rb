require "test_helper"

class CharacterTest < ActiveSupport::TestCase
  test "Should create a new character" do
    character = Character.new(name: "Ayato",
                              description: " un personnage 5 étoiles Hydro jouable dans Genshin Impact, épéiste à une main et chef du Clan Kamisato à Inazuma.",
                              rarity: 5,
                              region: "Montstadt")

    assert character.rarity.between?(0, 5)
    assert character.valid?
  end

  test "Shouldn't create a character if there isn't a name" do
    character = Character.new(description: "un personnage", rarity: 5)
    assert_not character.valid?
  end

  test "Shouldn't create a character with the same name" do
    character = Character.new(name: "Furina", description: "un personnage 5 étoiles", rarity: 5)
    assert_not character.valid?
  end

  test "Shouldn't create a character if there isn't a description" do
    character = Character.new(name: "Yelan", rarity: 5)
    assert_not character.valid?
  end

  test "Shouldn't create a character if the description is less than 20 characters" do
    character = Character.new(name: "Yelan", description: "un personnage", rarity: 5)
    assert_not character.valid?
  end

  test "Shouldn't create a new character without a rarity" do
    character = Character.new(name: "Cyno", description: "Cyno est un personnage Électro.")
    assert_not character.valid?
  end

  test "Shouldn't create a character when the character's rarity isn't a number" do
    character = Character.new(name: "Cyno", description: "Cyno est un personnage Électro.", rarity: "top")
    assert_not character.valid?
  end
end
