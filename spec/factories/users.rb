FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { 'abc123' }
  end
end
