require 'rails_helper'

FactoryBot.define do
  factory :invoice do
    quantity { Faker::Name.quanity }
    unit_price { }
    status {}
    last_name  { Faker::Name.last_name }
  end
end