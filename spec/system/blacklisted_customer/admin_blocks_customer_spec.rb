require 'rails_helper'

describe 'Admin block/unblock customer' do
  it 'visit menu option with success' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

    login_as(admin)
    visit(root_path)
    click_on('Bloqueio de Clientes')

    expect(current_path).to eq(blacklisted_customers_path)
  end

  it 'and cant see menu if not administrator' do
    user = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: false)

    login_as(user)
    visit(root_path)

    within('nav#main-menu') do
      expect(page).not_to have_content('Bloqueio de Clientes')
    end
  end

  it 'and see list of blocked customers' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    BlacklistedCustomer.create!(doc_ident: '18422142414', blacklisted_reason: 'Processo judicial em andamento.')
    BlacklistedCustomer.create!(doc_ident: '12341234123', blacklisted_reason: 'Divida')

    login_as(admin)
    visit(blacklisted_customers_path)

    expect(page).to have_content('18422142414')
    expect(page).to have_content('Processo judicial em andamento.')
    expect(page).to have_content('12341234123')
    expect(page).to have_content('Divida')
    within('tbody') do
      expect(page).to have_css('tr', count: 2)
    end
  end

  it 'and unblock a customer' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    BlacklistedCustomer.create!(doc_ident: '18422142414', blacklisted_reason: 'Processo judicial em andamento.')
    customer_to_block = BlacklistedCustomer.create!(doc_ident: '12341234123', blacklisted_reason: 'Divida')

    login_as(admin)
    visit(blacklisted_customers_path)
    within("#blacklisted_customer_#{customer_to_block.id}") do
      click_on 'Desbloquear'
    end

    expect(page).to have_content('18422142414')
    expect(page).to have_content('Processo judicial em andamento.')
    expect(page).not_to have_content('12341234123')
    expect(page).not_to have_content('Divida')
    within('tbody') do
      expect(page).to have_css('tr', count: 1)
    end
  end
  it 'and searches for an existent customer' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    mocked_api_response = double({ status: 200,
                                   body: JSON.generate({
                                                         doc_ident: '12312312312',
                                                         name: 'José da Silva',
                                                         email: 'jose.silva@email.com.br',
                                                         address: 'Rua das Palmeiras, 100',
                                                         city: 'São Paulo',
                                                         state: 'SP',
                                                         zipcode: '11111-111',
                                                         phone: '11-99999-8888',
                                                         birthdate: '1980-01-01',
                                                         corporate_name: ''
                                                       }) })
    url = "#{Rails.configuration.external_apis['customer_api_url']}/12312312312"
    allow(Faraday).to receive(:get).with(url).and_return(mocked_api_response)

    login_as(admin)
    visit(blacklisted_customers_path)
    fill_in 'search_doc_ident', with: '12312312312'
    click_on 'Buscar'

    within('div#customer_details') do
      expect(page).to have_field('Nome:', with: 'José da Silva', disabled: true)
      expect(page).to have_field('Número do documento:', with: '12312312312', disabled: true)
      expect(page).to have_field('Razão para bloqueio:', count: 1)
    end
  end
end
