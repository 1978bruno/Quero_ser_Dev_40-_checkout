# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '12345678', admin: true, active: true)
User.create!(name: 'vendedor', email: 'vendedor@locaweb.com.br', password: '12345678', admin: false, active: true)

Customer.create!(doc_ident: '22200022201')
Customer.create!(doc_ident: '32100022201')
Customer.create!(doc_ident: '42600022201')
Customer.create!(doc_ident: '92220022201')

Order.create!(salesman_id: 1, customer_id: 1, product_plan_name: 'Plano Bronze', product_plan_periodicity: 'Mensal')
Order.create!(salesman_id: 2, customer_id: 2, product_plan_name: 'Plano Prata', product_plan_periodicity: 'Mensal')
Order.create!(salesman_id: 3, customer_id: 3, product_plan_name: 'Plano Ouro', product_plan_periodicity: 'Anual')
Order.create!(salesman_id: 4, customer_id: 4, product_plan_name: 'Plano Platinum', product_plan_periodicity: 'Anual')
