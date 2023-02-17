require 'rails_helper'

describe 'administrador cadastra um usuário' do
  it 'com sucesso' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)

    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Login'
    end
    click_on 'Usuários'
    click_on 'Criar Usuário'
    fill_in 'Nome', with: 'José Silva'
    fill_in 'E-mail', with: 'jsilva@locaweb.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Salvar'

    expect(page).to have_content 'Usuário cadastrado com sucesso'
    expect(page).to have_content 'José Silva'
    expect(page).to have_content 'jsilva@locaweb.com.br'
  end
end
