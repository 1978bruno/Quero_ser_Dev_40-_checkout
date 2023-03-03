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

<details>
  <summary>
    <b>Lista de pedidos pendentes</b>
  </summary>
  <br>
  <b>Método HTTP / URL</b>

  `GET` http://localhost:3000/api/v1/customers/{doc_client}/orders

  **Parâmetros**

- Content-Type: `application/json`
- Passar o documento do cliente como parâmetro na URL

#### **Respostas**

*- Sucesso:*

- Código `200`

``` sh
[
	{
		"price": "30.0",
		"discount": null,
		"payment_mode": null,
		"status": "pending",
		"order_code": "9qeZ77Gih8",
		"product_plan_name": "Plano Bronze",
		"product_plan_periodicity": "Mensal",
		"customer_doc_ident": "22200022201",
		"salesman": {
			"email": "vendedor@locaweb.com.br",
			"name": "vendedor"
		}
	},
	{
		"price": "50.0",
		"discount": null,
		"payment_mode": null,
		"status": "pending",
		"order_code": "4a2TyFq505",
		"product_plan_name": "Plano Prata",
		"product_plan_periodicity": "Mensal",
		"customer_doc_ident": "22200022201",
		"salesman": {
			"email": "vendedor2@locaweb.com.br",
			"name": "vendedor2"
		}
	}
]
```

*- Caso não sejam encontrados pedidos*

- Código: `404`

```sh
{
  "response": "Nenhum registro encontrado"
}
```
*- Caso exista um erro interno da api*

- Código: `500`

```sh
{
  "error": "Ocorreu um erro interno"
}
```

</details>

<details>
  <summary>
    <b>Altera o status do pedido para pago</b>
  </summary>
  <br>
  <b>Método HTTP / URL</b>

  `POST` http://localhost:3000/api/v1/customers/orders/{order_code}/paid

  **Parâmetros**

- Content-Type: `application/json`
- Passar o código do pedido como parâmetro na URL
- Passar o modo de pagamento e o desconto (se houver) como parâmetro no `BODY` da requisição

``` sh
{
	"payment_mode": "credit_card",
	"discount": "10.99" 
}
```

#### **Respostas**

*- Sucesso:*

- Código `200`

``` sh
{
	"payment_mode": "credit_card",
	"discount": "10.99",
	"status": "paid",
	"price": "30.0",
	"order_code": "9qeZ77Gih8",
	"product_plan_name": "Plano Bronze",
	"product_plan_periodicity": "Mensal",
	"customer_doc_ident": "22200022201",
	"salesman": {
		"email": "vendedor@locaweb.com.br",
		"name": "vendedor"
	}
}
```

*- Caso não sejam encontrados pedidos*

- Código: `404`

```sh
{
  "response": "Nenhum registro encontrado"
}
```

*- Caso não seja enviado o modo de pagamento*

- Código: `404`

``` sh
{
  "error": "Modo de pagamento não informado"
}
```

*- Caso exista um erro interno da api*

- Código: `500`

```sh
{
  "error": "Ocorreu um erro interno"
}
```
</details>


<details>
  <summary>
    <b>Altera o status do pedido para cancelado</b>
  </summary>
  <br>
  <b>Método HTTP / URL</b>

  `POST` http://localhost:3000/api/v1/customers/orders/{order_code}/cancelled

  **Parâmetros**

- Content-Type: `application/json`
- Passar o código do pedido como parâmetro na URL
- Passar o motivo do cancelamento como parâmetro no `BODY` da requisição

``` sh
{
	"cancel_reason": "O cliente desistiu"
}
```

#### **Respostas**

*- Sucesso:*

- Código `200`

``` sh
{
	"status": "cancelled",
	"cancel_reason": "O cliente desistiu",
	"price": "30.0",
	"discount": "10.99",
	"payment_mode": "credit_card",
	"order_code": "9qeZ77Gih8",
	"product_plan_name": "Plano Bronze",
	"product_plan_periodicity": "Mensal",
	"customer_doc_ident": "22200022201",
	"salesman": {
		"email": "vendedor@locaweb.com.br",
		"name": "vendedor"
	}
}
```

*- Caso não sejam encontrados pedidos*

- Código: `404`

```sh
{
  "response": "Nenhum registro encontrado"
}
```

*- Caso não seja enviado o motivo de cancelamento*

- Código: `404`

``` sh
{
	"error": "Motivo do cancelamento não informado"
}
```

*- Caso exista um erro interno da api*

- Código: `500`

```sh
{
  "error": "Ocorreu um erro interno"
}
```
</details>