# Tasks Frontend

Aplicação web para autenticação e gerenciamento de tarefas. O frontend foi desenvolvido em Angular e consome a [Tasks API](../tasks.api/README.md), implementada em Delphi com Horse.

## Funcionalidades

- Autenticação de usuários pela API.
- Dashboard com resumo das tarefas.
- Listagem, criação, edição e exclusão de tarefas.
- Proteção das páginas internas por autenticação.

## Tecnologias

- Angular 22
- TypeScript
- Angular Material e CDK
- RxJS

## Pré-requisitos

- Node.js compatível com Angular 22.
- npm 11.19 ou compatível.
- Tasks API em execução e banco de dados configurado. Consulte a [documentação da API](../tasks.api/README.md).

## Instalação e execução

No diretório `frontend`, instale as dependências e inicie o servidor de desenvolvimento:

```bash
npm install
npm start
```

A aplicação ficará disponível em <http://localhost:4200>.

Durante o desenvolvimento, o proxy configurado em `proxy.conf.json` encaminha as chamadas de `/api` para `http://localhost:9025` e remove o prefixo `/api` antes de enviá-las à API. Inicie a API antes de usar o frontend. Se o servidor Horse estiver em outro endereço ou porta, atualize a propriedade `target` nesse arquivo.

## Comandos disponíveis

| Comando | Descrição |
| --- | --- |
| `npm start` | Inicia o servidor Angular com o proxy da API. |
| `npm run build` | Gera a versão de produção em `dist/`. |
| `npm run watch` | Compila continuamente em configuração de desenvolvimento. |
| `npm test` | Executa os testes. |

## Integração com a API

A URL base usada pelo frontend é `/api`, definida nos arquivos de ambiente em `src/environments/`. O proxy de desenvolvimento direciona esse caminho para o servidor Horse, cujo padrão é `http://localhost:9025`.

O login usa `POST /auth`. Após a autenticação, o token JWT é enviado nas requisições protegidas de tarefas. A API também oferece endpoints para usuários; consulte sua documentação para configuração, banco de dados, payloads e detalhes das rotas.