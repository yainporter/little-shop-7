class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  def self.top_customers 
    where("transactions.result = 0")
      .joins(invoices: :transactions)
      .group(:first_name, :last_name, :result)
      .order("count(transactions.result) DESC")
      .limit(5)
      .pluck("customers.first_name, customers.last_name, count(transactions.result)")
      require 'pry'; binding.pry
  end
end