class CreateBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :blocks do |t|
      t.references :item
      t.references :outlet, null: false
      t.references :modifier
      t.string :fulfilment_type, null: false, default: 'Deliver'
      t.integer :timeslot_start, null: false
      t.integer :timeslot_end, null: false

      t.timestamps
    end
  end
end
