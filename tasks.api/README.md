# Tasks API

API REST para cadastro de usuários, autenticação e gerenciamento de tarefas. O backend foi desenvolvido em Delphi com Horse, FireDAC e PostgreSQL.

## Visão geral

A API permite criar usuários, autenticar com JWT e gerenciar as tarefas do usuário autenticado. As operações HTTP são separadas em rotas e controllers; as regras de negócio ficam nos services e o acesso ao banco nos repositories.

## Tecnologias

- Delphi 10.4 (projeto configurado para Win32 e Win64)
- Horse e middlewares JWT, JSON e logging
- FireDAC com driver PostgreSQL
- PostgreSQL
- JSON

## Estrutura do projeto

- [`tasks.api.console.dpr`](tasks.api.console.dpr) — ponto de entrada do executável.
- [`src/App.Console.pas`](src/App.Console.pas) — carrega configurações, registra middlewares e inicia o servidor.
- [`src/AppRoutes.pas`](src/AppRoutes.pas) — registra as rotas da aplicação.
- [`src/routes`](src/routes) — definição dos endpoints.
- [`src/controllers`](src/controllers) — tratamento das requisições e respostas HTTP.
- [`src/services`](src/services) — autenticação e regras de negócio.
- [`src/repositories`](src/repositories) — persistência em PostgreSQL.
- [`src/factories`](src/factories) — criação de conexões FireDAC.
- [`src/models`](src/models) — modelos e DTOs.
- [`src/middlewares`](src/middlewares) — tratamento das respostas de erro do JWT.
- [`src/shared`](src/shared) — formato de resposta e contexto do usuário autenticado.
- [`../prj.shares`](../prj.shares) — unidades compartilhadas usadas pelo projeto.

## Configuração

Na inicialização, a aplicação lê os arquivos INI no diretório do executável (`ParamStr(0)`). Os arquivos são gravados ao encerrar a aplicação; se ainda não existirem, preencha os valores necessários e reinicie o servidor.

### `configDB.ini`

Configura a conexão PostgreSQL:

```ini
[params]
host=localhost
database=nome_do_banco
user_name=postgres
password=sua_senha
port=5432
drive_name=PG
```

### `horseParams.ini`

Configura a escuta HTTP e a emissão/validação de tokens:

```ini
[params]
host=localhost
port=9025
jwt key=uma_chave_secreta
issuer=Tasks API
audience=Tasks API
token expiration=180
```

`token expiration` é expresso em minutos. Defina valores próprios para a chave JWT e para os dados de conexão; não use credenciais de produção em arquivos versionados.

### Banco de dados

Crie previamente o banco e aplique o script [`../_scripts/script_inicial.sql`](../_scripts/script_inicial.sql), que cria as tabelas `usuarios` e `tarefas` e o índice por usuário.

## Execução

1. Abra [`tasks.api.console.dproj`](tasks.api.console.dproj) no Delphi.
2. Verifique se as dependências Horse/JWT e o driver FireDAC para PostgreSQL estão disponíveis no ambiente.
3. Configure os arquivos INI no diretório do executável conforme a seção anterior.
4. Compile e execute o projeto.

O servidor usa a porta configurada em `horseParams.ini` (padrão `9025`). Ao iniciar, o endereço configurado é exibido no console. A rota `GET /` retorna a versão do Horse.

## Autenticação

`POST /auth` é público. As rotas de usuários também são públicas; as rotas de tarefas exigem um JWT válido, com subject, expiração e audience correspondente à configuração da API.

Envie o token nas chamadas protegidas:

```http
Authorization: Bearer <access_token>
```

### `POST /auth`

Payload:

```json
{
  "e_mail": "usuario@email.com",
  "password": "sua_senha"
}
```

Em caso de sucesso, a resposta inclui `user_id`, `access_token` e `expires_in_minutes`.

## Endpoints

As respostas de sucesso e erro da API usam JSON com `success` e `message`; quando aplicável, os dados são retornados em `data`.

### Usuários

| Método | Rota | Descrição |
| --- | --- | --- |
| `POST` | `/users` | Cadastra um usuário. |
| `GET` | `/users/:e-mail` | Busca usuário pelo e-mail. |

Exemplo para `POST /users`:

```json
{
  "e_mail": "usuario@email.com",
  "password": "sua_senha"
}
```

O cadastro retorna o identificador criado. A senha é convertida em hash pela aplicação antes de ser armazenada.

### Tarefas

Todas as rotas abaixo exigem autenticação. A tarefa pertence ao usuário identificado pelo `subject` do JWT; não envie `id_usuario` no payload.

| Método | Rota | Descrição |
| --- | --- | --- |
| `POST` | `/tasks` | Cria uma tarefa para o usuário autenticado. |
| `GET` | `/tasks` | Lista as tarefas do usuário autenticado. |
| `GET` | `/tasks/:id` | Busca uma tarefa do usuário autenticado pelo identificador. |
| `PUT` | `/tasks/:id` | Atualiza uma tarefa do usuário autenticado. |
| `DELETE` | `/tasks/:id` | Exclui uma tarefa do usuário autenticado. |

Payload para `POST /tasks` e `PUT /tasks/:id`:

```json
{
  "titulo": "Estudar Delphi",
  "descricao": "Revisar a API do projeto",
  "prioridade": 1,
  "status": 0
}
```

Os campos `titulo` e `descricao` são obrigatórios. Os valores aceitos são:

| Campo | Valor | Significado |
| --- | --- | --- |
| `prioridade` | `0` | Baixa |
| `prioridade` | `1` | Média |
| `prioridade` | `2` | Alta |
| `status` | `0` | Pendente |
| `status` | `1` | Em progresso |
| `status` | `2` | Concluído |
| `status` | `3` | Cancelado |

`GET /tasks` aceita filtros opcionais por prioridade e status:

```http
GET /tasks?priority=2&status=0
```

Os filtros são independentes; se omitidos ou não numéricos, não restringem a listagem. Os resultados são ordenados pela data de inclusão decrescente e, em seguida, pela prioridade decrescente.

## Fluxo da aplicação

1. Horse recebe a requisição e aplica os middlewares de JSON, JWT e logging.
2. As rotas encaminham a requisição ao controller correspondente.
3. O service aplica validações e regras de negócio.
4. O repository executa operações parametrizadas no PostgreSQL por meio de uma conexão FireDAC.
5. A API retorna o resultado em JSON.

Nas operações de tarefas, o contexto do usuário é obtido do subject do JWT e usado pelo repository para limitar consultas, atualizações e exclusões às tarefas daquele usuário.
