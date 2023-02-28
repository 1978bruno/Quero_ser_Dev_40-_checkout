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
#### `POST` http://localhost:3000/api/v1/orders/list_by_doc


#### **Parâmetros**

- Content-Type: `application/json`

- Body (obrigatório)

```sh
{
  "doc_ident": "22200022201"
}
```
#### **Respostas**

*Sucesso:*

- Código `200`
``` sh
[
  {
	"id": 7,
	"customer_id": 1,
	"price": "30.0",
	"discount": null,
	"payment_mode": null,
	"status": "pending",
	"cancel_reason": null,
	"salesman_id": 1,
	"order_code": "order_C8lg2dJv60",
	"product_plan_name": "Plano Bronze",
	"product_plan_periodicity": "Mensal"
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
*Caso não seja enviado um documento no corpo da requisição*

- Código: `404`

```sh
{
  "error": "Documento do cliente não informado"
}
```
