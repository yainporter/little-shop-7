class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  def date_invoice_created
    invoices.exists? ? invoices.first.format_date_created : "No Invoice for this Item"
  end
end
