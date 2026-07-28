class CreateBossCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :boss_characters do |t|
      t.boolean :is_weekly_boss, default: false
      t.string :location
      t.integer :recommended_level

      t.timestamps
    end
  end
end
