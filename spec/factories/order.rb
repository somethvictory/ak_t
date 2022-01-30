FactoryBot.define do
  factory :order do
    serving_date { DateTime.now }
    fulfilment_type { 'Delivery' }
    timeslot_start { Timeslot::HOURS['12:00AM'] }
    timeslot_end { Timeslot::HOURS['01:00AM'] }

    association :outlet
  end
end