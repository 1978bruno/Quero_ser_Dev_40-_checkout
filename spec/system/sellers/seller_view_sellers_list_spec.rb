require 'rails_helper'

describe 'Vendedor vê a lista de usuários' do
  it 'e exerga a mensagem de restrição de acesso.' do
    User.create!(name: 'user vendor 1', email: 'uservendor1@locaweb.com.br', password: 'vendor1')
    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'uservendor1@locaweb.com.br'
      fill_in 'Senha', with: 'vendor1'
      click_on 'Login'
    end
    click_on 'Vendedores'
    expect(page).to have_content 'Não tem acesso. Precisa estar logado como Admin.'
  end
  it 'e vê somente o seu usuário.' do
    User.create!(name: 'user vendor 1', email: 'uservendor1@locaweb.com.br', password: 'vendor1')
    User.create!(name: 'user vendor 2', email: 'uservendor2@locaweb.com.br', password: 'vendor2')
    User.create!(name: 'user vendor 3', email: 'uservendor3@locaweb.com.br', password: 'vendor3')
    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'uservendor1@locaweb.com.br'
      fill_in 'Senha', with: 'vendor1'
      click_on 'Login'
    end
    click_on 'Vendedores'
    expect(page).to have_content 'user vendor 1'
    expect(page).not_to have_content 'user vendor 2'
    expect(page).not_to have_content 'user vendor 3'
  end
  it 'e não consegue acessar o botão de busca.' do
    User.create!(name: 'user vendor 1', email: 'uservendor1@locaweb.com.br', password: 'vendor1')
    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'uservendor1@locaweb.com.br'
      fill_in 'Senha', with: 'vendor1'
      click_on 'Login'
    end
    click_on 'Vendedores'
    expect(page).not_to have_button 'Buscar'
  end
end
