FactoryBot.define do
  factory :section_item do
    association :section
    association :item
  end
end