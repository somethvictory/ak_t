FactoryBot.define do
  factory :modifier do
    label { FFaker::Name.name }

    association :modifier_group
  end
end