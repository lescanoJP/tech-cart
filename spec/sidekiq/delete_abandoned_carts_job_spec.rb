require 'rails_helper'

RSpec.describe DeleteAbandonedCartsJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers 
  around do |example|
    travel_to Time.current do
      example.run
    end
  end

  context 'when old abandoned carts exist' do
    let!(:active_cart) { create(:cart, status: :active, last_changed_at: 10.days.ago) }
    let!(:recently_abandoned_cart) { create(:cart, status: :abandoned, last_changed_at: 6.days.ago) }
    let!(:old_abandoned_cart) { create(:cart, status: :abandoned, last_changed_at: 8.days.ago) }

    it 'deletes old abandoned carts' do
      expect { DeleteAbandonedCartsJob.new.perform }.to change(Cart, :count).by(-1)
      expect(Cart.exists?(old_abandoned_cart.id)).to be_falsey
      expect(Cart.exists?(active_cart.id)).to be_truthy
      expect(Cart.exists?(recently_abandoned_cart.id)).to be_truthy
    end
  end

  context 'when no old abandoned carts exist' do
    it 'does not delete active carts' do
      create(:cart, status: :active, last_changed_at: 10.days.ago)
      expect { DeleteAbandonedCartsJob.new.perform }.not_to change(Cart, :count)
    end

    it 'does not delete recently abandoned carts' do
      create(:cart, status: :abandoned, last_changed_at: 6.days.ago)
      expect { DeleteAbandonedCartsJob.new.perform }.not_to change(Cart, :count)
    end

    it 'handles no old abandoned carts gracefully' do
      expect { DeleteAbandonedCartsJob.new.perform }.not_to change(Cart, :count)
    end
  end
end