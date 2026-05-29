class CreatePlayableCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :playable_characters do |t|
      t.float :base_hp
      t.float :base_attack
      t.float :base_defense
      t.boolean :is_limited, default: false  # used to know if a character is part of the limited banner

      t.timestamps
    end
  end
end
