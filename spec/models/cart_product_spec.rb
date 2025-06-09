require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  let(:product) { create(:product) }
  let(:cart) { create(:cart) }

  describe 'validations' do
    context 'when quantity is less than or equal to 0' do
      it 'is invalid' do
        cart_product = build(:cart_product, quantity: 0)
        expect(cart_product).not_to be_valid
        expect(cart_product.errors[:quantity]).to include('must be greater than 0')
      end

      it 'is invalid with negative quantity' do
        cart_product = build(:cart_product, quantity: -1)
        expect(cart_product).not_to be_valid
        expect(cart_product.errors[:quantity]).to include('must be greater than 0')
      end
    end

    context 'when quantity is greater than 0' do
      it 'is valid' do
        cart_product = build(:cart_product, quantity: 1)
        expect(cart_product).to be_valid
      end
    end
  end

  describe '#unit_price' do
    it 'returns the product price' do
      cart_product = create(:cart_product, product: product)
      expect(cart_product.unit_price).to eq(product.price)
    end
  end

  describe '#total_price' do
    it 'calculates the total price based on quantity and unit price' do
      cart_product = create(:cart_product, product: product, quantity: 2)
      expected_total = product.price * 2
      expect(cart_product.total_price).to eq(expected_total)
    end
  end

  describe '#name' do
    it 'returns the product name' do
      cart_product = create(:cart_product, product: product)
      expect(cart_product.name).to eq(product.name)
    end
  end
end
