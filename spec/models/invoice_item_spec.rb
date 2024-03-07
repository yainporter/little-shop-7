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

  describe "instance methods" do
    before do
      @merchant_1 = create(:merchant)
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "20% Off", percentage: 20, quantity_threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "20% Off", percentage: 20, quantity_threshold: 10)
      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_1)
      @customer_1 = create(:customer)
      @invoice_1 = create(:invoice, customer: @customer_1)
      @invoice_2 = create(:invoice, customer: @customer_1)
      @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, unit_price: 500, quantity: 17)
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, unit_price: 1027, quantity: 10)
      @invoice_item_3 = create(:invoice_item, item: @item_2, invoice: @invoice_2, unit_price: 1027, quantity: 4)
      @invoice_item_4 = create(:invoice_item, item: @item_2, invoice: @invoice_2, unit_price: 1027, quantity: 1)
      @invoice_item_5 = create(:invoice_item, item: @item_2, invoice: @invoice_2, unit_price: 1027, quantity: 6)
    end

    it "formats unit_price sold at" do
      expect(@invoice_item_1.format_unit_price).to eq("$5.00")
      expect(@invoice_item_2.format_unit_price).to eq("$10.27")
    end

    describe "#has_discount?" do
      context "an invoice_item has a discount applied" do
        it "returns true" do
          expect(@invoice_item_1.has_discount?).to eq(true)
          expect(@invoice_item_2.has_discount?).to eq(true)
        end
      end

      context "an invoice_item does not have a discount applied" do
        it "returns false" do
          expect(@invoice_item_3.has_discount?).to eq(false)
          expect(@invoice_item_4.has_discount?).to eq(false)
        end
      end
    end

    describe "#bulk_discount_id" do
      context "an invoice_item has a bulk discount that applies" do
        it "returns the first bulk_discount applicable" do
          expect(@invoice_item_5.bulk_discount_id).to eq(@bulk_discount_1.id)
        end
      end
      context "an invoice_item has more than one bulk discount that applies" do
        it "returns the bulk_discount_id of the highest applied discount" do
          expect(@invoice_item_2.bulk_discount_id).to eq(@bulk_discount_2.id)
          expect(@invoice_item_1.bulk_discount_id).to eq(@bulk_discount_2.id)
        end
      end

      context "an invoice_item does not have a bulk discount" do
        it "returns nil" do
          expect(@invoice_item_3.bulk_discount_id).to eq(nil)
          expect(@invoice_item_4.bulk_discount_id).to eq(nil)
        end
      end
    end
  end

  describe "class methods" do
    before do
      @barry = Merchant.create!(name: "Barry")

      @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @barry.id)
      @thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: @barry.id)

      @lance = Customer.create!(first_name: "Lance", last_name: "Butler")

      @book = @barry.items.create!(name: "Book", description: "Good book", unit_price: 1500)
      @shoes = @barry.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
      @belt = @barry.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)

      @lance_invoice_1 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2015-05-05")

      @lance_invoice_item_1 = InvoiceItem.create!(item_id: @book.id, invoice_id: @lance_invoice_1.id, quantity: 4, status: 1, unit_price: 1000)
      @lance_invoice_item_2 = InvoiceItem.create!(item_id: @shoes.id, invoice_id: @lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
      @lance_invoice_item_3 = InvoiceItem.create!(item_id: @belt.id, invoice_id: @lance_invoice_1.id, quantity: 6, status: 1, unit_price: 2500)

      @jane = Merchant.create!(name: "Jane")

      @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @jane.id)
      @fifty_percent = BulkDiscount.create!(name: "50% Off", percentage: 50, quantity_threshold: 10, merchant_id: @jane.id)

      @jane_item_1 = @jane.items.create!(name: "Book", description: "Good book", unit_price: 1500)
      @jane_item_2 = @jane.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
      @jane_item_3 = @jane.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)

      @lance_invoice_2 = @lance.invoices.create!(status: 1, created_at: "2015-12-09")

      @lance_invoice_item_4 = InvoiceItem.create!(item_id: @jane_item_1.id, invoice_id: @lance_invoice_2.id, quantity: 10, unit_price: 2500, status: 0) # 12500 => 25000
      @lance_invoice_item_5 =InvoiceItem.create!(item_id: @jane_item_2.id, invoice_id: @lance_invoice_2.id, quantity: 7, unit_price: 1000, status: 1) # 5600 => 7000
      @lance_invoice_item_6 = InvoiceItem.create!(item_id: @jane_item_3.id, invoice_id: @lance_invoice_2.id, quantity: 2, unit_price: 5000, status: 2) # 10000
    end

    describe ".discounts_applied_and_revenue" do
      it "returns all InvoiceItems that have a discount applied" do
        expect(InvoiceItem.discounts_applied_and_revenue).to eq [@lance_invoice_item_3, @lance_invoice_item_4, @lance_invoice_item_4, @lance_invoice_item_5]
      end
    end
  end
end
