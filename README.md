# README

## Database diagram:
<img src="./documents/db.png">

<br />

## Instalação:
  - bin/setup
  - yarn install
  - yarn build


## Pré-populando o DB (Seeds):
  - Após instalação rodar `rails db:seed` para pré-popular o db.

## Testes:
  - RSpec
    ```bash
    bundler exec rspec
    ```
    
## Executando a aplicação pela primeira vez (Modo desenvolvedor):
  - Execute o comando `bin/dev`
  - Login: admin@locaweb.com.br | Senha: 12345678

<br>

## API - Endpoints:
<br>

### **Lista de pedidos pendentes**
#### `GET` http://localhost:3000/api/v1/customers/{doc_cliente}/orders


#### **Parâmetros**

- Content-Type: `application/json`
- Passar o documento do cliente como parâmetro na URL

#### **Respostas**

*Sucesso:*

- Código `200`
``` sh
[
	{
		"id": 1,
		"price": "30.0",
		"discount": null,
		"payment_mode": null,
		"status": "pending",
		"cancel_reason": null,
		"order_code": "9qeZ77Gih8",
		"product_plan_name": "Plano Bronze",
		"product_plan_periodicity": "Mensal",
		"customer_doc_ident": "22200022201",
		"salesman": {
			"id": 3,
			"email": "vendedor@locaweb.com.br",
			"name": "vendedor"
		}
	},
	{
		"id": 5,
		"price": "50.0",
		"discount": null,
		"payment_mode": null,
		"status": "pending",
		"cancel_reason": null,
		"order_code": "4a2TyFq505",
		"product_plan_name": "Plano Prata",
		"product_plan_periodicity": "Mensal",
		"customer_doc_ident": "22200022201",
		"salesman": {
			"id": 4,
			"email": "vendedor2@locaweb.com.br",
			"name": "vendedor2"
		}
	}
]
```

*Caso não sejam encontrados pedidos*

- Código: `404`

```sh
{
  "response": "Nenhum registro encontrado"
}
```
*Caso exista um erro interno da api*

- Código: `500`

```sh
{
  "error": "Ocorreu um erro interno"
}
```
