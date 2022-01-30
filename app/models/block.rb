class Block < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :item, optional: true
  belongs_to :modifier, optional: true

  validates :fulfilment_type, presence: true
  validates :timeslot_start, presence: true
  validates :timeslot_end, presence: true

  include Fulfillable
  include TimeAllocatable

end
