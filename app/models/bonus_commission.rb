class BonusCommission < ApplicationRecord
  scope :active, -> { where(active: true) }
end
