require 'rails_helper'

describe 'Vendedor navega até a confirmação do pedido' do
  context 'para CPF' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      fake_response_customer = double(api_result_customer)
      allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)
      fake_response_products = double(api_result_products)
      allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
      fake_response_plans = double(api_result_plans)
      allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)
      fake_response_prices = double(api_result_prices)
      allow(Faraday).to receive(:get).with(url_api_product_prices('3')).and_return(fake_response_prices)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'
      click_on 'Continuar'
      choose 'Hospedagem de Sites'
      click_on 'Continuar'
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
      fake_response_customer = double(api_result_customer)
      allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)
      fake_response_products = double(api_result_products)
      allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
      fake_response_plans = double(api_result_plans)
      allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)
      fake_response_prices = double(api_result_prices)
      allow(Faraday).to receive(:get).with(url_api_product_prices('3')).and_return(fake_response_prices)
      allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('ABCDE12345')

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'
      click_on 'Continuar'
      choose 'Hospedagem de Sites'
      click_on 'Continuar'
      choose 'Hospedagem II'
      click_on 'Continuar'
      choose 'Trimestral'
      click_on 'Continuar'
      click_on 'Confirmar Pedido'

      expect(page).to have_content 'Pedido criado com sucesso'
      expect(page).to have_content 'Detalhes do Pedido - ABCDE12345'
      expect(page).to have_field 'salesman', disabled: true, with: "#{salesman.name} (#{salesman.email})"
      expect(page).to have_css '#status', text: 'Pendente'
      expect(page).to have_field 'customer_identification', disabled: true, with: '875.914.387-86'
      expect(page).to have_field 'customer_name', disabled: true, with: 'José da Silva'
      expect(page).to have_field 'price', disabled: true, with: 'R$ 80,97'
    end

    it 'e retorna à página anterior sem perdas de informação' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      fake_response_customer = double(api_result_customer)
      allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)
      fake_response_products = double(api_result_products)
      allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
      fake_response_plans = double(api_result_plans)
      allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)
      fake_response_prices = double(api_result_prices)
      allow(Faraday).to receive(:get).with(url_api_product_prices('3')).and_return(fake_response_prices)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'
      click_on 'Continuar'
      choose 'Hospedagem de Sites'
      click_on 'Continuar'
      choose 'Hospedagem II'
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
      fake_response_customer = double(api_result_customer)
      allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)
      fake_response_products = double(api_result_products)
      allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
      fake_response_plans = double(api_result_plans)
      allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)
      fake_response_prices = double(api_result_prices)
      allow(Faraday).to receive(:get).with(url_api_product_prices('3')).and_return(fake_response_prices)
      allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('')

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'
      click_on 'Continuar'
      choose 'Hospedagem de Sites'
      click_on 'Continuar'
      choose 'Hospedagem II'
      click_on 'Continuar'
      choose 'Trimestral'
      click_on 'Continuar'
      click_on 'Confirmar Pedido'

      expect(page).to have_content 'Ocorreu um problema na criação do pedido'
      expect(page).to have_content 'Código do Pedido não pode ficar em branco'
    end
  end

  context 'para CNPJ' do
    it 'se aparece formatado na tela de confirmação' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      fake_response_customer = double(api_result_customer_cnpj)
      allow(Faraday).to receive(:get).with(url_api_customer('36358603000107')).and_return(fake_response_customer)
      fake_response_products = double(api_result_products)
      allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
      fake_response_plans = double(api_result_plans)
      allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)
      fake_response_prices = double(api_result_prices)
      allow(Faraday).to receive(:get).with(url_api_product_prices('3')).and_return(fake_response_prices)

      visit root_path
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '36358603000107'
      click_on 'Pesquisar Cliente'
      click_on 'Continuar'
      choose 'Hospedagem de Sites'
      click_on 'Continuar'
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
