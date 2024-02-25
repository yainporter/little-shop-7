class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = Item.all
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)

    redirect_to merchant_items_path(params[:merchant_id])
  end

  private

  def item_params
    params.permit(:merchant_id, :id, :name, :description, :unit_price, :status)
  end
end
