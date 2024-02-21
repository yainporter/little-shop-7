require 'rails_helper'

FactoryBot.define do
    factory :invoiceitem do
      quantity { Faker::Name.quanity }
      unit_price { }
      status {}
      last_name  { Faker::Name.last_name }
    end
  end