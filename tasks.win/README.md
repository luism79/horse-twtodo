# Tasks Desktop

Interface desktop para gestão de usuários e tarefas, desenvolvida em Delphi com VCL e conectada à API backend.

## Visão geral

O frontend do projeto está em [prj_api/tasks.win](../tasks.win). Ele consome a API REST da aplicação backend e oferece uma interface para:

- login do usuário
- listagem de tarefas
- criação de tarefas
- edição de tarefas
- remoção de tarefas
- filtros por status e prioridade

## Tecnologias

- Delphi
- VCL
- FireDAC
- consumo de API REST
- autenticação por token JWT

## Estrutura principal

- [src](src) — código do cliente desktop
- [src/views](src/views) — telas do sistema
- [src/services](src/services) — serviços de consumo da API
- [src/models](src/models) — estruturas de dados da aplicação
- [src/enums](src/enums) — enums de status e prioridade
- [src/shared](src/shared) — constantes e utilitários

## Inicialização

O projeto principal do frontend é:
- [task.win.dpr](task.win.dpr)

Ao iniciar, a aplicação carrega os parâmetros de conexão e abre a tela de login.

## Tela de login

A tela de login está em [src/views/Login.View.pas](src/views/Login.View.pas). Ela coleta:

- e-mail
- senha

Ao confirmar, a aplicação chama o serviço de autenticação e valida as credenciais antes de acessar o sistema.

## Tela principal

A tela principal está em [src/views/Task.View.pas](src/views/Task.View.pas). Ela oferece:

- painel com total de tarefas
- contagem por status
- filtros por status e prioridade
- lista de cartões de tarefas
- ações para adicionar, editar e remover tarefas

## Gerenciamento de tarefa

A tela de cadastro/edição está em [src/views/Task.Management.pas](src/views/Task.Management.pas). Ela permite:

- definir título
- escrever descrição
- selecionar prioridade
- selecionar status
- vincular a tarefa ao usuário autenticado

## Comunicação com a API

Os serviços que consomem a API ficam em:

- [src/services/Auth.Service.pas](src/services/Auth.Service.pas)
- [src/services/Task.Service.pas](src/services/Task.Service.pas)
- [src/services/Custom.Service.pas](src/services/Custom.Service.pas)

Esses serviços:

- montam a URL da API
- enviam headers
- tratam erros da resposta
- validam autenticação antes de ações sensíveis

## Configuração da API

Os parâmetros da API são carregados em:

- [src/App.APIParams.pas](src/App.APIParams.pas)
- [src/App.Win.pas](src/App.Win.pas)

Esses arquivos definem:

- host
- porta
- timeout de conexão
- timeout de resposta

## Fluxo de uso

1. executa o frontend
2. faz login
3. a sessão do usuário é validada
4. a tela principal carrega as tarefas
5. o usuário pode filtrar, adicionar, editar e remover registros

## Regras da interface

O cliente também protege a experiência do usuário, por exemplo:

- confirmar exclusão antes de remover
- bloquear ações sem autenticação válida
- mostrar mensagem de sessão expirada
- informar falhas de servidor ou dados inválidos

## Observações

Este módulo representa a camada cliente da solução e foi pensado para ser simples, funcional e diretamente conectado com a API backend. O resultado final oferece uma experiência amigável para o gerenciamento de tarefas.
