unit Task.Model;

interface

uses
  System.JSON.Serializers, Vcl.ExtCtrls, App.Enums;

type
  TCustomTaskModel = class
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

  TTaskModel = class(TCustomTaskModel)
  private
    procedure AssignError(ASource: TObject);
  public
    constructor Create; virtual;

    procedure Assign(ASource: TObject); virtual;
  end;

  TTaskModelCard = class(TTaskModel)
  private
    FCard: TCustomPanel;
    FIndexCard: Integer;

    procedure RemoveCard;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Assign(ASource: TObject); override;

    property Card: TCustomPanel read FCard write FCard;
    property IndexCard: Integer read FIndexCard write FIndexCard;
  end;

implementation

uses
  System.SysUtils;

{ TTaskModel }

procedure TTaskModel.Assign(ASource: TObject);
begin
  if ASource is TCustomTaskModel then
  begin
    FId := TTaskModel(ASource).FId;
    FUserId := TTaskModel(ASource).FUserId;
    FTitle := TTaskModel(ASource).FTitle;
    FDescription := TTaskModel(ASource).FDescription;
    FPriority := TTaskModel(ASource).FPriority;
    FStatus := TTaskModel(ASource).FStatus;
    FCreatedAt := TTaskModel(ASource).FCreatedAt;
    FUpdatedAt := TTaskModel(ASource).FUpdatedAt;
    FCompletedAt := TTaskModel(ASource).FCompletedAt;
    FCancelledAt := TTaskModel(ASource).FCancelledAt;
    FUserEmail := TTaskModel(ASource).FUserEmail;
  end
  else AssignError(ASource);
end;

procedure TTaskModel.AssignError(ASource: TObject);
var
  lSourceName: string;
begin
  if Assigned(ASource) then
    lSourceName := ASource.ClassName
  else lSourceName := 'nil';

  EConvertError.CreateFmt('Cannot assign a %s to a %s', [lSourceName, ClassName]);
end;

constructor TTaskModel.Create;
begin
  FCreatedAt := Now;
end;

{ TTaskModelCard }

procedure TTaskModelCard.Assign(ASource: TObject);
begin
  if ASource is TCustomTaskModel then
  begin
    inherited Assign(ASource);

    if ASource is TTaskModelCard then
    begin
      FCard := TTaskModelCard(ASource).FCard;
      FIndexCard := TTaskModelCard(ASource).FIndexCard;
    end;
  end
  else inherited Assign(ASource);

end;

constructor TTaskModelCard.Create;
begin
  inherited Create;

  FIndexCard := 0;
end;

destructor TTaskModelCard.Destroy;
begin
  RemoveCard;
  inherited Destroy;
end;

procedure TTaskModelCard.RemoveCard;
begin
  if Assigned(FCard) then
    FreeAndNil(FCard);
end;

end.
