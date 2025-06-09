class Cart::Create < BaseService

  steps :find_product,
        :validate_quantity,
        :sum_total_price,
        :create_cart,
        :add_item_to_cart

  def initialize(cart_params:)
    @product_id = cart_params[:product_id]
    @quantity = cart_params[:quantity]
  end

  def call
    process_steps
    @cart
  end

  private

  def find_product
    @product = Product.find_by(id: @product_id)

    fail("Produto não encontrado") unless @product.present?
  end

  def validate_quantity
    fail('Quantidade deve ser maior que zero') unless @quantity.positive?
  end

  def sum_total_price
    @price = @product.price * @quantity
  end

  def create_cart
    @cart = Cart.new(total_price: @price)
    
    fail(@cart.errors.full_messages) unless @cart.save
  end

  def add_item_to_cart
    @cart_product = @cart.products.new(product: @product, quantity: @quantity)

    fail(@cart_product.errors.full_messages) unless @cart_product.save 
  end

end
