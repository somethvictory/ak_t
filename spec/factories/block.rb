FactoryBot.define do
  factory :block do
    fulfilment_type { 'Delivery' }
    timeslot_start { Timeslot::HOURS['12:00AM'] }
    timeslot_end { Timeslot::HOURS['07:00AM'] }

    association :outlet
    association :item
    association :modifier
  end
end