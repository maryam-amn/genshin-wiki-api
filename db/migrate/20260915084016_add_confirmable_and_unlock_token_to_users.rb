class AddConfirmableAndUnlockTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    # confirmable field
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    # lockable field
    add_column :users, :unlock_token, :string # Jeton de déverrouillage envoyöe  par e-mail

    add_index :users, :unlock_token, unique: true
    add_index :users, :confirmation_token, unique: true

  end
end
