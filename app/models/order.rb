require 'securerandom'

class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :salesman, class_name: 'User'

  enum status: { pending: 0, paid: 3, cancelled: 5 }

  before_validation :gen_order_code, on: :create

  validates :price,
            :product_plan_name,
            :product_plan_periodicity,
            :status,
            presence: true

  validates_presence_of :cancel_reason, :if => :cancelled?

  private

  def gen_order_code
    self.order_code = "order_#{SecureRandom.alphanumeric(10)}"
  end
end
