FactoryBot.define do
  factory :menu_section do
    association :menu
    association :section
  end
end