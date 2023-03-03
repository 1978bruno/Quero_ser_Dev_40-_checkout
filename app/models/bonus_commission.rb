class BonusCommission < ApplicationRecord
  scope :active, -> { where(active: true) }

  def cap_limit?
    # Regra de negócio: Se o amount limit for 0 não tem limite para o bonus
    amount_limit.positive?
  end
end
