class Inventory < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :item
  belongs_to :modifier

  validates :fulfilment_type, presence: true
  validates :item_id, uniqueness: { scope: [:outlet_id, :modifier_id, :fulfilment_type] }

  validate :serving_date

  include Fulfillable
  include TimeAllocatable

  def timeslot_required?
    timeslot_start.present? && timeslot_end.present?
  end

  def serving_date
    return if serving_date_start.blank? || serving_date_end.blank?

    errors.add(:serving_end_date, 'Serving date start cannot be greater than serving date end') if serving_date_end < serving_date_start
  end
end
