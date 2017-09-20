require 'rails_helper'

RSpec.describe V1::ProductsController, type: :controller do

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
      end

      it 'returns an error' do
        expect {
          post :create, params: product_params
        }.to_not raise_error
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end

end
