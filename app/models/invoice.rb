class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items
  
  validates :status, presence: true

  enum status: {"in progress" => 0, "completed" => 1, "cancelled" => 2}

  def self.incomplete_invoices
    # self.invoice_items.status == "pending" || self.invoice_items.status == "packaged"
    # where("invoice_items.status = 0 OR invoice_items.status = 1")
    #   .joins(invoices: :invoice_items)
    #   .group(:id)

    Invoice.find_by_sql(
      "SELECT invoices.*
      FROM invoices
      JOIN invoice_items ON invoice_items.invoice_id = invoices.id
      WHERE invoice_items.status = 0 OR invoice_items.status = 1
      GROUP BY invoices.id"
    )
  end
end