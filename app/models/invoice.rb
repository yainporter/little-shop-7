class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  validates :status, presence: true

  enum status: {"In Progress" => 0, "Completed" => 1, "Cancelled" => 2}

  def self.incomplete_invoices
    Invoice.joins(:invoice_items)
      .where("invoice_items.status != 2")
      .group(:id)
      .order(:created_at)
  end

  def format_date_created
    self.created_at.strftime("%A, %B %d, %Y")
  end

  def total_revenue
    invoice_items.sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def total_revenue_with_discounts
    total_revenue - invoice_items.hash_of_invoice_item_discount.values.sum
  end
end
