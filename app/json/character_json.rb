class CharacterJson
  def initialize(character:)
    @character = character
  end

  def to_h
    {
      id: @character.id,
      name: @character.name,
      description: @character.description,
      rarity: @character.rarity,
      region: @character.region,
      character_type:  @character.characterable_type
    }
  end
end
