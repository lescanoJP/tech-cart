class Cart::AddItem < BaseService
  steps :find_product,
        :fetch_product_in_cart,
        :upsert_product,
        :calculate_new_total_price,
        :update_total_price

  def initialize(cart:, cart_params:)
    @cart = cart
    @product_id = cart_params[:product_id],
    @quantity = cart_params[:quantity]
  end

  def call
    process_steps
    @cart
  end

  private

  def find_product
    @product = Product.find_by(id: @product_id)

    fail('Produto não encontrado') unless @product.present?
  end

  def fetch_product_in_cart
    @cart_product = @cart.products.find_by(product_id: @product_id)
  end

  def upsert_product
    if @cart_product.present?
      @cart_product.assign_attributes(quantity: @quantity)
    else
      @cart_product = @cart.products.new(product: @product, quantity: @quantity)
    end

    fail(@cart_product.errors.full_messages) unless @cart_product.save
  end

  def calculate_new_total_price
    @total_price = @cart.products.map(&:total_price).sum
  end

  def update_total_price
    @cart.update(total_price: @total_price)
  end

end
