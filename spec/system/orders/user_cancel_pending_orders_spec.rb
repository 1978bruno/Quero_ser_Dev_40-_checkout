require 'rails_helper'

describe 'Orders Cancel' do
  it 'Salesman should only see one the cancel button at the Orders list page' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    login_as(salesman)
    visit(orders_path)
    customer = create(:customer, doc_ident: '22200022201')
    create(:order, customer_id: customer.id,
                   salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem GO',
                   product_plan_periodicity: 'Mensal',
                   status: Order.statuses[:pending])
    create(:order, customer_id: customer.id,
                   salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem XYZ',
                   product_plan_periodicity: 'Anual',
                   status: Order.statuses[:paid])
    create(:order, customer_id: customer.id,
                   salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem XYZ',
                   product_plan_periodicity: 'Anual',
                   status: Order.statuses[:cancelled])

    expect(page).to have_css('.button_cancel', count: 1)
  end

  it 'Salesman should be able to click one the cancel button at the Orders list page' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    login_as(salesman)
    visit(orders_path)
    customer = create(:customer, doc_ident: '22200022201')
    create(:order, customer_id: customer.id,
                   salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem GO',
                   product_plan_periodicity: 'Mensal',
                   status: Order.statuses[:pending])
    create(:order, customer_id: customer.id,
                   salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem XYZ',
                   product_plan_periodicity: 'Anual',
                   status: Order.statuses[:paid])
    create(:order, customer_id: customer.id,
                   salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem XYZ',
                   product_plan_periodicity: 'Anual',
                   status: Order.statuses[:cancelled])
    click_on('Cancelar')

    expect(current_path).to eq(order_cancel_reason_order_path)
  end
end
