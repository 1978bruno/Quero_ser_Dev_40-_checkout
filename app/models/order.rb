class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :salesman, class_name: 'User'
end
