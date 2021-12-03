class CreateQuickLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :quick_links do |t|
      t.string :name, null: false

      #t.int :origin_id
      t.references :origin, foreign_key: { to_table: :wallets }, null: false

      #t.Integer :destination_id
      t.references :destination, foreign_key: { to_table: :wallets }, null: false

      t.timestamps
    end
  end
end
