require 'rails_helper'

describe 'Vendedor informa os dados de um novo cliente' do
  context 'para CPF não encontrado na base' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '69274376146'
      click_on 'Pesquisar Cliente'
      fill_in 'Nome', with: 'José da Silva'
      fill_in 'Endereço', with: 'Av. Principal, 100'
      fill_in 'Cidade', with: 'São Paulo'
      select 'São Paulo', from: 'creation_order_customer_state'
      fill_in 'CEP', with: '11111-111'
      fill_in 'E-mail', with: 'jose.silva@email.com.br'
      fill_in 'Data Nascimento', with: '01/01/1980'
      fill_in 'Telefone', with: '(11) 99999-8888'
      click_on 'Continuar'

      expect(page).not_to have_content 'Dados do cliente'
      within('div#step_active') do
        expect(page).to have_content 'Produtos'
      end
    end

    it 'sem sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '69274376146'
      click_on 'Pesquisar Cliente'
      click_on 'Continuar'

      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Endereço não pode ficar em branco'
      expect(page).to have_content 'Cidade não pode ficar em branco'
      expect(page).to have_content 'Estado não pode ficar em branco'
      expect(page).to have_content 'CEP não pode ficar em branco'
      expect(page).to have_content 'E-mail não pode ficar em branco'
      expect(page).to have_content 'Telefone não pode ficar em branco'
      expect(page).to have_content 'Data Nascimento não pode ficar em branco'
    end
  end

  context 'para CNPJ não encontrado na base' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '36358603000107'
      click_on 'Pesquisar Cliente'
      fill_in 'Nome', with: 'Acme Ltda'
      fill_in 'Endereço', with: 'Av. Principal, 100'
      fill_in 'Cidade', with: 'São Paulo'
      select 'São Paulo', from: 'creation_order_customer_state'
      fill_in 'CEP', with: '11111-111'
      fill_in 'E-mail', with: 'contato@email.com.br'
      fill_in 'Telefone', with: '(11) 99999-8888'
      fill_in 'Nome Corporativo', with: 'Acme Ltda'
      click_on 'Continuar'

      expect(page).not_to have_content 'Dados do cliente'
    end

    it 'sem sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '36358603000107'
      click_on 'Pesquisar Cliente'
      click_on 'Continuar'

      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Endereço não pode ficar em branco'
      expect(page).to have_content 'Cidade não pode ficar em branco'
      expect(page).to have_content 'Estado não pode ficar em branco'
      expect(page).to have_content 'CEP não pode ficar em branco'
      expect(page).to have_content 'E-mail não pode ficar em branco'
      expect(page).to have_content 'Telefone não pode ficar em branco'
      expect(page).to have_content 'Nome Corporativo não pode ficar em branco'
    end
  end
end
