class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item

  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true

  enum status: {"Pending" => 0, "Packaged" => 1, "Shipped" => 2}

end
# SELECT invoice_items.quantity,
#        invoice_items.unit_price,
#        invoice_items.id,
#        bulk_discounts.quantity_threshold,
#        bulk_discounts.percentage
#     FROM "invoice_items"
#     INNER JOIN "items" ON "items"."id" = "invoice_items"."item_id"
#     INNER JOIN "merchants" ON "merchants"."id" = "items"."merchant_id"
#     INNER JOIN "bulk_discounts" ON "bulk_discounts"."merchant_id" = "merchants"."id" WHERE (invoice_items.quantity >= bulk_discounts.quantity_threshold) ORDER BY invoice_items.id, percentage desc
