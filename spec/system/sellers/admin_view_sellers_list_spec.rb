require 'rails_helper'

describe 'Admin vê a lista de usuários' do
  it 'a partir da página principal' do
    User.create!(name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Login'
    end
    click_on 'Vendedores'
    expect(current_path).to eq users_path
    expect(page).to have_content 'Lista de Vendedores'
  end
  it 'como resultado da busca' do
    User.create!(name: 'user vendor 1', email: 'uservendor1@locaweb.com.br', password: 'vendor1')
    User.create!(name: 'user vendor 2', email: 'uservendor2@locaweb.com.br', password: 'vendor2')
    User.create!(name: 'user vendor 3', email: 'uservendor3@locaweb.com.br', password: 'vendor3')
    User.create!(name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Login'
    end
    visit root_path
    click_on 'Vendedores'
    fill_in 'query', with: '1'
    click_on 'Buscar'
    expect(page).to have_content 'user vendor 1'
    expect(page).to have_content 'uservendor1@locaweb.com.br'
    expect(page).not_to have_content 'user vendor 2'
  end
  it 'vê a mensagem Não existem vendedores cadastrados' do
    User.create!(name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Login'
    end
    visit root_path
    click_on 'Vendedores'
    expect(page).to have_content 'Não existem vendedores cadastrados'
  end
end
