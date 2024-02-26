class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true
  
  enum status: {"Pending" => 0, "Packaged" => 1, "Shipped" => 2}

  # add to application record for any unit_price as requested
  def format_price_sold
    (self.unit_price.to_f / 100).to_fs(:currency)
  end
end
