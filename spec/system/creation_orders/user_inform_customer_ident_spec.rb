require 'rails_helper'

describe 'Vendedor informa o CPF/CNPJ do cliente' do
  context 'tendo para CPF o resultado' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      mocked_answer = double({ status: 200,
                               body: '{
                                "doc_ident":"87591438786",
                                "name":"José da Silva",
                                "email":"jose.silva@email.com.br",
                                "address":"Rua das Palmeiras, 100",
                                "city":"São Paulo",
                                "state":"SP",
                                "zipcode":"11111-111",
                                "phone":"11-99999-8888",
                                "birthdate":"1980-01-01",
                                "corporate_name":""
                                      }' })
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'

      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_field 'creation_order[customer_identification]', disabled: true, with: '87591438786'
      expect(page).to have_field 'creation_order[customer_name]', disabled: true, with: 'José da Silva'
    end

    it 'sem sucesso quando informa um CPF faltando dígitos' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '8759143878'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'Deve ser informado um CPF ou CNPJ válido'
    end

    it 'sem sucesso quando informa um CPF inválido' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438780'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'CPF inválido'
    end

    it 'sem sucesso quando o CPF estiver bloqueado' do
      BlacklistedCustomer.create!(doc_ident: '87591438786', blacklisted_reason: 'Motivo do bloqueio')
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'Este cliente está bloqueado para solicitar novos pedidos'
    end
  end

  context 'tendo para CNPJ o resultado' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      mocked_answer = double({ status: 200,
                               body: '{
                                "doc_ident":"88212849000170",
                                "name":"Acme Ltda",
                                "email":"contato@acme.com.br",
                                "address":"Rua das Palmeiras, 100",
                                "city":"São Paulo",
                                "state":"SP",
                                "zipcode":"11111-111",
                                "phone":"11-99999-7777",
                                "birthdate":"1980-01-01",
                                "corporate_name":"Acme Ltda"
                                      }' })
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '88212849000170'
      click_on 'Pesquisar Cliente'

      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_field 'creation_order[customer_identification]', disabled: true, with: '88212849000170'
      expect(page).to have_field 'creation_order[customer_name]', disabled: true, with: 'Acme Ltda'
    end

    it 'sem sucesso quando informa um CNPJ faltando dígitos ' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '8821284900017'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'Deve ser informado um CPF ou CNPJ válido'
    end

    it 'sem sucesso quando informa um CNPJ inválido' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '88212849000179'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'CNPJ inválido'
    end

    it 'sem sucesso quando o CNPJ estiver bloqueado' do
      BlacklistedCustomer.create!(doc_ident: '88212849000170', blacklisted_reason: 'Motivo do bloqueio')
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
  
      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '88212849000170'
      click_on 'Pesquisar Cliente'
  
      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'Este cliente está bloqueado para solicitar novos pedidos'
    end
  end
end
