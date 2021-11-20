class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.string :name
      t.string :icon
      t.user :owner
      t.integer :value
      t.boolean :system

      t.timestamps
    end
  end
end
