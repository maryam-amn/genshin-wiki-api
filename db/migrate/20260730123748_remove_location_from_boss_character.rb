class RemoveLocationFromBossCharacter < ActiveRecord::Migration[8.1]
  def change
    remove_column :boss_characters, :location, :string
  end
end
