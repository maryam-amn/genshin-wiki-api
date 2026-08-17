class ChangeColumnBossCharacterLocation < ActiveRecord::Migration[8.1]
  def change
    create_enum :fight_region_locations, %w[ Liyue Montstadt Inazuma Sumeru Fontaine Natlan Nod-Krai Snezhnaya Khaenri'ah]

    add_column :boss_characters, :fight_region_location, :enum, enum_type: "fight_region_locations",  null: false

    add_column :boss_characters, :fight_exact_location, :string
  end
end
