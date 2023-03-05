require 'securerandom'
require 'cpf_cnpj'

class Order < ApplicationRecord
  belongs_to :salesman, class_name: 'User'
  has_one :paid_commission, dependent: :destroy

  enum status: { pending: 0, awaiting_payment: 2, paid: 3, cancelled: 5 }

  before_validation :gen_order_code, on: :create

  validates :order_code,
            :price,
            :product_group_id,
            :product_group_name,
            :product_plan_id,
            :product_plan_name,
            :product_plan_periodicity_id,
            :product_plan_periodicity,
            :status,
            :customer_doc_ident,
            presence: true

  validates :cancel_reason, if: :cancelled?, presence: true

  def customer_doc_ident_formatted
    case customer_doc_ident.size
    when 11
      cpf = CPF.new(customer_doc_ident)
      cpf.formatted
    when 14
      cnpj = CNPJ.new(customer_doc_ident)
      cnpj.formatted
    end
  end

  def price_with_discount
    price - (price * (discount / 100.0))
  end

  private

  def gen_order_code
    self.order_code = SecureRandom.alphanumeric(10).upcase
  end
end
