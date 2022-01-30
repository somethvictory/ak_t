class OrderItem < ActiveRecord::Base
  belongs_to :order, required: false
  belongs_to :item
  belongs_to :modifier

  validates :quantity, presence: true

end