class CartProduct < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates_numericality_of :quantity, greater_than: 0

  def unit_price
    product.price
  end

  def total_price
    unit_price * quantity
  end

  def name
    product.name
  end
end
