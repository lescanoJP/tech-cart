class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    abandoned_carts = Cart.inactive

    return unless abandoned_carts.present?

    abandoned_carts.update_all(status: :abandoned)
  end
end
