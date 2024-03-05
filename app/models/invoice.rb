class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items

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

  def invoice_item_discounted_revenue
    invoice_items.select("sum(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percentage/100) as discount")
                  .joins(merchants: :bulk_discounts)
                  .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
                  .group(:id)

    # SELECT sum(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percentage/100) as discount
    # FROM "invoice_items"
    # INNER JOIN "items" ON "items"."id" = "invoice_items"."item_id"
    # INNER JOIN "merchants" ON "merchants"."id" = "items"."merchant_id"
    # INNER JOIN "bulk_discounts" ON "bulk_discounts"."merchant_id" = "merchants"."id"
    # where invoice_items.quantity >= bulk_discounts.quantity_threshold
  end

  def total_discounted_revenue
    invoice_item_discounted_revenue.sum do |invoice_item|
      invoice_item.discount
    end
  end
end
