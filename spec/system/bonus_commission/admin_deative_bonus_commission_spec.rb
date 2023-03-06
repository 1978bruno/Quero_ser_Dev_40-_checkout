require 'rails_helper'

describe 'Administrador desativa uma campanha de bonus' do
  it 'com sucesso' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    BonusCommission.create({ description: 'Bonus Especial', start_date: Date.current,
                             end_date: 2.days.from_now, commission_perc: '5', amount_limit: 100 })

    login_as(admin)
    visit bonus_commissions_path
    within(id: 'Bonus Especial') do
      click_on 'Desativar'
    end

    expect(page).not_to have_content "Bonus Especial #{I18n.l(Date.current.to_date)}"
    expect(page).not_to have_content "#{I18n.l(2.days.from_now.to_date)} 5,00% R$ 100,00"
  end
end
