class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.string :name, null: false
      t.string :icon, default: ""
      t.string :color, default: ""
      t.integer :value, default: 0
      t.boolean :system, default: false

      #t.User :owner
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end

    # This forces name and user_id to be unique which means a user won't be able to have 2 wallets with the same name
    add_index :wallets, [:name, :user_id], unique: true

  end
end
