class BonusCommission < ApplicationRecord
  validates :description, :start_date, :end_date, :commission_perc, :amount_limit, presence: true
end
