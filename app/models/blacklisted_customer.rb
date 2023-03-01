class BlacklistedCustomer < ApplicationRecord
  validates :blacklisted_reason, presence: true
  validates :doc_ident, uniqueness: true
end
