class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.references :order
      t.references :item
      t.references :modifier
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
