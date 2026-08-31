unit Task.Model;

interface

uses
  System.JSON.Serializers, App.Enums;

type
  TTaskModel = class
  private
    [JsonName('id')]
    FId: string;

    [JsonName('id_usuario')]
    FUserId: string;

    [JsonName('titulo')]
    FTitle: string;

    [JsonName('descricao')]
    FDescription: string;

    [JsonName('prioridade')]
    FPriority: TTaskPriority;

    [JsonName('status')]
    FStatus: TTaskStatus;

    [JsonName('data_hora_incluido')]
    FCreatedAt: TDateTime;

    [JsonName('data_hora_alterado')]
    FUpdatedAt: TDateTime;

    [JsonName('data_hora_completado')]
    FCompletedAt: TDateTime;

    [JsonName('data_hora_cancelado')]
    FCancelledAt: TDateTime;

    [JsonName('e_mail_usuario')]
    FUserEmail: string;
  public
    property Id: string read FId write FId;
    property UserId: string read FUserId write FUserId;
    property Title: string read FTitle write FTitle;
    property Description: string read FDescription write FDescription;
    property Priority: TTaskPriority read FPriority write FPriority;
    property Status: TTaskStatus read FStatus write FStatus;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
    property CompletedAt: TDateTime read FCompletedAt write FCompletedAt;
    property CancelledAt: TDateTime read FCancelledAt write FCancelledAt;
    property UserEmail: string read FUserEmail write FUserEmail;
  end;

implementation

end.
