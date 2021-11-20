class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.string :name
      t.string :icon
      t.integer :value
      t.boolean :system

      #t.User :owner
      t.references :user, foreign_key: true

      t.timestamps
    end

  end
end
