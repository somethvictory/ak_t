class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.references :outlet, foreign_key: true, null: false
      t.references :item, foreign_key: true, null: false
      t.references :modifier, foreign_key: true, null: false
      t.integer :quantity
      t.string :fulfilment_type, null: false, default: 'Delivery'

      t.timestamps
    end
  end
end
