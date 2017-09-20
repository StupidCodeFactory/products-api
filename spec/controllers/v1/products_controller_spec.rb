require 'rails_helper'

RSpec.describe V1::ProductsController, type: :controller do

  let(:parsed_json) { JSON.parse(response.body) }

  def expect_product(as_object, product)
    expect(as_object['name']).to eq(product.name)
    expect(as_object['description']).to eq(product.description)
    expect(as_object['price_in_cents']).to eq(product.price_in_cents)
    expect(
      parse_json_time(as_object['updated_at']).to_i
    ).to eq(product.updated_at.to_i)
    expect(
      parse_json_time(as_object['created_at']).to_i
    ).to eq(product.created_at.to_i)
  end

  describe 'GET /v1/products/:id' do
    let(:product) { create :product }

    describe 'with an existing product id' do
      it 'returns the product details' do
        get :show, params: { id: product.id }
        expect_product(parsed_json, product)
      end
    end

    describe 'with an unknown product id' do
      it 'returns a 404' do
        get :show, params: { id: 'unknown_id' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /v1/products' do
    let!(:products) { create_list :product, 3 }

    it 'returns the list of products' do
      get :index

      products.each do |product|
        as_object = parsed_json.detect { |attributes| attributes['id'] == product.id }
        expect_product(as_object, product)
      end
    end
  end

  describe 'POST /v1/products' do
    let(:product_params) do
      {
        product: {
          name:           'fancy product',
          description:    'a fancy product description',
          price_in_cents: 1050
        }
      }
    end

    context 'when passing valid data' do
      it 'creates a product' do
        expect {
          post :create, params: product_params
        }.to change { Product.count }.by(1)
      end
    end

    context 'when passing invalide data' do

      before do
        product_params[:product][:price_in_cents] = ''
        post :create, params: product_params
      end

      it 'returns an error' do
        expect(parsed_json).to match(
                                 {
                                   'error' => {
                                     'price_in_cents' => ['is not a number']
                                   }
                                 }
                               )
      end

      it 'has a relevant error HTTP status code' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

end
