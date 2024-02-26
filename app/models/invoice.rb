class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items

  validates :status, presence: true

  enum status: {"In Progress" => 0, "Completed" => 1, "Cancelled" => 2}

  def self.incomplete_invoices
    Invoice.find_by_sql(
      "SELECT invoices.*
      FROM invoices
      JOIN invoice_items ON invoice_items.invoice_id = invoices.id
      WHERE invoice_items.status = 0 OR invoice_items.status = 1
      GROUP BY invoices.id
      ORDER BY invoices.created_at"
    )
  end

  def format_date_created
    self.created_at.strftime("%A, %B %d, %Y")
  end

  def total_revenue
    revenue = 0
    self.invoice_items.each do |invoice_item|
      revenue += (invoice_item.quantity * invoice_item.unit_price)
    end
    revenue
  end
end
