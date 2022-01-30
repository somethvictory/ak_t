class Block < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :item, optional: true
  belongs_to :modifier, optional: true

  validates :fulfilment_type, presence: true
  validates :timeslot_start, presence: true
  validates :timeslot_end, presence: true

  validate :item_and_modifier_presence

  include Fulfillable
  include TimeAllocatable

  def item_and_modifier_presence
    errors.add(:base, 'Item or Modifier must be present') if item.blank? && modifier.blank?
  end
end
