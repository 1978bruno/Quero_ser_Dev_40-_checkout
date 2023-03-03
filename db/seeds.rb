# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '12345678', admin: true, active: true)
User.create!(name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '87654321')
salesman_one = User.create!(name: 'vendedor', email: 'vendedor@locaweb.com.br', password: '12345678',
                            admin: false, active: true)
salesman_two = User.create!(name: 'vendedor2', email: 'vendedor2@locaweb.com.br', password: '12345678',
                            admin: false, active: true)
salesman_three = User.create!(name: 'André Mota', email: 'joaom@locaweb.com.br', password: '12345678',
                              admin: false, active: true)

order1 = Order.create!(salesman_id: salesman_one.id, customer_doc_ident: '22200022201',
                       product_plan_name: 'Plano Bronze', product_plan_periodicity: 'Mensal', price: 30.00)
order2 = Order.create!(salesman_id: salesman_one.id, customer_doc_ident: '32100022201',
                       product_plan_name: 'Plano Prata', product_plan_periodicity: 'Mensal', price: 50.00)
order3 = Order.create!(salesman_id: salesman_one.id, customer_doc_ident: '42600022201',
                       product_plan_name: 'Plano Ouro', product_plan_periodicity: 'Anual', price: 70.00)
Order.create!(salesman_id: salesman_one.id, customer_doc_ident: '92220022201', product_plan_name: 'Plano Platinum',
              product_plan_periodicity: 'Anual', price: 90.00)
Order.create!(salesman_id: salesman_two.id, customer_doc_ident: '22200022201', product_plan_name: 'Plano Prata',
              product_plan_periodicity: 'Mensal', price: 50.00)
Order.create!(salesman_id: salesman_two.id, customer_doc_ident: '32100022201', product_plan_name: 'Plano Ouro',
              product_plan_periodicity: 'Anual', price: 70.00)

bonus_commission1 = BonusCommission.create!(description: 'programa de incentivos 1', start_date: '2022-01-01',
                                            end_date: '2022-12-31', commission_perc: 3.5, amount_limit: 1000,
                                            active: false)

BlocklistedCustomer.create!(doc_ident: '18422142414', blocklisted_reason: 'Processo judicial em andamento.')

PaidCommission.create!(salesman: salesman_one, paid_at: '2022-01-01', amount: 100.00, order: order1,
                       bonus_commission: bonus_commission1)
PaidCommission.create!(salesman: salesman_two, paid_at: '2022-03-03', amount: 200.00, order: order2,
                       bonus_commission: bonus_commission1)
PaidCommission.create!(salesman: salesman_three, paid_at: '2022-06-06', amount: 300.00, order: order3,
                       bonus_commission: bonus_commission1)
