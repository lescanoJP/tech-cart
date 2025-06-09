require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let(:cart_product) { create(:cart_product, cart: cart, product: product, quantity: 2) }
  let(:new_product) { create(:product, name: 'Novo produto') }

  describe "POST /carts" do
    context 'When add the product to a new cart' do
      before do
        post '/carts', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'creates a new cart and add the item' do
        expect(response).to have_http_status(:created)
        parsed_response = JSON.parse(response.body)        
        expect(parsed_response['products'].first['name']).to eq product.name
        expect(parsed_response['products'].first['quantity']).to eq(1)
      end
    end

    context 'When add a product id that do not exists' do
      before do
        post '/carts', params: { product_id: 1, quantity: 1 }, as: :json
      end

      it 'returns a message saying product was not found' do
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include ('Produto não encontrado')
      end
    end

    context 'When add a product with quantity 0 or less than 0' do
      before do
        post '/carts', params: { product_id: product.id, quantity: -1 }, as: :json
      end

      it 'returns a message saying quantity must me positive' do
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include ('Quantidade deve ser maior que zero')
      end
    end
  end

  describe "POST /add_items" do
    context 'when the product already is in the cart' do
      before do
        put '/carts/add_item', params: { product_id: product.id, quantity: 1 }
      end

      it 'updates the quantity of the existing item in the cart' do
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['products'].first['quantity']).to eq 1
      end
    end

    context 'adding an item that is not in the cart yet' do
      before do
        put '/carts/add_item', params: { product_id: new_product.id, quantity: 1 }, as: :json
      end

      it 'adds the new item to the cart' do
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['products'].map { |p| p['name'] }).to include new_product.name
        expect(parsed_response['products'].count).to eq 2
      end
    end

    context 'changing the existing item quantity to 0 or less' do
      before do
        put '/carts/add_item', params: { product_id: product.id, quantity: 0 }, as: :json
      end

      it 'returns and error that it cannot be zero' do
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include 'Quantity must be greater than 0'
      end
    end
  end

  describe "DELETE /carts/:product_id" do
    context 'when removing a product from cart' do
      before do
        cart_product # Garante que o cart_product seja criado
        delete "/carts/#{product.id}", as: :json
      end

      it 'removes the product from cart' do
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['products'].map { |p| p['name'] }).not_to include(product.name)
      end
    end

    context 'when product is not in cart' do
      let(:other_product) { create(:product) }

      before do
        delete "/carts/#{other_product.id}", as: :json
      end

      it 'returns a message that the product is not in the cart' do
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include 'Item não está no carrinho'
      end
    end
  end

end
