class CreateQuickLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :quick_links do |t|
      t.string :name
      t.Integer :origin_id
      t.Integer :destination_id

      t.timestamps
    end
  end
end
