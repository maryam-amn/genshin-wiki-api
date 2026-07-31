require "test_helper"

class BossCharacterTest < ActiveSupport::TestCase
  test "Should be able to create a boss character" do
    boss_character = BossCharacter.create(is_weekly_boss: true, fight_region_location: "Liyue", fight_exact_location: "Donjon «Ruines éparses»", recommended_level: 30)
    assert boss_character.valid?
  end

  test "Should not be able to create a boss character if there isn't a region where you can fight the boss character" do
    boss_character = BossCharacter.create(is_weekly_boss: true, fight_exact_location: "Donjon «Ruines éparses»", recommended_level: 30)
    assert_not boss_character.valid?
  end

  test "Should not be able to create a boss character if there isn't a exact location to fight the boss character" do
    boss_character = BossCharacter.create(is_weekly_boss: true, fight_region_location: "Liyue", recommended_level: 30)
    assert_not boss_character.valid?
  end

  test "Should not be able to create a boss character if there isn't a recommended level" do
    boss_character = BossCharacter.create(is_weekly_boss: true, fight_region_location: "Liyue", fight_exact_location: "Donjon «Ruines éparses»")
    assert_not boss_character.valid?
  end
end
