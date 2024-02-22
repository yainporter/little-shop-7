require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status}
    it { should validate_numericality_of :status}
    it { should define_enum_for(:status).with_values("in progress" => 0, "completed" => 1, "canceled" => 2)}
  end

  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
  end
end