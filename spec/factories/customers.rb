FactoryBot.define do
  factory :customer do
    doc_ident { '09122833328' }
    blacklisted { false }
    blacklisted_reason { nil }
  end
end
