class V1::ProductsController < ApplicationController

  def create
    product = Product.new(product_params)

    if product.valid?
      render json: product
    else
      render json: { error: product.errors }
    end
  end


  private

  def product_params
    params.require(:product).permit(
      :name, :description, :price_in_cents
    )
  end
end
