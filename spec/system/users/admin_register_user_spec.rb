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

    within('tr#user_2') do
      expect(page).to have_content 'José Silva'
      expect(page).to have_content 'jsilva@locaweb.com.br'
      expect(page).not_to have_css '.ls-ico-checkmark'
    end
  end
  it 'e falha com um domínio inválido' do
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
    fill_in 'E-mail', with: 'jsilva@gmail.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Salvar'

    expect(page).to have_content 'E-mail não pertence a um domínio válido'
    expect(page).not_to have_content 'Usuário cadastrado com sucesso'
    expect(page).to have_field('E-mail', with: 'jsilva@gmail.com')
  end
  it 'e falha com campos vazios' do
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
    fill_in 'Nome', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_on 'Salvar'

    expect(page).not_to have_content 'Usuário cadastrado com sucesso'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end
  it 'e falha se não confirma a senha' do
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
    fill_in 'Confirme sua senha', with: 'wordpass'
    click_on 'Salvar'

    expect(page).not_to have_content 'Usuário cadastrado com sucesso'
    expect(page).to have_content 'Confirme sua senha não é igual a Senha'
  end
  it 'e falha se email já existe' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '87654321')

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
    fill_in 'Nome', with: 'João Silva'
    fill_in 'E-mail', with: 'jsilva@locaweb.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Salvar'

    expect(page).not_to have_content 'Usuário cadastrado com sucesso'
    expect(page).to have_content 'E-mail já está em uso'
  end
end
