class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item

  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true

  enum status: {"Pending" => 0, "Packaged" => 1, "Shipped" => 2}

  def discount_and_revenue_for_invoice_item
    InvoiceItem.select("sum(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percentage/100) as total_discount, sum(distinct invoice_items.quantity * invoice_items.unit_price) as total_revenue_without_discount")
                  .joins(merchants: :bulk_discounts)
                  .where("invoice_items.quantity >= bulk_discounts.quantity_threshold AND invoice_items.id = ?", self.id)
                  .group("bulk_discounts.id")
                  .order(total_discount: :desc)
                  .first
  end

  def has_discount?
    discount_and_revenue_for_invoice_item == nil ? false : true
  end
end
