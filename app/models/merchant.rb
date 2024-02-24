class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def top_five_customers
    Customer.select("customers.*, count(distinct transactions.id) as number_of_transactions")
      .joins(invoices: [:transactions, invoice_items: {item: :merchant}])
      .where("merchants.id = ?", self.id)
      .where("transactions.result = ?", 0)
      .group(:id)
      .order("number_of_transactions desc")
      .limit(5)
  end

  def items_ready_to_ship
      self.items.joins(:invoice_items)
        .joins("INNER JOIN invoices ON invoices.id = invoice_items.invoice_id")
        .where("invoice_items.status = 1")
        .select("items.*, invoice_items.invoice_id, invoices.created_at")
        .order("invoices.created_at ASC")
  end
end        