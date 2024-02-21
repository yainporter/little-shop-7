require 'rails_helper'

FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description {  }
    unit_price {  }
    merchant_id
    last_name  { Faker::Name.last_name }
  end
end