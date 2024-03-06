require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :quantity}
    it { should validate_numericality_of :quantity}

    it { should validate_presence_of :unit_price}
    it { should validate_numericality_of :unit_price}

    it { should validate_presence_of :status}
    it { should define_enum_for(:status).with_values("Pending" => 0, "Packaged" => 1, "Shipped" => 2)}
  end

  describe "relationships" do
    it {should belong_to :invoice}
    it {should belong_to :item}
  end

  before do
    @merchant_1 = create(:merchant)
    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @customer_1 = create(:customer)
    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice, customer: @customer_1)
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, unit_price: 500)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, unit_price: 1027)
  end

  describe "instance methods" do
    it "formats unit_price sold at" do
      expect(@invoice_item_1.format_unit_price).to eq("$5.00")
      expect(@invoice_item_2.format_unit_price).to eq("$10.27")
    end
  end

  before do
    @barry = Merchant.create!(name: "Barry")

    @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: @barry.id)
    @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @barry.id)
    @thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: @barry.id)

    @lance = Customer.create!(first_name: "Lance", last_name: "Butler")

    @book = @barry.items.create!(name: "Book", description: "Good book", unit_price: 1500)
    @shoes = @barry.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
    @belt = @barry.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)
    @hat = @barry.items.create!(name: "Hat", description: "Good hat", unit_price: 5000)
    @sunglasses = @barry.items.create!(name: "Sunglasses", description: "Good sunglasses", unit_price: 5000)
    @shirt = @barry.items.create!(name: "Shirt", description: "Good shirt", unit_price: 5000)
    @pants = @barry.items.create!(name: "Pants", description: "Good pants", unit_price: 5000)

    @lance_invoice_1 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2015-05-05")

    #Invoice 1
    @lance_invoice_item_1 = InvoiceItem.create!(item_id: @book.id, invoice_id: @lance_invoice_1.id, quantity: 4, status: 1, unit_price: 1000) #1000*4*0.9 = 3600 - 4000
    @lance_invoice_item_2 = InvoiceItem.create!(item_id: @shoes.id, invoice_id: @lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
    @lance_invoice_item_3 = InvoiceItem.create!(item_id: @hat.id, invoice_id: @lance_invoice_1.id, quantity: 6, status: 1, unit_price: 2500) # 2500*6*0.8 = 12000 - 15000
    InvoiceItem.create!(item_id: @belt.id, invoice_id: @lance_invoice_1.id, quantity: 3, status: 1, unit_price: 2500) # 2500*3*0.9 = 6750 - 7500
    InvoiceItem.create!(item_id: @shoes.id, invoice_id: @lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
    InvoiceItem.create!(item_id: @pants.id, invoice_id: @lance_invoice_1.id, quantity: 9, status: 1, unit_price: 2500) # 2500*9*0.7 = 15750 - 22500
    InvoiceItem.create!(item_id: @sunglasses.id, invoice_id: @lance_invoice_1.id, quantity: 1, status: 1, unit_price: 25000) # 25000

    @jane = Merchant.create!(name: "Jane")

    @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @jane.id)
    @fifty_percent = BulkDiscount.create!(name: "50% Off", percentage: 50, quantity_threshold: 10, merchant_id: @jane.id)

    @item_1 = @jane.items.create!(name: "Book", description: "Good book", unit_price: 1500)
    @item_2 = @jane.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
    @item_3 = @jane.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)

    @invoice_1 = @lance.invoices.create!(status: 1, created_at: "2015-12-09")

    InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: 2500, status: 0) # 12500 => 25000
    InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 7, unit_price: 1000, status: 1) # 5600 => 7000
    InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 2, unit_price: 5000, status: 2) # 10000
  end

  describe "#total_discount_and_revenue" do
    it "calculates the total discount amount for an invoice_item that has a discount" do
      expect(@lance_invoice_item_1.discount_and_revenue_for_invoice_item.total_discount).to eq(400)
      expect(@lance_invoice_item_3.discount_and_revenue_for_invoice_item.total_discount).to eq(3000)
    end

    it "calculates the total revenue without the discount of an invoice_item that has a discount" do
      expect(@lance_invoice_item_1.discount_and_revenue_for_invoice_item.total_revenue_without_discount).to eq(4000)
      expect(@lance_invoice_item_3.discount_and_revenue_for_invoice_item.total_revenue_without_discount).to eq(15000)
    end
  end
end

# select invoice_items.id,
#         invoice_items.quantity,
#         invoice_items.unit_price,
#         bulk_discounts.quantity_threshold,
#         bulk_discounts.percentage
#         FROM "invoices"
#           INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id"
#           INNER JOIN "items" ON "items"."id" = "invoice_items"."item_id"
#           INNER JOIN "merchants" ON "merchants"."id" = "items"."merchant_id"
#           INNER JOIN "bulk_discounts" ON "bulk_discounts"."merchant_id" = "merchants"."id"
#           WHERE (invoice_items.invoice_id = 2)
#           group by bulk_discounts.id
#        tems.quantity >= bulk_discounts.quantity_threshold AND invoice_items.invoice_id = 2) GROUP BY "invoice_items"."id";
