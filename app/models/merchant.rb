class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  def top_five_customers
    Customer.top_customers
  end
end