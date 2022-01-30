module TimeAllocatable
  extend ActiveSupport::Concern

  included do
    validate :timeslots, if: :timeslot_required?
  end

  def timeslot_start_enum
    Timeslot::HOURS
  end

  def timeslot_end_enum
    Timeslot::HOURS
  end

  def timeslots
    errors.add(:timeslot_end, 'Timeslot end cannot be in the past') if timeslot_end < timeslot_start
  end

  def timeslot_required?
    true
  end
end