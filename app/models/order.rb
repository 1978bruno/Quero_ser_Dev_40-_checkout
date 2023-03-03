require 'securerandom'
require 'cpf_cnpj'

class Order < ApplicationRecord
  belongs_to :salesman, class_name: 'User'

  enum status: { pending: 0, paid: 3, cancelled: 5 }

  before_validation :gen_order_code, on: :create

  validates :order_code,
            :price,
            :product_plan_name,
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
