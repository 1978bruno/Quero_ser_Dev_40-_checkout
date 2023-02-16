require 'rails_helper'

describe 'User faz login' do
  it 'com sucesso' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    visit root_path

    click_on 'Entrar'
    fill_in 'E-mail', with: 'user@locaweb.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Log in'

    expect(page).to have_css('div.notice', text: 'Login efetuado com sucesso.')
  end

  it 'com e-mail não cadastrado' do
    visit root_path

    click_on 'Entrar'
    fill_in 'E-mail', with: 'user@locaweb.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Log in'

    expect(page).to have_css('div.alert', text: 'E-mail ou senha inválidos.')
  end
end
