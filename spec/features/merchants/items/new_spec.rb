require "rails_helper"

RSpec.describe "Merchant Create Edit" do
  before do
    @merchant_1 = Merchant.create!(name: "Barry")

    @yain = Customer.create!(first_name: "Yain", last_name: "Porter")
    @joey = Customer.create!(first_name: "Joey", last_name: "R")
    @jess = Customer.create!(first_name: "Jess", last_name: "K")
    @lance = Customer.create!(first_name: "Lance", last_name: "B")
    @abdul = Customer.create!(first_name: "Abdul", last_name: "R")

    @invoice_1 = Invoice.create!(customer_id: @yain.id, status: 1, created_at: "2021-09-30")
    @invoice_2 = Invoice.create!(customer_id: @joey.id, status: 1, created_at: "2019-10-12")
    @invoice_3 = Invoice.create!(customer_id: @jess.id, status: 1, created_at: "2022-01-11")
    @invoice_4 = Invoice.create!(customer_id: @lance.id, status: 1)
    @invoice_5 = Invoice.create!(customer_id: @abdul.id, status: 1)

    create_list(:transaction, 20, invoice_id: @invoice_5.id)
    create_list(:transaction, 15, invoice_id: @invoice_2.id)
    create_list(:transaction, 10, invoice_id: @invoice_1.id)
    create_list(:transaction, 7, invoice_id: @invoice_3.id)
    create_list(:transaction, 5, invoice_id: @invoice_4.id)

    @item_1 = create(:item, name: "book", merchant: @merchant_1, description: "good book", unit_price: 1000)
    @item_2 = create(:item, name: "belt", merchant: @merchant_1)
    @item_3 = create(:item, name: "shoes", merchant: @merchant_1)
    @item_4 = create(:item, name: "paint", merchant: @merchant_1)

    create(:invoice_item, status: 1, invoice_id: @invoice_1.id, item_id: @item_1.id) #packaged
    create(:invoice_item, status: 1, invoice_id: @invoice_2.id, item_id: @item_2.id) #packaged
    create(:invoice_item, status: 1, invoice_id: @invoice_3.id, item_id: @item_3.id) #packaged
    create(:invoice_item, status: 0, invoice_id: @invoice_4.id, item_id: @item_4.id) #pending
    create(:invoice_item, status: 0, invoice_id: @invoice_5.id, item_id: @item_1.id) #pending

  end

  describe "User Story-11 Merchant Items Create Page" do
    # When I visit my items index page
    it "Visits merchant's item items index page" do
      visit  merchant_items_path(@merchant_1.id)

      # I see a link to create a new item.
      expect(page).to have_content("Create new item")
      
      # When I click on the link,
      click_on("Create new item")

      # I am taken to a form that allows me to add item information.
      expect(page).to have_current_path("/merchants/#{@merchant_1.id}/items/new")
      expect(page).to have_field("Name")
      expect(page).to have_field("Description")
      expect(page).to have_field("Price")

      # When I fill out the form I click ‘Submit’
      fill_in "Name", with: "Shish Kebab"
      fill_in "Description", with: "Skewered meat sausages cooked over a charcoal fire"
      fill_in "Price", with: "1999"
      expect(page).to have_button("Submit")
      click_on("Submit")

      # Then I am taken back to the items index page
      visit  merchant_items_path(@merchant_1.id)

      
      # And I see the item I just created displayed in the list of items.
      # And I see my item was created with a default status of disabled.
     
      expect(page).to have_content("Shish Kebab")
      expect(page).to have_content("Disabled")
      
    end
  end

  describe "error message" do 
    it "displays error message if not all inputs are filled in" do 
      visit new_merchant_item_path(@merchant_1)
      fill_in "Description", with: "Skewered meat sausages cooked over a charcoal fire"
      fill_in "Price", with: ""
      click_on("Submit")

      expect(current_path).to eq(new_merchant_item_path(@merchant_1))
      expect(page).to have_content("Error Please fill in all required fields")
    end
  end
end