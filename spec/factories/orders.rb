FactoryBot.define do
  factory :order do
    customer { nil }
    price { rand(1..99.99).round(2) }
    discount { rand(1..99.99).round(2) }
    payment_mode { nil }
    status { 0 }
    cancel_reason { nil }
    product_plan_name { 'Hospedagem Go' }
    product_plan_periodicity { 'Mensal' }
  end
end
