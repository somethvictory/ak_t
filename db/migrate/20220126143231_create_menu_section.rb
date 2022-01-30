class CreateMenuSection < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_sections do |t|
      t.references :menu, foreign_key: true, null: false
      t.references :section, foreign_key: true, null: false

      t.timestamps
    end
  end
end
