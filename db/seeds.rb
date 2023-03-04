# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '12345678', admin: true, active: true)
User.create!(name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '87654321')
selesman_one = User.create!(name: 'vendedor', email: 'vendedor@locaweb.com.br', password: '12345678',
                            admin: false, active: true)
selesman_two = User.create!(name: 'vendedor2', email: 'vendedor2@locaweb.com.br', password: '12345678',
                            admin: false, active: true)

Order.create!(salesman_id: selesman_one.id, customer_doc_ident: '22200022201', product_plan_name: 'Plano Bronze',
              product_plan_periodicity: 'Mensal', price: 30.00)
Order.create!(salesman_id: selesman_one.id, customer_doc_ident: '32100022201', product_plan_name: 'Plano Prata',
              product_plan_periodicity: 'Mensal', price: 50.00)
Order.create!(salesman_id: selesman_one.id, customer_doc_ident: '42600022201', product_plan_name: 'Plano Ouro',
              product_plan_periodicity: 'Anual', price: 70.00)
Order.create!(salesman_id: selesman_one.id, customer_doc_ident: '92220022201', product_plan_name: 'Plano Platinum',
              product_plan_periodicity: 'Anual', price: 90.00)
Order.create!(salesman_id: selesman_two.id, customer_doc_ident: '22200022201', product_plan_name: 'Plano Prata',
              product_plan_periodicity: 'Mensal', price: 50.00)
Order.create!(salesman_id: selesman_two.id, customer_doc_ident: '32100022201', product_plan_name: 'Plano Ouro',
              product_plan_periodicity: 'Anual', price: 70.00)

BlocklistedCustomer.create!(doc_ident: '18422142414', blocklisted_reason: 'Processo judicial em andamento.')

BonusCommission.create({ description: 'Bonus Especial', start_date: '2023-03-01',
                         end_date: '2023-03-05', commission_perc: '5', amount_limit: 100 })
