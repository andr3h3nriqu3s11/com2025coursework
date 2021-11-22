class CreateTrasanctions < ActiveRecord::Migration[5.2]
  def change
    create_table :trasanctions do |t|
      t.string :description
      t.integer :value, null: false

      #t.Wallet :origin
      t.references :origin, {table: :wallets, foreign_key: true, null: false}

      #t.Wallet :destination
      t.references :destination, {tables: :wallets, foreign_key: true, null: false}

      t.timestamps
    end
  end
end
