# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ENV['CUSTOMER_API_URL'] = 'http://localhost:3001/cliente'
