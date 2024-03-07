require "rails_helper"

RSpec.describe ApplicationRecord, type: :model do
  describe "instance methods" do
    describe "format_total_revenue_with_discounts" do
        it "formats an invoice's total revenue with discounts into currency" do
        jane = Merchant.create!(name: "Jane")

        lance = Customer.create!(first_name: "Lance", last_name: "B")

        twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: jane.id)
        fifty_percent = BulkDiscount.create!(name: "50% Off", percentage: 50, quantity_threshold: 10, merchant_id: jane.id)

        item_1 = jane.items.create!(name: "Book", description: "Good book", unit_price: 1500)
        item_2 = jane.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
        item_3 = jane.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)

        invoice_1 = lance.invoices.create!(status: 1, created_at: "2015-12-09")

        InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 2500, status: 0)
        InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 7, unit_price: 1000, status: 1)
        InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 5000, status: 2)

        expect(invoice_1.format_total_revenue_with_discounts).to eq("$281.00")

        InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 1000, status: 2)

        expect(invoice_1.format_total_revenue_with_discounts).to eq("$331.00")
      end
    end
  end
end
