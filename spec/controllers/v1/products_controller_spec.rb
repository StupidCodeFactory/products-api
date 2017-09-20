require 'rails_helper'

RSpec.shared_examples_for 'renders 404' do
  it 'returns a 404' do
    expect(response).to have_http_status(:not_found)
  end
end

RSpec.shared_examples_for 'invalid product params' do
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

    context 'with an unknown product id' do
      before do
        get :show, params: { id: 'unknown_id' }
      end
      include_examples 'renders 404'
    end
  end

  describe 'PATCH /v1/products/:id' do

    context 'with an exist product id' do
      let(:product) { create :product }
      let(:product_params) do
        {
          id: product.id,
          product: { name: 'an updated product', price_in_cents: 1000 }
        }
      end

      it 'updates the product' do
        expect {
          patch :update, params: product_params
        }.to change {
          Product.where(id: product.id).pluck(:name, :price_in_cents).first
        }.from([product.name, product.price_in_cents]).to(['an updated product', 1000])
      end

      context 'updating the with invalid params' do
        before do
          product_params[:product][:price_in_cents] = ''
          patch :update, params: product_params
        end

        include_examples 'invalid product params'
      end

      context 'with an unknown product id' do
        before do
          product_params[:id] = 'unknown_id'
          patch :update, params: product_params
        end

        include_examples 'renders 404'
      end

    end

  end

  describe 'DELETE /v1/products/:id' do

    context 'with an existing product id' do
      let(:product) { create :product }

      it 'deletes the product record' do
        expect {
          delete :destroy, params: { id: product.id }
        }.to change { Product.find_by(id: product.id)  }.from(product).to(nil)
      end
    end

    context 'with an unknown product id' do
      before do
        delete :destroy, params: { id: 'unknown_id' }
      end

      include_examples 'renders 404'
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

      include_examples 'invalid product params'
    end
  end

end
