require "test_helper"

class BossCharacterTest < ActiveSupport::TestCase
  test "Should be able to create a boss character" do
    boss_character = BossCharacter.create(is_weekly_boss: true, location: "Inazume - [Donjon «Ruines éparses»]", recommended_level: 30)
    assert boss_character.valid?
  end

  test "Should not be able to create a boss character if there isn't a location" do
    boss_character = BossCharacter.create(is_weekly_boss: true, recommended_level: 30)
    assert_not boss_character.valid?
  end

  test "Should not be able to create a boss character if there isn't a recommended level" do
    boss_character = BossCharacter.create(is_weekly_boss: true, location: "Inazume - [Donjon «Ruines éparses»]")
    assert_not boss_character.valid?
  end

  test "Should not be able to create a boss character if weekly_boss isn't set to ‘true’ or ‘false’" do
    boss_character = BossCharacter.create(location: "Inazume - [Donjon «Ruines éparses»]", recommended_level: 30)
    assert_not boss_character.valid?
  end
end
