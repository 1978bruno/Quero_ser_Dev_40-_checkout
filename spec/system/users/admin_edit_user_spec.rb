require 'rails_helper'

describe 'Administrador edita um usuário' do
  it 'com sucesso' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')

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
    save_page
    within('div#user_2') do
      click_on 'Editar usuário'
    end
    fill_in 'Nome', with: 'José da Silva'
    click_on 'Salvar'

    expect(page).to have_content 'Alterado com sucesso'
    expect(page).to have_content 'José da Silva'
  end
end
