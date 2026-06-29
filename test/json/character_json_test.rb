# frozen_string_literal: true

require "test_helper"

class CharacterJsonTest < ActiveSupport::TestCase
  test "Should get a character json" do
    character = characters(:yanfei_from_fontaine_region)

    expected_json =
      {
        id: 519887325,
        name: "Yanfei",
        description: "Yanfei est un personnage Pyro 4 étoiles de Genshin Impact qui utilise un catalyseur",
        rarity: 4,
        region: "Liyue",
        character_type: "PlayableCharacter"
      }

    character_to_json = CharacterJson.new(character:).to_h

    assert_equal expected_json, character_to_json
  end
end
