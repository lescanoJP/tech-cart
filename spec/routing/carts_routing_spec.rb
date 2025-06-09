require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/carts').to route_to('carts#index')
    end

    it 'routes to #add_item via POST' do
      expect(put: '/carts/add_item').to route_to('carts#add_item')
    end
  end
end 
