class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants

  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true

  enum status: {"Pending" => 0, "Packaged" => 1, "Shipped" => 2}

  def has_discount?
    !self.merchants.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold <= ?", self.quantity).empty?
  end

  def self.discounts_applied_and_revenue
    InvoiceItem.select("sum(distinct invoice_items.quantity * invoice_items.unit_price) as revenue_without_discount, sum(invoice_items.quantity * invoice_items.unit_price * (100 - bulk_discounts.percentage)/100) as revenue_with_discount, invoice_items.*")
                  .joins(merchants: :bulk_discounts)
                  .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
                  .group("invoice_items.id, bulk_discounts.id")
  end

  def self.hash_of_invoice_item_discount
    hash_of_invoice_item_discount = Hash.new(0)
    discounts_applied_and_revenue.map do |invoice_item|
      hash_of_invoice_item_discount[invoice_item] = invoice_item.revenue_without_discount - invoice_item.revenue_with_discount
    end
    hash_of_invoice_item_discount
  end

  def bulk_discount_id
    if !self.has_discount?
      return nil
    else
      self.merchants.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold <= ?", self.quantity).order("bulk_discounts.id desc").pluck("bulk_discounts.id").first
    end
  end
end
