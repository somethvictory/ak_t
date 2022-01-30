class Order < ActiveRecord::Base
  belongs_to :outlet

  has_many :order_items
  has_many :items, through: :order_items

  validates :serving_date, presence: true
  validates :fulfilment_type, presence: true
  validates :timeslot_start, presence: true
  validates :timeslot_end, presence: true

  validate :item_availability
  validate :inventory_availability

  include Fulfillable
  include TimeAllocatable

  accepts_nested_attributes_for :order_items, allow_destroy: true

  def item_availability
    errors.add(:base, 'Item or Modifier is blocked') if Block.where("outlet_id = ?
                                                                     AND (item_id IN (?) OR modifier_id IN (?))
                                                                     AND fulfilment_type = ?
                                                                     AND ((timeslot_start < ? AND timeslot_end > ?) OR  (timeslot_start < ? AND timeslot_end > ?))",
                                                                     outlet_id,
                                                                     order_items.map(&:item_id),
                                                                     order_items.map(&:modifier_id),
                                                                     fulfilment_type,
                                                                     timeslot_start, timeslot_start,
                                                                     timeslot_end, timeslot_end).any?
  end

  def inventory_availability
    invalid_items = []
    order_items.each_with_index do |order_item, i|
      invalid_items << "#{i + 1}. #{outlet.label} - #{order_item.item.sku} - #{order_item.modifier.label} - #{fulfilment_type} " unless Inventory.exists?(outlet: outlet,
                                                                                                                                                         item: order_item.item,
                                                                                                                                                         modifier: order_item.modifier,
                                                                                                                                                         fulfilment_type: fulfilment_type)
    end

    errors.add(:base, "Following items are not in the inventory: #{invalid_items}") if invalid_items.any?
  end
end
