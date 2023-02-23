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
    within('tr#user_2') do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'José da Silva'
    click_on 'Salvar'

    expect(page).to have_content 'Alterado com sucesso'
    expect(page).to have_content 'José da Silva'
  end
  it 'e falha com um domínio inválido' do
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
      click_on 'Editar'
    end
    fill_in 'E-mail', with: 'jsilva@gmail.com'
    click_on 'Salvar'

    expect(page).to have_content 'E-mail não pertence a um domínio válido'
  end
  it 'e falha com campo vazio' do
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
      click_on 'Editar'
    end
    fill_in 'E-mail', with: ''
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end
  it 'e falha se não confirma a senha' do
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
      click_on 'Editar'
    end
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'erq34erwe'
    click_on 'Salvar'

    expect(page).to have_content 'Confirme sua senha não é igual a Senha'
  end
  it 'e falha se e-mail já existir' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    create(:user, name: 'Pedro Santos', email: 'psantos@locaweb.com.br', password: '12345678')

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
      click_on 'Editar'
    end
    fill_in 'E-mail', with: 'psantos@locaweb.com.br'
    click_on 'Salvar'

    expect(page).to have_content 'E-mail já está em uso'
  end
  it 'e altera usuário para administrador' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    create(:user, name: 'Pedro Santos', email: 'psantos@locaweb.com.br', password: '12345678')

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
    within('tr#user_3') do
      click_on 'Editar'
    end
    find(:css, '#user_admin').set(true)
    click_on 'Salvar'

    expect(page).to have_content 'Alterado com sucesso'
    within('tr#user_3') do
      expect(page).to have_css '.ls-ico-checkmark'
    end
  end
end
