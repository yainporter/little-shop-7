class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :percentage, numericality: { less_than: 1, greater_than: 0 }
  validates :quantity_threshold, numericality: { only_integer: true }
end
