FactoryBot.define do
  factory :order_item do
    association :order
    association :item
    association :modifier

    quantity { 1 }
  end
end