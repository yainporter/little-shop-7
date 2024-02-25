class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = Item.all
    @items = Item.all
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.update(item_params)

    redirect_to path
  end

  private

  def item_params
    params.require(:merchant).permit(:id, :name, :description, :unit_price, :merchant_id)
  def show
    @item = Item.find(params[:id])
  end
end
