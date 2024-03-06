require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status}
    it { should define_enum_for(:status).with_values("In Progress" => 0, "Completed" => 1, "Cancelled" => 2)}
  end

  describe "relationships" do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many(:items).through(:invoice_items)}
  end

  describe "class methods" do
    before do
      @customer_1 = create(:customer)

      @merchant_1 = create(:merchant)
      @items = create_list(:item, 5, merchant: @merchant_1)

      @invoice_1 = create(:invoice, customer: @customer_1, created_at: "2015-12-09")
      @invoice_2 = create(:invoice, customer: @customer_1, created_at: "2013-11-10")
      @invoice_3 = create(:invoice, customer: @customer_1, created_at: "2011-09-17")
      @invoice_4 = create(:invoice, customer: @customer_1, created_at: "2010-12-31")

      @invoice_items_1 = create(:invoice_item, invoice: @invoice_1)
      @invoice_items_2 = create(:invoice_item, invoice: @invoice_2)
      @invoice_items_3 = create(:invoice_item, status: 1, invoice: @invoice_3)
      @invoice_items_4 = create(:invoice_item, status: 2, invoice: @invoice_4)
    end

    describe ".incomplete_invoices" do
      it "lists incomplete invoices" do
        expect(Invoice.incomplete_invoices).to eq([@invoice_3, @invoice_2, @invoice_1])

        invoice_5 = create(:invoice, customer: @customer_1)
        invoice_items_5 = create(:invoice_item, invoice: invoice_5)

        expect(Invoice.incomplete_invoices).to eq([@invoice_3, @invoice_2, @invoice_1, invoice_5])
      end

      it "lists incomplete invoices from oldest to newest" do
        expect(Invoice.incomplete_invoices).to eq([@invoice_3, @invoice_2, @invoice_1])

        invoice_5 = create(:invoice, customer: @customer_1, created_at: "2012-12-09")
        invoice_items_5 = create(:invoice_item, invoice: invoice_5)

        expect(Invoice.incomplete_invoices).to eq([@invoice_3, invoice_5, @invoice_2, @invoice_1])
      end
    end
  end

  describe "instance_method" do
    before do
      @merchant_1 = create(:merchant)

      @item_1 = create(:item)
      @item_2 = create(:item)
      @item_3 = create(:item)

      @customer_1 = create(:customer)

      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: "2015-12-09")
      @invoice_2 = @customer_1.invoices.create!(status: 2, created_at: "2013-11-10")

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 2500, status: 0)
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 2, unit_price: 1000, status: 1)
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 3, unit_price: 5000, status: 2)
    end

    describe "#format_date_created"
      it "formats the created_at date" do
        expect(@invoice_1.format_date_created).to eq("Wednesday, December 09, 2015")
        expect(@invoice_2.format_date_created).to eq("Sunday, November 10, 2013")
      end

    describe "#total_revenue" do
      it "calculates an invoice's total revenue" do
        expect(@invoice_1.total_revenue).to eq(19500)
      end
    end

    describe "#total_discounts_for_an_invoice" do
      it "adds up all the total_discounts for an invoice_item" do
        jane = Merchant.create!(name: "Jane")

        lance = Customer.create!(first_name: "Lance", last_name: "Butler")

        twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: jane.id)
        fifty_percent = BulkDiscount.create!(name: "50% Off", percentage: 50, quantity_threshold: 10, merchant_id: jane.id)

        item_1 = jane.items.create!(name: "Book", description: "Good book", unit_price: 1500)
        item_2 = jane.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
        item_3 = jane.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)

        invoice_1 = lance.invoices.create!(status: 1, created_at: "2015-12-09")

        InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 2500, status: 0) # 12500 => 25000
        InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 7, unit_price: 1000, status: 1) # 5600 => 7000
        InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 5000, status: 2) # 10000

        barry = Merchant.create!(name: "Barry")

        ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: barry.id)
        twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: barry.id)
        thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: barry.id)

        book = barry.items.create!(name: "Book", description: "Good book", unit_price: 1500)
        shoes = barry.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
        belt = barry.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)
        hat = barry.items.create!(name: "Hat", description: "Good hat", unit_price: 5000)
        sunglasses = barry.items.create!(name: "Sunglasses", description: "Good sunglasses", unit_price: 5000)
        shirt = barry.items.create!(name: "Shirt", description: "Good shirt", unit_price: 5000)
        pants = barry.items.create!(name: "Pants", description: "Good pants", unit_price: 5000)

        lance_invoice_1 = Invoice.create!(customer_id: lance.id, status: 0, created_at: "2015-05-05")

        #Invoice 1
        lance_invoice_item_1 = InvoiceItem.create!(item_id: book.id, invoice_id: lance_invoice_1.id, quantity: 4, status: 1, unit_price: 1000) #1000*4*0.9 = 3600 - 4000
        lance_invoice_item_2 = InvoiceItem.create!(item_id: shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
        lance_invoice_item_3 = InvoiceItem.create!(item_id: hat.id, invoice_id: lance_invoice_1.id, quantity: 6, status: 1, unit_price: 2500) # 2500*6*0.8 = 12000 - 15000
        InvoiceItem.create!(item_id: belt.id, invoice_id: lance_invoice_1.id, quantity: 3, status: 1, unit_price: 2500) # 2500*3*0.9 = 6750 - 7500
        InvoiceItem.create!(item_id: shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
        InvoiceItem.create!(item_id: pants.id, invoice_id: lance_invoice_1.id, quantity: 9, status: 1, unit_price: 2500) # 2500*9*0.7 = 15750 - 22500
        InvoiceItem.create!(item_id: sunglasses.id, invoice_id: lance_invoice_1.id, quantity: 1, status: 1, unit_price: 25000) # 25000

        expect(lance_invoice_1.total_discounts_for_an_invoice).to eq(10900)
        expect(invoice_1.total_discounts_for_an_invoice).to eq(13900)
      end
    end

    describe "#total_revenue_with_discounts" do
      it "takes the total revenue, and subtracts the discounts" do
        jane = Merchant.create!(name: "Jane")

        lance = Customer.create!(first_name: "Lance", last_name: "Butler")

        twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: jane.id)
        fifty_percent = BulkDiscount.create!(name: "50% Off", percentage: 50, quantity_threshold: 10, merchant_id: jane.id)

        item_1 = jane.items.create!(name: "Book", description: "Good book", unit_price: 1500)
        item_2 = jane.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
        item_3 = jane.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)

        invoice_1 = lance.invoices.create!(status: 1, created_at: "2015-12-09")

        InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 2500, status: 0) # 12500 => 25000
        InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 7, unit_price: 1000, status: 1) # 5600 => 7000
        InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 5000, status: 2) # 10000

        barry = Merchant.create!(name: "Barry")

        ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: barry.id)
        twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: barry.id)
        thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: barry.id)

        book = barry.items.create!(name: "Book", description: "Good book", unit_price: 1500)
        shoes = barry.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
        belt = barry.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)
        hat = barry.items.create!(name: "Hat", description: "Good hat", unit_price: 5000)
        sunglasses = barry.items.create!(name: "Sunglasses", description: "Good sunglasses", unit_price: 5000)
        shirt = barry.items.create!(name: "Shirt", description: "Good shirt", unit_price: 5000)
        pants = barry.items.create!(name: "Pants", description: "Good pants", unit_price: 5000)

        lance_invoice_1 = Invoice.create!(customer_id: lance.id, status: 0, created_at: "2015-05-05")

        lance_invoice_item_1 = InvoiceItem.create!(item_id: book.id, invoice_id: lance_invoice_1.id, quantity: 4, status: 1, unit_price: 1000) #1000*4*0.9 = 3600 - 4000
        lance_invoice_item_2 = InvoiceItem.create!(item_id: shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
        lance_invoice_item_3 = InvoiceItem.create!(item_id: hat.id, invoice_id: lance_invoice_1.id, quantity: 6, status: 1, unit_price: 2500) # 2500*6*0.8 = 12000 - 15000
        InvoiceItem.create!(item_id: belt.id, invoice_id: lance_invoice_1.id, quantity: 3, status: 1, unit_price: 2500) # 2500*3*0.9 = 6750 - 7500
        InvoiceItem.create!(item_id: shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
        InvoiceItem.create!(item_id: pants.id, invoice_id: lance_invoice_1.id, quantity: 9, status: 1, unit_price: 2500) # 2500*9*0.7 = 15750 - 22500
        InvoiceItem.create!(item_id: sunglasses.id, invoice_id: lance_invoice_1.id, quantity: 1, status: 1, unit_price: 25000) # 25000

        expect(lance_invoice_1.total_revenue_with_discounts).to eq(73100)
        expect(invoice_1.total_revenue_with_discounts).to eq(28100)
      end
    end
  end
end
