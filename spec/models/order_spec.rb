require 'rails_helper'
require 'securerandom'

RSpec.describe Order, type: :model do
  describe '#gen_order_code' do
    it 'should generate code automatically' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF1020')
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      customer = create(:customer, doc_ident: '22200022201')
      order = Order.new({
                          product_plan_id: 1,
                          product_plan_frequency_id: 2,
                          price: 99.00,
                          customer:,
                          salesman:
                        })
      order.save!
      expect(order.valid?).to be_truthy
      expect(order.order_code).to eq('order_ABCDEF1020')
    end
  end
end
