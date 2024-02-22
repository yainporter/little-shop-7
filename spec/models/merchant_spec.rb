require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name}
  end

  describe "relationships" do
    it {should have_many :items}
  end

  before(:each) do
    @barry = Merchant.create!(name: "Barry")
    @jane = Merchant.create!(name: "Jane")

    @barrys_book = Item.create!(name: "Book", description: "Good book", unit_price: 1000, merchant_id: @barry.id)
    @janes_book = Item.create!(name: "Book", description: "Good book", unit_price: 1000, merchant_id: @jane.id)

    @yain = Customer.create!(first_name: "Yain", last_name: "Porter")
    @joey = Customer.create!(first_name: "Joey", last_name: "R")
    @jess = Customer.create!(first_name: "Jess", last_name: "K")
    @lance = Customer.create!(first_name: "Lance", last_name: "B")
    @abdul = Customer.create!(first_name: "Abdul", last_name: "R")

    @invoice_1 = Invoice.create!(customer_id: @yain.id, status: 1)
    @invoice_2 = Invoice.create!(customer_id: @joey.id, status: 1)
    @invoice_3 = Invoice.create!(customer_id: @jess.id, status: 1)
    @invoice_4 = Invoice.create!(customer_id: @lance.id, status: 1)
    @invoice_5 = Invoice.create!(customer_id: @abdul.id, status: 1)
 
    InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @barrys_book.id, quantity: 1, unit_price: 1000, status: 2)
    InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @janes_book.id, quantity: 1, unit_price: 1000, status: 2)

    create_list(:transaction, 20, invoice_id: @invoice_5.id)
    create_list(:transaction, 15, invoice_id: @invoice_2.id)
    create_list(:transaction, 10, invoice_id: @invoice_1.id)
    create_list(:transaction, 7, invoice_id: @invoice_3.id)
    create_list(:transaction, 5, invoice_id: @invoice_4.id)
  end

  describe "instance methods" do
    describe "#top_five_customers" do
      it "should return the top five customers with the most successful transactions" do
        require 'pry'; binding.pry
        expect(@barry.top_five_customers).to eq([@abdul, @joey, @yain, @jess, @lance])
        expect(@jane.top_five_customers).to eq([@joey, @yain])
      end
    end
  end
end