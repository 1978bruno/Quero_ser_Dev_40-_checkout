require 'rails_helper'

describe 'Vendedor informa os dados de um novo cliente' do
  context 'tendo para CPF o resultado' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'

      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_field 'creation_order[customer_identification]', disabled: true, with: '87591438786'
    end
  end
end
