class PaidCommission < ApplicationRecord
  belongs_to :bonus_commission
  belongs_to :salesman, class_name: 'User'
  belongs_to :order

  validates :paid_at, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  class << self
    def pay_commission_from_order_code(order_code)
      order = Order.find_by({ order_code: })

      raise StandardError, 'Código do pedido não encontrado' if order.nil?

      salesman = order.salesman

      total_order = order.price - order.discount
      current_bonus = current_bonus(order.paid_at)
      comission_amount = calculate_commission(current_bonus, total_order)

      PaidCommission.create!({ paid_at: Time.current, amount: comission_amount,
                               bonus_commission: current_bonus, salesman:, order: })
    end

    private

    def calculate_commission(bonus, order_total)
      comission = ((bonus.commission_perc / 100.0) * order_total).round(2)
      bonus.cap_limit? ? [bonus.amount_limit, comission].min : comission
    end

    def current_bonus(order_date)
      bonuses = BonusCommission.active
                               .where('start_date <= ?', order_date)
                               .where('end_date >= ?', order_date)
                               .order(commission_perc: :desc)
                               .take(1)
      raise StandardError, 'O sistema precisa de ter pelo menos o bonus padrão de 1% cadastrado' if bonuses.count.zero?

      bonuses[0]
    end
  end
end
