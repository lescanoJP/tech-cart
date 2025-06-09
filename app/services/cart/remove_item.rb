class Cart::RemoveItem < BaseService
  steps :fetch_item,
        :remove_item,
        :calculate_total_price,
        :update_total_price

  def initialize(cart:, product_id:)
    @cart = cart
    @product_id = product_id.to_i
  end

  def call
    process_steps
    @cart
  end

  private

  def fetch_item
    @cart_product = @cart.products.find_by(product_id: @product_id)

    fail('Item não está no carrinho') unless @cart_product.present?
  end

  def remove_item
    @cart_product.destroy
  end

  def calculate_total_price
    @total_price = @cart.products.map(&:total_price).sum
  end

  def update_total_price
    @cart.update(total_price: @total_price)
  end
end
