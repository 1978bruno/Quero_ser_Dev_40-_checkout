require 'rails_helper'

describe 'Administrador inicia a criação de uma campanha de bonus,' do
  context 'estando logado,' do
    it 'com sucesso' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      visit root_path
      login_as admin
      click_on 'Campanha de bonificação'
      click_on 'Criar nova campanha'
      fill_in 'Descrição', with: 'Hospedagem GO'
      fill_in 'Data de início da campanha', with: Date.current
      fill_in 'Data de fim da campanha', with: 10.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'Comissão máxima', with: 100

      expect(page).to have_contente "#{Date.current} #{10.days.from_now} 10% R$ 100,00"
    end
    it 'sem sucesso' do

    end
  end
  context 'não estando logado' do
    it 'e não consegue acessar a página' do

    end
  end
end