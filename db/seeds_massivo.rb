user_admin = User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '12345678', admin: true)
salesman1 = User.create!(name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
salesman2 = User.create!(name: 'Antônio Souza', email: 'asouza@locaweb.com.br', password: '12345678')
salesman3 = User.create!(name: 'Maria do Rosário', email: 'mrosario@locaweb.com.br', password: '12345678')

customers = ['66496875294', '73787269231', '98208142433' ]
salesmen = [ salesman1, salesman2, salesman3 ]
products = [ ['Hospedagem de Sites', 1], ['Email Locaweb', 2], ['Criador de Sites', 3] ]
plans = [ [ ['Hospedagem GO', 1], ['Hospedagem I', 2], ['Hospedagem II', 3] ],
          [ ['Initial 25', 4], ['Initial 50', 5], ['Initial 100', 6] ],
		      [ ['Básico', 7], ['Intermediário', 8], ['Avançado', 9] ] ]
prices = [ [ ['Mensal', 1, 50], ['Trimestral', 2, 40], ['Anual', 3, 30] ], 
           [ ['Mensal', 4, 55], ['Trimestral', 5, 45], ['Anual', 6, 35] ],
           [ ['Mensal', 7, 55], ['Trimestral', 8, 45], ['Anual', 9, 35] ] ]

(2.months.ago.to_date..Date.current).each do |date|
  rand(10).times do
    s = rand(3)
    c = rand(3)
    prod = rand(3)
    plan = rand(3)
    price = rand(3)

    puts "Date: #{date} - s=#{s} / c=#{c} / prod=#{prod} / plan=#{plan} / price=#{price}"
	
    t = Time.now
    dt = DateTime.new(date.year, date.month, date.day, t.hour, t.min, t.sec, t.zone)
	
    o = Order.new(salesman_id: salesmen[s].id, customer_doc_ident: customers[c],
                  product_group_id: products[prod][1], product_group_name: products[prod][0],
                  product_plan_id: plans[prod][plan][1], product_plan_name: plans[prod][plan][0],
                  product_plan_periodicity_id: prices[prod][price][1], product_plan_periodicity: prices[prod][price][0], price: prices[prod][price][2])
	  o.created_at = dt
    unless o.save
      o.errors.each do |msg|
        puts "  Error: #{msg.full_message}"
      end
    end
  end
end

BlocklistedCustomer.create!(doc_ident: '18422142414', blocklisted_reason: 'Processo judicial em andamento.')

BonusCommission.create({ description: 'Bonus Especial', start_date: '2023-03-01',
                         end_date: '2023-03-05', commission_perc: '5', amount_limit: 100 })
