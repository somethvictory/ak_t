FactoryBot.define do
  factory :item do
    sku { FFaker::Name.name }
  end
end