FactoryBot.define do
  factory :inventory do
    fulfilment_type { 'Delivery' }
    quantity { 100 }

    association :outlet
    association :item
    association :modifier
  end
end