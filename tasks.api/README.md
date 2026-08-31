# Tasks API

Sistema de gestão de usuários e tarefas desenvolvido em Delphi com API REST usando Horse, FireDAC e PostgreSQL.

## Visão geral

A Tasks API expõe endpoints para autenticação, cadastro de usuários e gerenciamento de tarefas, incluindo criação, listagem, atualização e exclusão. A aplicação está organizada em camadas bem definidas para manter a lógica de negócio separada da persistência e da interface HTTP.

A estrutura principal do backend está em [prj_api/tasks.api](../tasks.api), com o bootstrap da aplicação em [prj_api/tasks.api/tasks.api.console.dpr](tasks.api.console.dpr).

## Tecnologias

- Delphi
- Horse
- FireDAC
- PostgreSQL
- JWT
- JSON
- Arquitetura em camadas

## Objetivo

O backend foi criado para:

- autenticar usuários
- registrar novos usuários
- criar, listar, editar e remover tarefas
- proteger endpoints por token JWT
- persistir dados em banco relacional

## Estrutura do projeto

- [src](src) — código principal da API
- [src/routes](src/routes) — registro dos endpoints
- [src/controllers](src/controllers) — manipulação das requisições
- [src/services](src/services) — regras de negócio
- [src/repositories](src/repositories) — acesso ao banco de dados
- [src/models](src/models) — DTOs e modelos
- [src/enums](src/enums) — enums da aplicação
- [src/shared](src/shared) — utilitários e respostas padronizadas

## Arquitetura

O fluxo da API segue o padrão:

1. Requisição HTTP chega no Horse
2. A rota é registrada em [src/AppRoutes.pas](src/AppRoutes.pas)
3. O controller recebe os dados da requisição
4. O service valida a regra de negócio
5. O repository acessa o PostgreSQL
6. A resposta é retornada em JSON padronizado

## Inicialização

O bootstrap da aplicação está em [src/App.Console.pas](src/App.Console.pas). Esse módulo é responsável por:

- abrir a conexão com o banco
- carregar parâmetros da aplicação
- configurar autenticação JWT
- registrar middlewares
- iniciar o servidor HTTP

## Segurança

A API usa autenticação por JWT para proteger acessos sensíveis.

### Rotas públicas

- /
- /auth

### Rotas protegidas

- /users
- /users/:e-mail
- /tasks
- /tasks/:id

## Endpoints principais

### Usuários

#### POST /users
Cria um novo usuário.

Exemplo de payload:

```json
{
  "e-mail": "usuario@email.com",
  "password": "123456"
}
```

#### GET /users/:e-mail
Busca um usuário por e-mail.

### Autenticação

#### POST /auth
Realiza o login e retorna um token JWT válido.

Exemplo de payload:

```json
{
  "e-mail": "usuario@email.com",
  "password": "123456"
}
```

### Tarefas

#### POST /tasks
Cria uma nova tarefa.

Exemplo de payload:

```json
{
  "id_usuario": "uuid-do-usuario",
  "titulo": "Estudar Delphi",
  "descricao": "Revisar a API do projeto",
  "prioridade": 1,
  "status": 0
}
```

#### GET /tasks
Lista as tarefas do usuário autenticado, com filtros opcionais por prioridade e status.

#### GET /tasks/:id
Busca uma tarefa específica pelo identificador.

#### PUT /tasks/:id
Atualiza uma tarefa existente.

#### DELETE /tasks/:id
Exclui uma tarefa.

## Banco de dados

A camada de acesso a dados usa FireDAC com PostgreSQL. Os repositories são responsáveis por executar as consultas, por exemplo:

- [src/repositories/User.Repository.pas](src/repositories/User.Repository.pas)
- [src/repositories/Task.Repository.pas](src/repositories/Task.Repository.pas)

## Modelos e DTOs

Os principais DTOs e modelos do backend estão em:

- [src/models/User.DTO.pas](src/models/User.DTO.pas)
- [src/models/Task.DTO.pas](src/models/Task.DTO.pas)
- [src/models/Auth.DTO.pas](src/models/Auth.DTO.pas)
- [src/enums/App.Enums.pas](src/enums/App.Enums.pas)

Esses arquivos representam a estrutura de entrada, saída e regras de status/prioridade da aplicação.

## Regras de negócio

As regras principais ficam nos services, como:

- validação de obrigatório
- confirmação de existência do usuário
- validação de prioridade e status
- autenticação do token
- verificação de dados antes de gravar ou atualizar uma tarefa

## Observações

O backend é a parte servidor do sistema e representa a lógica central da solução. Ele foi pensado para ser facilmente expandido e mantido, com baixo acoplamento entre camadas e separação clara das responsabilidades.
