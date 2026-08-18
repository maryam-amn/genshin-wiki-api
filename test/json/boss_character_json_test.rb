require "test_helper"

class BossCharacterJsonTest  < ActiveSupport::TestCase
  test "Should get a boss character serialized in JSON" do
    boss_character = boss_characters(:andrius_from_mondsatdt)

    expected_json = {
      id: 1016727073,
      character_id: 805628297,
      name: "Andrius",
      rarity: 0,
      region: "Montstadt",
      description: "Andrius, aussi connu sous le nom de “Loup du Nord” ou “Borée”, est un ancien dieu de Mondstadt et un boss hebdomadaire de Genshin Impact. Il protège le Royaume des Loups et veille avec bienveillance sur Razor. Il est le plus noble et le plus beau des âmes qui veillent sur le Lupical. Quand la meute est en péril, il émerge sous la forme d'un loup d'hydro et de cryo pour montrer ses crocs et ses griffes. Les humains ont rarement l'occasion de croiser le regard d'un loup, ainsi en a décidé le Loup du Nord.",
      fight_region_location: "Montstadt",
      fight_exact_location: "Territoire des Loups",
      is_weekly_boss: true,
      recommended_level: 50
    }

    boss_character_to_json = BossCharacterJson.new(boss_character:).to_h
    assert_equal expected_json, boss_character_to_json
  end
end
