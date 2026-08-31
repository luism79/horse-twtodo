unit Task.DTO;

interface

uses
  System.JSON.Serializers;

type
  TTaskDTO = record
    [JsonName('id')]
    Id: string;

    [JsonName('id_usuario')]
    UserId: string;

    [JsonName('titulo')]
    Title: string;

    [JsonName('descricao')]
    Description: string;

    [JsonName('prioridade')]
    Priority: Integer;

    [JsonName('status')]
    Status: Integer;

    [JsonName('data_hora_incluido')]
    CreatedAt: TDateTime;

    [JsonName('data_hora_alterado')]
    UpdatedAt: TDateTime;

    [JsonName('data_hora_completado')]
    CompletedAt: TDateTime;

    [JsonName('data_hora_cancelado')]
    CancelledAt: TDateTime;

    [JsonName('e_mail_usuario')]
    UserEmail: string;
  end;

  TTaskInputDTO = record
    [JSONName('id_usuario')]
    UserId: string;

    [JSONName('titulo')]
    Title: string;

    [JSONName('descricao')]
    Description: string;

    [JSONName('prioridade')]
    Priority: Integer;

    [JSONName('status')]
    Status: Integer;
  end;

  TTaskQueryParamsDTO = record
    [JsonName('id_usuario')]
    UserId: string;

    [JsonName('prioridade')]
    Priority: Integer;

    [JsonName('status')]
    Status: Integer;
  end;

implementation

end.
