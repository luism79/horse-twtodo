create table usuarios(
  id uuid not null default uuidv7(),
  e_mail varchar(150) not null,
  senha varchar(64) not null,
  ativo boolean not null default true,
  data_hora_incluido timestamp not null default now(),
  data_hora_alterado timestamp null,
  data_hora_desativado timestamp null,
  
  constraint pk_usuarios primary key (id)
);

create table tarefas(
  id uuid not null default uuidv7(),
  id_usuario uuid not null,
  titulo varchar(50) null,
  descricao varchar(150) null,
  prioridade int default 0 not null check (prioridade between 0 and 2),
  status int default 0 not null check (status between 0 and 3),
  data_hora_incluido timestamp not null default now(),
  data_hora_alterado timestamp null,
  data_hora_completado timestamp null,
  data_hora_cancelado timestamp null,
  
  constraint pk_tarefas primary key(id),
  constraint fk_tarefas_usuario foreign key(id_usuario)
    references usuarios(id)
);

create index idx_tarefa_usuario on tarefas(id_usuario); 