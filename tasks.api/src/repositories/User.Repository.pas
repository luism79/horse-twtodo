unit User.Repository;

interface

uses
  FireDAC.Comp.Client, System.Generics.Collections, Custom.Repository, IUser.Repository, User.Model,
  Data.DB;

type
  TUserRepository = class(TCustomRepository, IUserRepository)
  private
    function ConvertDataSetToModel(ADataSet: TDataSet): TUserModel;
    function InternalAdd(const AUser: TUserModel): string;
    function InternalFindByEmail(const AEmail: string): TUserModel;
    function InternalFindById(const AId: string): TUserModel;
  public
    constructor Create(AConnection: TFDCustomConnection); override;

    function Add(const AUser: TUserModel): string;
    function FindAll: TObjectList<TUserModel>; virtual;
    function FindByEmail(const AEmail: string): TUserModel;
    function FindById(const Id: string): TUserModel;
    function Remove(const Id: string): Boolean;
    function Update(const AUser: TUserModel): Boolean; virtual;
  end;

implementation

uses
  System.SysUtils, FireDAC.Stan.Param;

const
  USER_SQL_DEFAULT = 'select'#13#10 +
                     ' u.id::varchar id, u.e_mail, u.senha, u.ativo,'#13#10 +
                     '	u.data_hora_incluido,'#13#10 +
                     '	u.data_hora_alterado,'#13#10 +
                     '	u.data_hora_desativado'#13#10 +
                     'from usuarios u'#13#10 +
                     '--<where>'#13#10;


{ TUsuarioRepository }

function TUserRepository.Add(const AUser: TUserModel): string;
begin
  SetConnected;
  try
    Result := InternalAdd(AUser);
  finally
    SetConnected(False);
  end;
end;

function TUserRepository.ConvertDataSetToModel(ADataSet: TDataSet): TUserModel;
begin
  if ADataSet.IsEmpty then
    Exit(nil);

  Result := TUserModel.Create;

  Result.Id := ADataSet.FieldByName('id').AsString.ToLower;
  Result.Email := ADataSet.FieldByName('e_mail').AsString;
  Result.Password := ADataSet.FieldByName('senha').AsString;
  Result.Active := ADataSet.FieldByName('ativo').AsBoolean;
  Result.DateTimeCreated := ADataSet.FieldByName('data_hora_incluido').AsDateTime;
  Result.DateTimeUpdated := ADataSet.FieldByName('data_hora_alterado').AsDateTime;
  Result.DateTimeDeactivated := ADataSet.FieldByName('data_hora_desativado').AsDateTime;
end;

constructor TUserRepository.Create(AConnection: TFDCustomConnection);
begin
  inherited Create(AConnection);
  FSQLDefault := USER_SQL_DEFAULT;
end;

function TUserRepository.FindAll: TObjectList<TUserModel>;
begin
  Result := nil;
end;

function TUserRepository.FindByEmail(const AEmail: string): TUserModel;
begin
  SetConnected;
  try
    Result := InternalFindByEmail(AEmail);
  finally
    SetConnected(False);
  end;
end;

function TUserRepository.FindById(const Id: string): TUserModel;
begin
  SetConnected;
  try
    Result := InternalFindById(Id);
  finally
    SetConnected(False);
  end;
end;

function TUserRepository.InternalAdd(const AUser: TUserModel): string;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Connection;
    lQuery.SQL.Text := 'insert into usuarios'#13#10 +
                       '  (e_mail, senha)'#13#10 +
                       'values'#13#10 +
                       '  (:e_mail, :senha)'#13#10 +
                       'returning id::varchar'#13#10;
    lQuery.ParamByName('e_mail').AsString := AUser.Email;
    lQuery.ParamByName('senha').AsString := AUser.Password;
    lQuery.Open;

    Result := lQuery.Fields[0].AsString.ToLower;
  finally
    FreeAndNil(lQuery);
  end;
end;

function TUserRepository.InternalFindByEmail(
  const AEmail: string): TUserModel;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Connection;
    lQuery.SQL.Text := StringReplace(FSQLDefault,
      '--<where>',
      'where u.ativo and u.e_mail = :e_mail',
      [rfIgnoreCase]
    );

    lQuery.ParamByName('e_mail').AsString := AEmail;
    lQuery.Open;

    Result := ConvertDataSetToModel(lQuery);
  finally
    FreeAndNil(lQuery);
  end;
end;

function TUserRepository.InternalFindById(const AId: string): TUserModel;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Connection;
    lQuery.SQL.Text := StringReplace(FSQLDefault,
      '--<where>',
      'where u.ativo and u.id::varchar = :id',
      [rfIgnoreCase]
    );
    lQuery.ParamByName('id').AsString := AId;
    lQuery.Open;

    Result := ConvertDataSetToModel(lQuery);
  finally
    FreeAndNil(lQuery);
  end;
end;

function TUserRepository.Remove(const Id: string): Boolean;
begin
  SetConnected;
  try
    Result := False;
  finally
    SetConnected(False);
  end;
end;

function TUserRepository.Update(const AUser: TUserModel): Boolean;
begin
  Result := False;
end;

end.
