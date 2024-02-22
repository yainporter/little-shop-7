class AdminController < ApplicationController
  def index
    @customers = Customer.all
    # require 'pry'; binding.pry
  end
end