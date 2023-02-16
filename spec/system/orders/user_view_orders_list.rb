require 'rails_helper'

describe 'Seller user view only orders created by him' do
  it 'with success' do
    salesman = create(:user, email: 'user@sistema.com.br', password: '12345678')
    other_user = create(:user, email: 'second-user@sistema.com.br', password: '12345600')
    orders_salesman = create_list(:order, 10, salesman: salesman)
    orders_other = create_list(:order, 10, salesman: other_user)

    login_as(user)
    visit('orders_path')

    expect(page).to have_css('tr', count: 10)
  end
end