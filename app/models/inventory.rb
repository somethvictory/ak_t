class Inventory < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :item
  belongs_to :modifier

  validates :fulfilment_type, presence: true
  validates :item_id, uniqueness: { scope: [:outlet_id, :modifier_id, :fulfilment_type] }

  include Fulfillable
end
