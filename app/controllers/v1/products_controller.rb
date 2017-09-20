class V1::ProductsController < ApplicationController

  def index
    products = Product.all
    render json: products
  end

  def show
    product = Product.find(params.require(:id))
    render json: product
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

  def update
    product = Product.find(params.require(:id))
    product.assign_attributes(product_params)

    if product.valid?
      product.save
      render json: product
    else
      render json: { error: product.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params.require(:id))
    product.destroy!
    head :ok
  end
  private

  def product_params
    params.require(:product).permit(
      :name, :description, :price_in_cents
    )
  end
end
