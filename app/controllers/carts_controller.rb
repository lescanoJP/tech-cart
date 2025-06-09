class CartsController < ApplicationController
  before_action :fetch_current_cart, only: %i[ add_item destroy ]

  def index
    cart = Cart.last || Cart.create!(total_price: 0)
    render json: cart, status: :ok
  end

  def create
    create_service = Cart::Create.call(cart_params: cart_params)
  
    return render json: create_service.result, serializer: CartSerializer, status: :created if create_service.success?

    render json: create_service.errors, status: :unprocessable_entity
  end

  def add_item
    add_item_service = Cart::AddItem.call(cart: @current_cart, cart_params:)

    return render json: add_item_service.result, serializer: CartSerializer, status: :ok if add_item_service.success?

    render json: add_item_service.errors, status: :unprocessable_entity
  end

  def destroy
    remove_from_cart_service = Cart::RemoveItem.call(cart: @current_cart, product_id: params[:id])

    return render json: remove_from_cart_service.result, serializer: CartSerializer, status: :ok if remove_from_cart_service.success?

    render json: remove_from_cart_service.errors, status: :unprocessable_entity
  end

  private

  def cart_params
    params.permit(:product_id, :quantity)
  end

  def fetch_current_cart
    @current_cart = Cart.last || Cart.create!(total_price: 0)
  end

end
