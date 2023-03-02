require 'rails_helper'

describe 'Vendedor navega até a confirmação do pedido' do
  context 'para CPF' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      mocked_answer = double(api_result_customer)
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'
      mocked_answer = double(api_result_products)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      mocked_answer = double(api_result_plans)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      choose 'Hospedagem de Sites'
      click_on 'Continuar'
      mocked_answer = double(api_result_prices)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      choose 'Hospedagem II'
      click_on 'Continuar'
      choose 'Trimestral'
      click_on 'Continuar'

      within('div#step_active') do
        expect(page).to have_content 'Confirmação'
      end
      expect(page).to have_content 'Confirmação do Pedido'
      within('tr#order_item') do
        expect(page).to have_content 'Hospedagem de Sites Hospedagem II Trimestral R$ 80,97'
      end
    end

    it 'e confirma com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      mocked_answer = double(api_result_customer)
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'
      mocked_answer = double(api_result_products)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Hospedagem de Sites'
      mocked_answer = double(api_result_plans)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Hospedagem II'
      mocked_answer = double(api_result_prices)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Trimestral'
      click_on 'Continuar'
      allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('ABCDE12345')
      click_on 'Confirmar Pedido'

      expect(page).to have_content 'Pedido criado com sucesso'
      expect(page).to have_content 'ABCDE12345 vendedor1@locaweb.com.br 87591438786 Hospedagem II Trimestral R$ 80,97'
    end

    it 'e retorna à página anterior sem perdas de informação' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      mocked_answer = double(api_result_customer)
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'
      mocked_answer = double(api_result_products)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Hospedagem de Sites'
      mocked_answer = double(api_result_plans)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Hospedagem II'
      mocked_answer = double(api_result_prices)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Trimestral'
      click_on 'Continuar'
      click_on 'Voltar'

      expect(page).to have_content 'Preços'
      expect(find_field('creation_order_product_price_form_trimestral80_97').checked?).to eq(true)
    end

    it 'e ocorre um erro durante a confirmação' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      mocked_answer = double(api_result_customer)
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'
      mocked_answer = double(api_result_products)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Hospedagem de Sites'
      mocked_answer = double(api_result_plans)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Hospedagem II'
      mocked_answer = double(api_result_prices)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      choose 'Trimestral'
      click_on 'Continuar'
      allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('')
      click_on 'Confirmar Pedido'

      expect(page).to have_content 'Ocorreu um problema na criação do pedido'
      expect(page).to have_content 'Código do Pedido não pode ficar em branco'
    end
  end

  context 'para CNPJ' do
    it 'se aparece formatado na tela de confirmação' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      mocked_answer = double(api_result_customer_cnpj)
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '36358603000107'
      click_on 'Pesquisar Cliente'
      mocked_answer = double(api_result_products)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      click_on 'Continuar'
      mocked_answer = double(api_result_plans)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      choose 'Hospedagem de Sites'
      click_on 'Continuar'
      mocked_answer = double(api_result_prices)
      allow(Faraday).to receive(:get).and_return(mocked_answer)
      choose 'Hospedagem II'
      click_on 'Continuar'
      choose 'Trimestral'
      click_on 'Continuar'

      within('div#step_active') do
        expect(page).to have_content 'Confirmação'
      end
      expect(page).to have_content 'Confirmação do Pedido'
      expect(page).to have_field 'customer_identification', disabled: true, with: '36.358.603/0001-07'
    end
  end
end
