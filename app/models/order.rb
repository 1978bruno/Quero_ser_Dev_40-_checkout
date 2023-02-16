class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :salesman, class_name: 'User'

  enum status: { pending: 0, paid: 3, cancelled: 5 }
end
