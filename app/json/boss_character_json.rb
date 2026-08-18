class BossCharacterJson
  def initialize(boss_character:)
    @boss_character = boss_character
  end

  def to_h
    {
      id: @boss_character.id,
      character_id: @boss_character.character.id,
      name: @boss_character.name,
      rarity: @boss_character.rarity,
      region: @boss_character.region,
      description: @boss_character.description,
      fight_region_location: @boss_character.fight_region_location,
      fight_exact_location: @boss_character.fight_exact_location,
      is_weekly_boss: @boss_character.is_weekly_boss,
      recommended_level: @boss_character.recommended_level
    }
  end
end
