require 'rails_helper'

describe 'Seller user view only orders created by him' do
  it 'with success' do
    salesman = create(:user, email: 'user@sistema.com.br', password: '12345678')
    other_user = create(:user, email: 'second-user@sistema.com.br', password: '12345600')
    customer = create(:customer, doc_ident: '22200022201')
    create_list(:order, 10, customer_id: customer.id, salesman_id: salesman.id)
    create_list(:order, 10, customer_id: customer.id, salesman_id: other_user.id)

    login_as(salesman)
    visit(orders_path)

    expect(page).to have_css('tr', count: 10)
  end
end
