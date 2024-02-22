FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Number.between(from: 10000, to: 100000) }
    status { 0 }
    association :item
    association :invoice
  end
end
