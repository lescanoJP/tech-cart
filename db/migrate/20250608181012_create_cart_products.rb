class CreateCartProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_products do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :cart, null: false, foreign_key: true
      t.integer :quantity
      t.float :total_price

      t.timestamps
    end
  end
end
