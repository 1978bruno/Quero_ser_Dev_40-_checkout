require 'rails_helper'

describe 'Administrador altera status de um usuário' do
  it 'bloqueando com sucesso' do
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
    within('tr#user_2') do
      click_on 'Bloquear'
    end

    expect(page).to have_content 'Usuário bloqueado com sucesso'
    within('tr#user_2') do
      expect(page).to have_button 'Desbloquear'
    end
  end

  it 'desbloqueando com sucesso' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678', active: false)

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
    within('tr#user_2') do
      click_on 'Desbloquear'
    end

    expect(page).to have_content 'Usuário desbloqueado com sucesso'
    within('tr#user_2') do
      expect(page).to have_button 'Bloquear'
    end
  end
end
