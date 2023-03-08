User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '12345678', admin: true)
salesman1 = User.create!(name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
salesman2 = User.create!(name: 'Antônio Souza', email: 'asouza@locaweb.com.br', password: '12345678')
salesman3 = User.create!(name: 'Maria do Rosário', email: 'mrosario@locaweb.com.br', password: '12345678')

customers = %w[66496875294 73787269231 98208142433]
statuses = [0, 3, 5]

salesmen = [salesman1, salesman2, salesman3]
products = [['Hospedagem de Sites', 1], ['Email Locaweb', 2], ['Criador de Sites', 3]]
plans = [[['Hospedagem GO', 1], ['Hospedagem I', 2], ['Hospedagem II', 3]],
         [['Initial 25', 4], ['Initial 50', 5], ['Initial 100', 6]],
         [['Básico', 7], ['Intermediário', 8], ['Avançado', 9]]]
prices = [[['Mensal', 1, 50], ['Trimestral', 2, 40], ['Anual', 3, 30]],
          [['Mensal', 4, 55], ['Trimestral', 5, 45], ['Anual', 6, 35]],
          [['Mensal', 7, 60], ['Trimestral', 8, 65], ['Anual', 9, 70]]]

# rubocop:disable Metrics/BlockLength
(Time.zone.today.at_beginning_of_month..Date.current).each do |date|
  rand(30).times do
    salesmen_idx = rand(3)
    c = rand(3)
    prod = rand(3)
    plan = rand(3)
    price = rand(3)
    st = rand(3)

    t = Time.zone.now
    dt = DateTime.new(date.year, date.month, date.day, t.hour, t.min, t.sec, t.zone)

    o = Order.new(salesman_id: salesmen[s].id, customer_doc_ident: customers[c],
                  product_group_id: products[prod][1], product_group_name: products[prod][0],
                  product_plan_id: plans[prod][plan][1], product_plan_name: plans[prod][plan][0],
                  product_plan_periodicity_id: prices[prod][price][1],
                  product_plan_periodicity: prices[prod][price][0], price: prices[prod][price][2],
                  status: statuses[st])
    o.created_at = dt

    if o.paid?
      o.paid_at = o.created_at + 1.day
    elsif o.cancelled?
      o.cancel_reason = 'Motivo cancelamento'
    end

    next if o.save

    o.errors.each do |msg|
      Rails.logger.info "  Error save order: #{msg.full_message}"
    end
  end
end
# rubocop:enable Metrics/BlockLength

Rails.logger.info "Order samples created: #{Order.count}"

BlocklistedCustomer.create!(doc_ident: '18422142414', blocklisted_reason: 'Processo judicial em andamento.')

BonusCommission.create({ description: 'Bonus Especial', start_date: '2023-03-01',
                         end_date: '2023-03-05', commission_perc: '5', amount_limit: 100 })
