class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.datetime :serving_date, null: false
      t.string :fulfilment_type, null: false, default: 'Delivery'

      t.references :outlet, null: false, foreign_key: true

      t.integer :timeslot_start, null: false
      t.integer :timeslot_end, null: false

      t.timestamps
    end
  end
end
