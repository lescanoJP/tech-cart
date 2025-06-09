class CartSerializer < ActiveModel::Serializer
  attributes :id, :total_price, :status

  has_many :products, serializer: CartProductSerializer
end