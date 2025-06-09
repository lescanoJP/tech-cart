class Cart < ApplicationRecord
  extend Enumerize
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :products, dependent: :destroy, class_name: 'CartProduct'

  enumerize :status, in: { active: 0, abandoned: 1 }, default: :active

end
