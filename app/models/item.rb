class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  def format_date
    self.invoices.map do |invoice|
      invoice.created_at.strftime("%A, %B %d, %Y")
    end
    .join(', ')
  end
end