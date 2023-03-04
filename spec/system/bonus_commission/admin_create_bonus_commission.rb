require 'rails_helper'

describe 'Administrador inicia a criação de uma campanha de bonus,' do
  context 'estando logado como vendedor' do
    it 'e não consegue acessar a página' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)

      visit root_path
      login_as(salesman)

      expect(page).not_to have_content 'Campanha de bonificação'
    end
  end
  context 'estando logado como administrador,' do
    it 'sem sucesso' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      visit root_path
      login_as(admin)
      click_on 'Campanha de bonificação'
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: ''
      fill_in 'Data de início', with: ''
      fill_in 'Data fim', with: ''
      fill_in 'Percentual de comissão', with: ''
      fill_in 'limite de comissão', with: ''
      click_on 'Salvar'

      expect(page).to have_content 'Campanha não cadastrada.'
      expect(page).to have_content 'Percentual de comissão não pode ficar em branco'
      expect(page).to have_content 'Nome da campanha de bonificação não pode ficar em branco'
      expect(page).to have_content 'Data de início não pode ficar em branco'
      expect(page).to have_content 'Data fim não pode ficar em branco'
      expect(page).to have_content 'Percentual de comissão não pode ficar em branco'
    end
    it 'com sucesso' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      visit root_path
      login_as(admin)
      click_on 'Campanha de bonificação'
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: 'Hospedagem GO'
      fill_in 'Data de início', with: Date.current
      fill_in 'Data fim', with: 10.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'limite de comissão', with: 100
      click_on 'Salvar'

      expect(page).to have_content "Hospedagem GO #{I18n.localize(Date.current.to_date)} #{I18n.localize(10.days.from_now.to_date)} 10,000% R$ 100,00"
    end
  end
  context 'digitando uma' do
    it 'senha' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      visit root_path
      login_as(admin)
      click_on 'Campanha de bonificação'
      click_on 'Criar nova campanha'

    end
    it 'data de início anterior à atual, tendo erro' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      visit root_path
      login_as(admin)
      click_on 'Campanha de bonificação'
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: 'Hospedagem GO'
      fill_in 'Data de início', with: 1.day.ago
      fill_in 'Data fim', with: 10.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'limite de comissão', with: 100
      click_on 'Salvar'

      expect(page).to have_content 'Campanha não cadastrada.'
      expect(page).to have_content 'Data de início não pode ser anterior à atual'
    end
  end
end
