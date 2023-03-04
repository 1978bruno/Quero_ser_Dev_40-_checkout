class BonusCommission < ApplicationRecord
  validates :description, :commission_perc, :amount_limit, presence: true

  validates :start_date, comparison: { greater_than_or_equal_to: I18n.localize(Date.current) }
  validates :end_date, comparison: { greater_than: :start_date }
end
