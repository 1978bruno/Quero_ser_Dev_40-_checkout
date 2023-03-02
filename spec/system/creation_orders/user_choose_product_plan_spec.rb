require 'rails_helper'

describe 'Vendedor escolhe plano' do
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

    within('div#step_active') do
      expect(page).to have_content 'Planos'
    end
    expect(page).to have_content 'Hospedagem de Sites'
    expect(page).to have_content 'Hospedagem GO'
    expect(page).to have_content 'Hospedagem I'
    expect(page).to have_content 'Hospedagem II'
  end

  it 'e escolhe um produto com sucesso' do
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

    within('div#step_active') do
      expect(page).to have_content 'Preços'
    end
    expect(page).to have_content 'Hospedagem de Sites / Hospedagem II'
    expect(page).to have_content 'Trimestral'
    expect(page).to have_content 'Semestral'
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
    mocked_answer = double(api_result_products)
    allow(Faraday).to receive(:get).and_return(mocked_answer)
    click_on 'Voltar'

    save_page

    expect(page).to have_content 'Produtos'
    expect(find_field('creation_order_product_group_form_1hospedagem_de_sites').checked?).to eq(true)
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
    mocked_answer = double(api_result_failed)
    allow(Faraday).to receive(:get).and_return(mocked_answer)
    click_on 'Continuar'

    expect(page).to have_content 'Hospedagem de Sites'
    expect(page).to have_content 'Não foi possível acessar a API de planos'
  end
end
