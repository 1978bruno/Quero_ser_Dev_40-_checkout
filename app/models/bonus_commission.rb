class BonusCommission < ApplicationRecord
  scope :active, -> { where(active: true) }

  validates :description, :commission_perc, :amount_limit, presence: true

  # Não validaria isso. Acho que a pessoa pode cadastrar retroativo sem afetar o sistema.
  # Nem sempre dá p/ cadastrar no dia.
  # validates :start_date, comparison: { greater_than_or_equal_to: Time.current }
  validates :end_date, comparison: { greater_than: :start_date }
end
