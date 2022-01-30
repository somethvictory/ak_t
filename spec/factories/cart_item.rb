FactoryBot.define do
  factory :cart_item do
    association :cart
    association :item
  end
end