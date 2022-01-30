class CreateBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :blocks do |t|
      t.references :inventory

      t.timestamps
    end
  end
end
