require 'rails_helper'

RSpec.describe 'Merchant Items Index Page', type: :feature do
  describe 'As a Merchant ' do
    before(:each) do
    @merchant_1 = Merchant.create!(name: "Barry")
    @merchant_2 = Merchant.create!(name: "Jane")

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
    @invoice_6 = Invoice.create!(customer_id: @abdul.id, status: 1)

    create_list(:transaction, 20, invoice_id: @invoice_5.id)
    create_list(:transaction, 15, invoice_id: @invoice_2.id)
    create_list(:transaction, 10, invoice_id: @invoice_1.id)
    create_list(:transaction, 7, invoice_id: @invoice_3.id)
    create_list(:transaction, 5, invoice_id: @invoice_4.id)
    create_list(:transaction, 5, invoice_id: @invoice_6.id)

    @item_1 = create(:item, name: "book", merchant: @merchant_1)
    @item_2 = create(:item, name: "belt", merchant: @merchant_1)
    @item_3 = create(:item, name: "shoes", merchant: @merchant_1)
    @item_4 = create(:item, name: "paint", merchant: @merchant_1)
    @item_5 = create(:item, name: "soda", merchant: @merchant_2)

    create(:invoice_item, status: 1, invoice_id: @invoice_1.id, item_id: @item_1.id) #packaged
    create(:invoice_item, status: 1, invoice_id: @invoice_2.id, item_id: @item_2.id) #packaged
    create(:invoice_item, status: 1, invoice_id: @invoice_3.id, item_id: @item_3.id) #packaged
    create(:invoice_item, status: 0, invoice_id: @invoice_4.id, item_id: @item_4.id) #pending
    create(:invoice_item, status: 0, invoice_id: @invoice_5.id, item_id: @item_1.id) #pending
    create(:invoice_item, status: 0, invoice_id: @invoice_6.id, item_id: @item_5.id) #pending

    visit  merchant_items_path(@merchant_1.id)
    end

    describe "User Story-6 Merchant Items Index Page" do
      it 'displays a list of the names of all of the merchants items' do
        expect(page).to have_content("#{@merchant_1.name} Items:")

        within "#item-#{@item_1.id}" do
          expect(page).to have_content("book")
          expect(page).to_not have_content("soda")
        end

        within "#item-#{@item_2.id}" do
          expect(page).to have_content("belt")
          expect(page).to_not have_content("soda")
        end

        within "#item-#{@item_5.id}" do
          expect(page).to have_content("soda")
          expect(page).to_not have_content("book")
        end
      end
    end

    describe "User Story 9 - Merchant Item Disable/Enable" do
      it "displays bera button next to each Item to disable or enable the item" do
        @merchant_1.items.each do |item|
          within "#item-#{item.id}" do
            expect(page).to have_content("Item Status: Enabled")
            expect(page).to have_no_content("Item Status: Disabled")
            expect(page).to have_button("Disable")
            expect(page).to have_button("Enable")
          end
        end

        @item_5.update!(status: "Disabled")
        visit merchant_items_path(@merchant_2)

        within "#item-#{@item_5.id}" do
          expect(page).to have_content("Item Status: Disabled")
          expect(page).to have_no_content("Item Status: Enabled")
          expect(page).to have_button("Disable")
          expect(page).to have_button("Enable")
        end
      end

      it "redirects to the index page with updated information when button is clicked" do
        @merchant_1.items.each do |item|
          within "#item-#{item.id}" do
            click_button "Disable"
            expect(page).to have_current_path(merchant_items_path(@merchant_1))
            expect(page).to have_content("Item Status: Disabled")
            expect(page).to have_no_content("Item Status: Enabled")
          end
        end

        @item_5.update!(status: "Disabled")
        visit merchant_items_path(@merchant_2)

        within "#item-#{@item_5.id}" do
          click_button "Enable"
          expect(page).to have_current_path(merchant_items_path(@merchant_2))
          expect(page).to have_content("Item Status: Enabled")
          expect(page).to have_no_content("Item Status: Disabled")
        end
      end
    end
  end
end
