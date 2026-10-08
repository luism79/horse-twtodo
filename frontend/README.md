# Frontend Web

Aplicação web para gerenciamento de tarefas, desenvolvida em Angular e integrada à API do projeto.

## Funcionalidades

- autenticação de usuários
- dashboard com totais por status e tarefas recentes
- listagem de tarefas com busca, filtros por status e prioridade e paginação
- visualização, criação, edição e exclusão de tarefas
- controle de acesso às páginas autenticadas

## Tecnologias

- Angular standalone
- Angular Material
- TypeScript e SCSS
- API REST com autenticacao por token JWT

## Estrutura principal

- [src/app/features/auth](src/app/features/auth) — tela de login
- [src/app/features/dashboard](src/app/features/dashboard) — resumo das tarefas
- [src/app/features/tasks](src/app/features/tasks) — listagem e gerenciamento de tarefas
- [src/app/layouts](src/app/layouts) — layout das paginas autenticadas
- [src/app/core/guards](src/app/core/guards) — proteção de rotas
- [src/app/core/interceptors](src/app/core/interceptors) — envio do token e tratamento de erros HTTP
- [src/app/core/models](src/app/core/models) — modelos e mapeamento dos dados da API
- [src/app/core/services](src/app/core/services) — autenticação e acesso à API
- [src/environments](src/environments) — configuração por ambiente

As rotas estão definidas em [src/app/app.routes.ts](src/app/app.routes.ts). Login fica disponível em `/login`; dashboard e tarefas exigem autenticação.

## Inicializacao

Instale as dependencias e inicie o servidor de desenvolvimento:

```bash
npm install
npm start
```

A aplicação fica disponível em [http://localhost:4200](http://localhost:4200).

## Comunicacao com a API

As chamadas usam a base `/api`. Durante o desenvolvimento, o proxy configurado em [proxy.conf.json](proxy.conf.json) encaminha essas requisições para `http://localhost:9025`, removendo o prefixo `/api`.

Para usar os fluxos que dependem de dados, mantenha a API backend em execução nesse endereço. A sessão autenticada é armazenada em `sessionStorage`, e o interceptor JWT envia o token nas requisições protegidas.
