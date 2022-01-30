FactoryBot.define do
  factory :item_modifier_group do
    association :item
    association :modifier_group
  end
end