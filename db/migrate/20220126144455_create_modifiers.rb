class CreateModifiers < ActiveRecord::Migration[7.0]
  def change
    create_table :modifiers do |t|
      t.string :label
      t.references :modifier_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
