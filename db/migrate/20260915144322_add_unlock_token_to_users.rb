class AddUnlockTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    # add another useful lockable field
    add_column :users, :unlock_token, :string

    add_index :users, :unlock_token, unique: true
  end
end
