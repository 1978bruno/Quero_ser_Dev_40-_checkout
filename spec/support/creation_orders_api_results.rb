def url_api_customer(customer_identification)
  "#{Rails.configuration.external_apis['customer_api_url']}/#{customer_identification}"
end

def url_api_products
  "#{Rails.configuration.external_apis['products_api_url']}/product_groups"
end

def url_api_product_plans(product_group_id)
  "#{Rails.configuration.external_apis['products_api_url']}/product_groups/#{product_group_id}/plans"
end

def url_api_product_prices(product_plan_id)
  "#{Rails.configuration.external_apis['products_api_url']}/plans/#{product_plan_id}/prices"
end

def api_result_customer
  { status: 200,
    body: JSON.generate({ doc_ident: '87591438786', name: 'José da Silva',
                          email: 'jose.silva@email.com.br', address: 'Rua Principal, 100',
                          city: 'São Paulo', state: 'SP', zipcode: '11111-111', phone: '11-99999-8888',
                          birthdate: '1980-01-01', corporate_name: '' }) }
end

def api_result_customer_cnpj
  { status: 200,
    body: JSON.generate({ doc_ident: '36358603000107', name: 'Acme Ltda',
                          email: 'contato@acme.com.br', address: 'Rua Principal, 100',
                          city: 'São Paulo', state: 'SP', zipcode: '11111-111', phone: '11-99999-8888',
                          birthdate: '', corporate_name: 'Acme Ltda' }) }
end

def api_result_products
  { status: 200,
    body: JSON.generate(
      [{ id: 1, name: 'Hospedagem de Sites',
         description: 'Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício' },
       { id: 2, name: 'Email Locaweb',
         description: 'Tenha um e-mail profissional e passe mais credibilidade' },
       { id: 3, name: 'Criador de Sites',
         description: 'Crie um site incrível com e-mails e domínio grátis!' }]
    ) }
end

def api_result_plans
  { status: 200,
    body: JSON.generate(
      [{ id: 1, name: 'Hospedagem GO', description: '1 Site, 3 Contas de e-mails(10GB cada)',
         details: '1 usuário FTP' },
       { id: 2, name: 'Hospedagem I', description: 'Sites ilimitados, 25 Contas de e-mails(10GB cada)',
         details: '1 usuário FTP' },
       { id: 3, name: 'Hospedagem II', description: 'Sites ilimitados, 50 Contas de e-mails(10GB cada)s',
         details: '1 usuário FTP' }]
    ) }
end

def api_result_prices
  { status: 200,
    body: JSON.generate(
      [{ price: '80.97', plan: { name: 'Hospedagem II' }, periodicity: { name: 'Trimestral' } },
       { price: '60.97', plan: { name: 'Hospedagem II' }, periodicity: { name: 'Semestral' } }]
    ) }
end

def api_result_failed
  { status: 500, body: {} }
end
