class PlayableCharacterJson
  def initialize(playable_character:)
    @playabe_characteral = playable_character
  end

  def to_h
    {
      playable_character_id: @playabe_characteral.id,
      character_id: @playabe_characteral.character.id,
      name: @playabe_characteral.name,
      description: @playabe_characteral.description,
      rarity: @playabe_characteral.rarity,
      region: @playabe_characteral.region,
      base_hp: @playabe_characteral.base_hp,
      base_defense: @playabe_characteral.base_defense,
      base_attack: @playabe_characteral.base_attack,
      is_limited: @playabe_characteral.is_limited
    }
  end
end
