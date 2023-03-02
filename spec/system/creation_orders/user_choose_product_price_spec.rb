require 'rails_helper'

describe 'Vendedor navega até a escolha do pacote' do
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

    within('div#step_active') do
      expect(page).to have_content 'Preços'
    end
    expect(page).to have_content 'Hospedagem de Sites / Hospedagem II'
    within('label#card_1') do
      expect(page).to have_content 'Trimestral'
      expect(page).to have_content 'R$ 80,97'
    end
    within('label#card_2') do
      expect(page).to have_content 'Semestral'
      expect(page).to have_content 'R$ 60,97'
    end
  end

  it 'e escolhe um pacote com sucesso' do
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

    within('div#step_active') do
      expect(page).to have_content 'Confirmação'
    end
    expect(page).to have_content 'Confirmação do Pedido'
    within('tr#order_item') do
      expect(page).to have_content 'Hospedagem de Sites'
      expect(page).to have_content 'Hospedagem II'
      expect(page).to have_content 'Trimestral'
      expect(page).to have_content 'R$ 80,97'
    end
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
    mocked_answer = double(api_result_plans)
    allow(Faraday).to receive(:get).and_return(mocked_answer)
    click_on 'Voltar'

    expect(page).to have_content 'Planos'
    expect(find_field('creation_order_product_plan_form_3hospedagem_ii').checked?).to eq(true)
  end

  it 'e tenta continuar sem escolher um pacote' do
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
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Preços'
    end
    expect(page).to have_content 'Deve ser selecionada uma das opções'
  end

  it 'e ocorre um erro na API' do
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
    mocked_answer = double(api_result_failed)
    allow(Faraday).to receive(:get).and_return(mocked_answer)
    click_on 'Continuar'

    expect(page).to have_content 'Hospedagem de Sites / Hospedagem II'
    expect(page).to have_content 'Não foi possível acessar a API de preços'
  end
end
