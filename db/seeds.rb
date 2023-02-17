# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '12345678', admin: true, active: true)
seller = User.create!(name: 'vendedor', email: 'vendedor@locaweb.com.br', password: '12345678',
                      admin: false, active: true)

customer_one = Customer.create!(doc_ident: '22200022201')
customer_two = Customer.create!(doc_ident: '32100022201')
customer_three = Customer.create!(doc_ident: '42600022201')
customer_four = Customer.create!(doc_ident: '92220022201')

Order.create!(salesman_id: seller.id, customer_id: customer_one.id, product_plan_name: 'Plano Bronze',
              product_plan_periodicity: 'Mensal', price: 30.00)
Order.create!(salesman_id: seller.id, customer_id: customer_two.id, product_plan_name: 'Plano Prata',
              product_plan_periodicity: 'Mensal',  price: 50.00)
Order.create!(salesman_id: seller.id, customer_id: customer_three.id, product_plan_name: 'Plano Ouro',
              product_plan_periodicity: 'Anual',  price: 70.00)
Order.create!(salesman_id: seller.id, customer_id: customer_four.id, product_plan_name: 'Plano Platinum',
              product_plan_periodicity: 'Anual', price: 90.00)
