# frozen_string_literal: true

require "test_helper"

class PlayableCharacterJsonTest < ActiveSupport::TestCase
  test "Should get all playable character json" do
    playable_character = playable_characters(:charlotte_from_fontaine_region)

    expected_json =
      {
        playable_character_id: 944569428,
        character_id: 944569428,
        name: "Charlotte",
        description: "Charlotte est un personnage Cryo 4 étoile, journaliste pour L'Oiseau de vapeur, le célébre journal de Fontaine",
        rarity: 4,
        region: "Fontaine",
        base_hp: 902.67,
        base_defense: 45.78,
        base_attack: 14.51,
        is_limited: true
      }

    character_to_json = PlayableCharacterJson.new(playable_character:).to_h

    assert_equal expected_json, character_to_json
  end
end
