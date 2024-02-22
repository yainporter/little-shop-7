class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  
  validates :status, presence: true

  enum status: {"in progress" => 0, "completed" => 1, "cancelled" => 2}
end