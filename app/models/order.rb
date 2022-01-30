class Order < ActiveRecord::Base
  belongs_to :outlet

  has_many :order_items
  has_many :items, through: :order_items

  validates :serving_date, presence: true
  validates :fulfilment_type, presence: true
  validates :timeslot_start, presence: true
  validates :timeslot_end, presence: true

  include Fulfillable
  include TimeAllocatable

  accepts_nested_attributes_for :order_items, allow_destroy: true

end