class CartProductSerializer < ActiveModel::Serializer
  attributes :id, :unit_price, :total_price, :name, :quantity

end