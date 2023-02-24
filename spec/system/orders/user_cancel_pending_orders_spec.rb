require 'rails_helper'

describe 'Orders Cancel' do
  it 'Salesman should only see one the cancel button at the Orders list page' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    customer = create(:customer, doc_ident: '22200022201')

    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem GO', price: '30.00',
                   product_plan_periodicity: 'Mensal',
                   status: Order.statuses[:pending])
    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem XYZ', price: '50.00',
                   product_plan_periodicity: 'Anual',
                   status: Order.statuses[:paid])
    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   product_plan_name: 'Hospedagem XYZ', price: '50.00',
                   product_plan_periodicity: 'Anual',
                   cancel_reason: 'Cliente desistiu',
                   status: Order.statuses[:cancelled])

    login_as(salesman)
    visit(root_path)
    click_on('Vendas')

    expect(page).to have_css('button.button_cancel', count: 1, text: 'Cancelar')
  end

  it 'Salesman should be able to click one the cancel button at the Orders list page' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    customer = create(:customer, doc_ident: '22200022201')

    order_pending = create(:order, customer_id: customer.id, salesman_id: salesman.id,
                                   status: Order.statuses[:pending])
    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   status: Order.statuses[:paid])
    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   cancel_reason: 'Cliente desistiu',
                   status: Order.statuses[:cancelled])

    login_as(salesman)
    visit(root_path)
    click_on('Vendas')
    click_on('Cancelar')

    expect(current_path).to eq(order_cancel_reason_order_path(order_pending.id))
  end

  it 'Salesman completes the cancellation action with success' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    customer = create(:customer, doc_ident: '22200022201')

    order_pending = create(:order, customer_id: customer.id, salesman_id: salesman.id,
                                   status: Order.statuses[:pending])
    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   status: Order.statuses[:paid])
    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   cancel_reason: 'Cliente desistiu',
                   status: Order.statuses[:cancelled])

    login_as(salesman)
    visit(root_path)
    click_on('Vendas')
    click_on('Cancelar')
    fill_in 'Motivo do cancelamento', with: 'O cliente desisitiu.'
    click_on('Enviar')

    expect(current_path).to eq(orders_path)
    expect(page).to have_content("Ordem #{order_pending.order_code} cancelada")
  end

  it 'Salesman cant completes the cancellation without providing a reason' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    customer = create(:customer, doc_ident: '22200022201')

    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   status: Order.statuses[:pending])
    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   status: Order.statuses[:paid])
    create(:order, customer_id: customer.id, salesman_id: salesman.id,
                   cancel_reason: 'Cliente desistiu',
                   status: Order.statuses[:cancelled])

    login_as(salesman)
    visit(root_path)
    click_on('Vendas')
    click_on('Cancelar')
    click_on('Enviar')

    expect(current_path).not_to eq(orders_path)
    expect(page).to have_content('O motivo do cancelamento precisa ser preenchido')
  end
end
