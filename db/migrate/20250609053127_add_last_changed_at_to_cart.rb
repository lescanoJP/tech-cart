class AddLastChangedAtToCart < ActiveRecord::Migration[7.1]
  def up
    add_column :carts, :last_changed_at, :datetime
  end

  def down
    remove_column :carts, :last_changed_at
  end
end
