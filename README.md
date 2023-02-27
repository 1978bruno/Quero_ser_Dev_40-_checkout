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

## API - Endpoints
### `POST` http://localhost:3000/api/v1/orders/list_by_doc

#### Parâmetros
##### Content-Type

``` sh
application/json
```
##### Body (obrigatório)

```sh
{
  "doc_ident": "22200022201"
}
```
#### Respostas
##### Sucesso
##### Code
``` sh
200
```

##### Caso não sejam encontrados pedidos
##### Code
``` sh
200
```

```sh
{
	"response": "Nenhum registro encontrado"
}
```
##### Caso não seja enviado um documento no corpo da requisição
##### Code
``` sh
404
```
```sh
{
	"error": "Documento do cliente não informado"
}
```
