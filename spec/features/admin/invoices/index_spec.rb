require "rails_helper"

RSpec.describe "Admin Invoices Index", type: :feature do
  describe "As a admin" do
    before do
      @invoice_1 = create(:invoice)
      @invoice_2 = create(:invoice)
      @invoice_3 = create(:invoice)
    end

    it "show a list of invoice ids" do
      visit admin_invoices_path

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_2.id)
      expect(page).to have_content(@invoice_3.id)
    end

    it "links invoice ids to admin invoice show page" do
      visit admin_invoices_path
      
      expect(page).to have_link("Invoice ##{@invoice_1.id}")
      expect(page).to have_link("Invoice ##{@invoice_2.id}")
      expect(page).to have_link("Invoice ##{@invoice_3.id}")

      click_link "Invoice ##{@invoice_1.id}"
      
      expect(current_path).to eq(admin_invoice_path(@invoice_1))

      visit admin_invoices_path
      click_link "Invoice ##{@invoice_2.id}"

      expect(current_path).to eq(admin_invoice_path(@invoice_2))
    end
  end
end