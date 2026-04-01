class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.text :description
      t.integer :rarity
      t.string :region
      t.string :type
      t.decimal :average_counting

      t.timestamps
    end
  end
end
