class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, foreign_key: 'salesman_id',
                    class_name: 'Order',
                    dependent: :destroy,
                    inverse_of: :salesman

  has_many :paid_commissions, foreign_key: 'salesman_id',
                              class_name: 'PaidCommission',
                              dependent: :destroy,
                              inverse_of: :salesman
end
