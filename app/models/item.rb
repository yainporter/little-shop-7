class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  def date_an_invoice_was_created(invoice_id)
    invoices.exists? ? invoices.find(invoice_id).format_date_created : "No Invoice for this Item"
  end
end
