class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :description
      t.decimal :value, :precision => 15


      #t.Wallet :origin
      t.references :origin, foreign_key: true, null: false

      #t.Wallet :destination
      t.references :destination, foreign_key: true, null: false

      t.timestamps
    end
  end
end
