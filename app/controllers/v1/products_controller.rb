class V1::ProductsController < ApplicationController

  def index
    products = Product.all
    render json: products
  end

  def show
    render json: Product.find(params.require(:id))
  end

  def create
    product = Product.new(product_params)

    if product.valid?
      product.save
      render json: product
    else
      render json: { error: product.errors }, status: :unprocessable_entity
    end
  end


  private

  def product_params
    params.require(:product).permit(
      :name, :description, :price_in_cents
    )
  end
end
