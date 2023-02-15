class PaidCommission < ApplicationRecord
  belongs_to :bonus_commission
  belongs_to :salesman, class_name: 'User'
end
