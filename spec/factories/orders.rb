FactoryBot.define do
  factory :order do
    customer_doc_ident { '9999900001' }
    price { rand(1..99.99).round(2) }
    discount { rand(1..99.99).round(2) }
    payment_mode { nil }
    status { 0 }
    cancel_reason { nil }
    product_group_id { 1 }
    product_group_name { 'Hospedagem de Sites' }
    product_plan_id { 1 }
    product_plan_name { 'Hospedagem Go' }
    product_plan_periodicity_id { 1 }
    product_plan_periodicity { 'Mensal' }
    paid_at { nil }
  end
end
