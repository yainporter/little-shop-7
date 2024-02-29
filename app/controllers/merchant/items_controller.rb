class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = Item.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = Item.new(item_params)
    if item.save
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      redirect_to new_merchant_item_path(@merchant)
      flash[:notice] = "Error Please fill in all required fields"
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if params[:status]
      @item.update(status: params[:status])

      redirect_to merchant_items_path(params[:merchant_id])
    elsif @item.update(item_params)
      flash[:notice] = "Congratulations! You've edited the item successfully!"

      redirect_to merchant_item_path(params[:merchant_id], params[:id])
    else
      flash.now[:error] = "Couldn't fully update the item, please make sure ALL fields are filled out properly"

      render :edit
    end
  end

  private

  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :status)
  end
end
