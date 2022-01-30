class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :sku, null: false

      t.timestamps
    end
  end
end
