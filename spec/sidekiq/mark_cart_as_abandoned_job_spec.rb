require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers 

  let!(:recent_active_cart) { create(:cart, status: :active, last_changed_at: 2.hours.ago) }
  let!(:old_active_cart) { create(:cart, status: :active, last_changed_at: 4.hours.ago) }
  let!(:already_abandoned_cart) { create(:cart, status: :abandoned, last_changed_at: 1.hour.ago) }

  around do |example|
    travel_to Time.current do
      example.run
    end
  end

  it 'marks old active carts as abandoned' do
    MarkCartAsAbandonedJob.new.perform
    expect(old_active_cart.reload.status).to eq('abandoned')
    expect(recent_active_cart.reload.status).to eq('active')
  end

  it 'does not mark recently active carts as abandoned' do
    expect { MarkCartAsAbandonedJob.new.perform }.not_to change(recent_active_cart.reload, :status)
  end

  it 'does not change the status of already abandoned carts' do
    expect { MarkCartAsAbandonedJob.new.perform }.not_to change(already_abandoned_cart.reload, :status)
  end

  it 'handles no inactive carts gracefully' do
    Cart.where(id: old_active_cart.id).destroy_all
    expect { MarkCartAsAbandonedJob.new.perform }.not_to change(Cart, :count)
  end
end