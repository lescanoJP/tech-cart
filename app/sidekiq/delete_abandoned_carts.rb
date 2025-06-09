class DeleteAbandonedCarts
  include Sidekiq::Job

  def perform
    old_abandoned_carts = Cart.old_abandoned

    return unless old_abandoned_carts.present?

    old_abandoned_carts.destroy_all
  end
end
