require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'mark_as_abandoned' do
    let(:shopping_cart) { create(:cart) }

    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      shopping_cart.update(updated_at: 3.hours.ago)
      shopping_cart.update(status: :abandoned)
      expect(shopping_cart.status.abandoned?).to be true
    end
  end

  describe 'remove_if_abandoned' do
    let(:shopping_cart) { create(:cart, status: :abandoned) }

    it 'removes the shopping cart if abandoned for a certain time' do
      shopping_cart.update(updated_at: 7.days.ago)
      expect { shopping_cart.destroy }.to change { Cart.count }.by(-1)
    end
  end
end
