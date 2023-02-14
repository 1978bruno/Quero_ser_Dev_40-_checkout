require 'rails_helper'

describe 'User faz login' do
  it 'com sucesso' do
    create(:user, email: 'user@sistema.com.br', password: '12345678')
    visit root_path

    click_on 'Entrar'
    fill_in 'Email', with: 'user@sistema.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Log in'

    expect(page).to have_css('div.notice', text: 'Signed in successfully.')
  end

  it 'com e-mail não cadastrado' do
    visit root_path

    click_on 'Entrar'
    fill_in 'Email', with: 'user@sistema.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Log in'

    expect(page).to have_css('div.alert', text: 'Invalid Email or password.')
  end
end
