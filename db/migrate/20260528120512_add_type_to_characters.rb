class AddTypeToCharacters < ActiveRecord::Migration[8.1]
  def change
    add_column :characters, :characterable_type, :string
    add_column :characters, :characterable_id, :integer
  end
end
