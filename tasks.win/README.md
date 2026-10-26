# Tasks Desktop

Aplicativo desktop para visualizar e gerenciar tarefas por meio da API do projeto. A interface é feita em Delphi com VCL; os dados e a autenticação são fornecidos pelo backend, não por um banco local neste módulo.

## Visão geral

O cliente permite:

- autenticar com e-mail e senha;
- consultar tarefas e filtrar por status e prioridade;
- visualizar totais de tarefas por status;
- criar, editar e remover tarefas;
- acompanhar as datas de inclusão, alteração, conclusão e cancelamento exibidas nos cartões e no formulário.

## Tecnologias

- Delphi / RAD Studio e VCL;
- `THTTPClient` e JSON para comunicação com a API REST;
- componentes visuais VCL e DevExpress usados pelos formulários;
- unidades compartilhadas do projeto em `..\prj.shares`.

## Estrutura do projeto

- [task.win.dpr](task.win.dpr) — ponto de entrada e inicialização da aplicação;
- [task.win.dproj](task.win.dproj) — configurações do projeto Delphi;
- [src/views](src/views) — telas de login, tarefas, cadastro/edição e cartões;
- [src/services](src/services) — autenticação, tarefas e comunicação HTTP comum;
- [src/services/interfaces](src/services/interfaces) — contratos dos serviços;
- [src/services/exceptions](src/services/exceptions) — exceções de API e autenticação;
- [src/models](src/models) — modelos e DTOs de login e tarefa;
- [src/enums](src/enums) — status, prioridades e modos de formulário;
- [src/shared](src/shared) — constantes visuais;
- [src/images](src/images) — imagens usadas na interface.

O projeto também referencia as unidades compartilhadas `App.CustomConfig.pas` e `App.Utils.pas` em `..\prj.shares`.

## Inicialização e execução

Abra [task.win.dproj](task.win.dproj) no Delphi/RAD Studio, verifique os componentes e as unidades compartilhadas necessários e compile a configuração e plataforma desejadas. A configuração do projeto tem como plataforma padrão Win64.

Ao iniciar, a aplicação carrega os parâmetros da API, cria o serviço de autenticação, abre a tela principal e solicita o login. Após uma autenticação bem-sucedida, a tela principal consulta as tarefas.

O backend precisa estar em execução e acessível a partir do computador cliente. A aplicação usa HTTP e monta a URL como `http://<host>:<porta>`.

## Configuração da API

Os parâmetros são lidos do arquivo `ParamsWin.ini`, localizado junto ao executável. Na ausência do arquivo ou de valores, são usados estes padrões:

```ini
[params]
host=localhost
port=9025
ConnectionTimeout=8000
ResponseTimeout=15000
```

Os tempos limite são expressos em milissegundos. A configuração é carregada por [src/App.APIParams.pas](src/App.APIParams.pas) e os valores são guardados em [src/models/Params.Model.pas](src/models/Params.Model.pas).

## Autenticação

A tela de login está em [src/views/Login.View.pas](src/views/Login.View.pas). Ela envia e-mail e senha para `POST /auth`. Com a resposta, o serviço mantém em memória o identificador do usuário, o e-mail, o token de acesso e o prazo de validade. As chamadas protegidas enviam o token no cabeçalho `Authorization`, usando o esquema Bearer; ações de tarefas são bloqueadas se a sessão não for válida.

## Tarefas

A tela principal está em [src/views/Task.View.pas](src/views/Task.View.pas). Ela apresenta os totais por status, os cartões das tarefas, filtros por status e prioridade e ações para adicionar, editar e remover registros.

O formulário em [src/views/Task.Management.pas](src/views/Task.Management.pas) permite informar título, descrição, prioridade e status. Título e descrição são obrigatórios. Os status disponíveis são **Pendente**, **Em progresso**, **Concluído** e **Cancelado**; as prioridades são **Baixa**, **Média** e **Alta**.

O serviço em [src/services/Task.Service.pas](src/services/Task.Service.pas) usa as seguintes operações:

| Operação | Endpoint |
|---|---|
| Listar tarefas | `GET /tasks` |
| Criar tarefa | `POST /tasks` |
| Atualizar tarefa | `PUT /tasks/{id}` |
| Remover tarefa | `DELETE /tasks/{id}` |

Na listagem, os filtros opcionais são enviados como parâmetros `status` e `priority`. Os valores usados correspondem aos índices dos enums definidos em [src/enums/App.Enums.pas](src/enums/App.Enums.pas), começando em zero.

## Serviços e modelos

- [src/services/Auth.Service.pas](src/services/Auth.Service.pas) — login, estado da sessão e validade do token;
- [src/services/Task.Service.pas](src/services/Task.Service.pas) — operações de tarefas e envio do token;
- [src/services/Custom.Service.pas](src/services/Custom.Service.pas) — URL base, cliente HTTP, headers, timeout e tratamento de respostas da API;
- [src/models/Task.Model.pas](src/models/Task.Model.pas) e [src/models/Task.DTO.pas](src/models/Task.DTO.pas) — dados de tarefa e formatos enviados à API;
- [src/models/Login.DTO.pas](src/models/Login.DTO.pas) — dados de entrada e resposta de autenticação.

Falhas de comunicação e respostas HTTP inesperadas são apresentadas pela interface. A remoção também solicita confirmação antes de enviar a operação à API.
