class OrderItem < ActiveRecord::Base
  belongs_to :order, required: false
  belongs_to :item
  belongs_to :modifier

  validates :quantity, presence: true

  before_save :update_stock, if: :quantity_changed?

  def item_sku
    item&.sku || 'New'
  end

  def update_stock
    inventory = Inventory.find_by(outlet: order.outlet,
                                  item: item,
                                  modifier: modifier,
                                  fulfilment_type: order.fulfilment_type)
    return if inventory.nil? || inventory.quantity.nil?

    if quantity > quantity_was.to_i
      added_quantity = quantity - quantity_was.to_i
      inventory.quantity = inventory.quantity - added_quantity
    else
      removed_quantity = quantity_was - quantity
      inventory.quantity = inventory.quantity + removed_quantity
    end

    inventory.save!
  end
end
