#require 'rails_helper'

FactoryBot.define do
  factory :item do
    name { Faker::Games::Minecraft.item }
    description { Faker::Food.description }
    unit_price { Faker::Number.between(from: 100, to: 100000) }
    association :merchant
  end
end