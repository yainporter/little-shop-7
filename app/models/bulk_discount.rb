class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :percentage, numericality: true
  validates :quantity_threshold, numericality: true
end
