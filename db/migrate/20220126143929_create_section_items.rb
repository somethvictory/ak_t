class CreateSectionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :section_items do |t|
      t.references :section, foreign_key: true, null: false
      t.references :item, foreign_key: true, null: false

      t.timestamps
    end
  end
end
