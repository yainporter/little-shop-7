require 'rails_helper'

FactoryBot.define do
  factory :merchant do
    name { Faker::Name.name }
  end
end