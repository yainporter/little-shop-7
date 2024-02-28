class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  enum status: {enabled: 0, disabled: 1}

  def top_five_customers
    Customer.select("customers.*, CONCAT(customers.first_name, ' ', customers.last_name) AS full_name, count(distinct transactions.id) as successful_transactions")
      .joins(invoices: [:transactions, invoice_items: {item: :merchant}])
      .where("merchants.id = ?", self.id)
      .where("transactions.result = ?", 0)
      .group(:id)
      .order("successful_transactions desc")
      .limit(5)
  end

  def items_ready_to_ship
    self.items.joins(:invoice_items)
      .joins("INNER JOIN invoices ON invoices.id = invoice_items.invoice_id")
      .where("invoice_items.status = 1")
      .select("items.*, invoice_items.invoice_id, invoices.created_at")
      .order("invoices.created_at ASC")
  end

  def self.top_five_merchants
    Merchant.find_by_sql("SELECT merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS total_revenue
      FROM merchants
      JOIN items ON merchants.id = items.merchant_id
      JOIN invoice_items ON items.id = invoice_items.item_id
      JOIN invoices ON invoices.id = invoice_items.invoice_id
      JOIN transactions ON invoices.id = transactions.invoice_id
      WHERE transactions.result = 0
      GROUP BY merchants.id
      ORDER BY sum(invoice_items.unit_price * invoice_items.quantity) DESC
      LIMIT 5")
  end

  def top_sales_day
    self.invoices.joins(:transactions, :invoice_items)
      .where("transactions.result = 0")
      .select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) AS invoice_revenue")
      .group("invoices.id")
      .order("invoice_revenue DESC, invoices.created_at DESC")
      .first
      .created_at
      .strftime("%-m/%-e/%Y")
  end

  def top_5_popular_items
    items.select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_item_price")
    .joins(:merchant, [invoices: :transactions])
    .where("transactions.result = ?", 0)
    .group("items.id")
    .order("total_item_price desc")
    .limit(5)
  end
end
