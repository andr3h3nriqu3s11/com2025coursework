class CreateWalletIcons < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_icons do |t|
      t.string :icon, null: false

      t.timestamps
    end

    add_index :wallet_icons, :icon, unique: true
  end
end
