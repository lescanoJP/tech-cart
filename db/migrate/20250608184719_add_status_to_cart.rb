class AddStatusToCart < ActiveRecord::Migration[7.1]
  def up
    add_column :carts, :status, :integer
  end

  def down
    remove_column :carts, :status, :integer
  end
end
