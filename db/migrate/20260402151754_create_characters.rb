class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_enum :regions, %w[Liyue Fontaine Montstadt]

    create_table :characters do |t|
        t.string :name, null: false
        t.text :description, null: false
        t.integer :rarity, null: false
        t.enum :region, enum_type: "regions", null: false
      t.timestamps
      end
  end
end
