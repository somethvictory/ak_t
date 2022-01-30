class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.datetime :serving_date, null: false
      t.string :fulfilment_type, null: false, default: 'Delivery'
      t.references :outlet, foreign_key: true, null: false

      t.timestamps
    end
  end
end
