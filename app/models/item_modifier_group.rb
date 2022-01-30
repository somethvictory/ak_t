class ItemModifierGroup < ActiveRecord::Base
  belongs_to :item
  belongs_to :modifier_group
end
