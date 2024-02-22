require 'rails_helper'

RSpec.describe Customer, type: :model do
  # describe 'validations' do
  #   it { should validate_presence_of :}
  # end

  describe 'relationships' do
    it {should have_many :invoices}
  end
end