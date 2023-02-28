require 'securerandom'

class Order < ApplicationRecord
  belongs_to :salesman, class_name: 'User'

  enum status: { pending: 0, paid: 3, cancelled: 5 }

  before_validation :gen_order_code, on: :create

  validates :price,
            :product_plan_name,
            :product_plan_periodicity,
            :status,
            :customer_doc_ident,
            presence: true

  validates :cancel_reason, if: :cancelled?, presence: true

  private

  def gen_order_code
    self.order_code = SecureRandom.alphanumeric(10).upcase
  end
end
