require 'rails_helper'

describe 'Administrador edita uma campanha de bonus' do
  it 'sem sucesso' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    BonusCommission.create({ description: 'Bonus Especial', start_date: Date.current,
                             end_date: 2.days.from_now, commission_perc: '5', amount_limit: 100 })

    login_as(admin)
    visit bonus_commissions_path
    within(id: 'Bonus Especial') do
      click_on 'Editar'
    end
    fill_in 'Nome da campanha de bonificação', with: ''
    fill_in 'Data de início', with: ''
    fill_in 'Data fim', with: ''
    fill_in 'Percentual de comissão', with: ''
    fill_in 'Limite de comissão', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Campanha não cadastrada'
    expect(page).to have_content 'Percentual de comissão não pode ficar em branco'
    expect(page).to have_content 'Nome da campanha de bonificação não pode ficar em branco'
    expect(page).to have_content 'Data de início não pode ficar em branco'
    expect(page).to have_content 'Data fim não pode ficar em branco'
    expect(page).to have_content 'Percentual de comissão não pode ficar em branco'
  end
  it 'com sucesso' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    BonusCommission.create({ description: 'Bonus Especial', start_date: Date.current,
                             end_date: 2.days.from_now, commission_perc: '5', amount_limit: 100 })

    login_as(admin)
    visit bonus_commissions_path
    within(id: 'Bonus Especial') do
      click_on 'Editar'
    end
    fill_in 'Nome da campanha de bonificação', with: 'Hospedagem GO'
    fill_in 'Data de início', with: Date.current
    fill_in 'Data fim', with: 10.days.from_now
    fill_in 'Percentual de comissão', with: 10
    fill_in 'Limite de comissão', with: 100
    click_on 'Salvar'

    expect(page).to have_content "Hospedagem GO #{I18n.l(Date.current.to_date)}"
    expect(page).to have_content "#{I18n.l(10.days.from_now.to_date)} 10,00% R$ 100,00"
  end
end
