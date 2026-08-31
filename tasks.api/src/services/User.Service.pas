unit User.Service;

interface

uses
  IUser.Service, IUser.Repository, User.DTO, User.Model;

type
  TUserService = class(TInterfacedObject, IUserService)
  private
    FRepository: IUserRepository;

    function ExistsUser(const AEmail: string): Boolean;
    function User(AInput: TUserDTO): TUserModel;
    procedure Validation(AInput: TUserDTO);
  public
    constructor Create(ARepository: IUserRepository);

    function Add(const AInput: TUserDTO): string;
    function FindByEmail(const AEmail: string): TUserViewDTO;
    function FindById(const AId: string): TUserViewDTO;
    function Login(const AEmail: string): TUserDTO;
  end;

implementation

uses
  System.SysUtils, App.Utils;

{ TUsuarioService }

function TUserService.Add(const AInput: TUserDTO): string;
var
  lUsuario: TUserModel;
begin
  Validation(AInput);

  lUsuario := User(AInput);
  try
    Result := FRepository.Add(lUsuario);
  finally
    FreeAndNil(lUsuario);
  end;
end;

constructor TUserService.Create(ARepository: IUserRepository);
begin
  FRepository := ARepository;
end;

function TUserService.ExistsUser(const AEmail: string): Boolean;
var
  lUsuario: TUserModel;
begin
  lUsuario := FRepository.FindByEmail(AEmail);
  try
    Result := Assigned(lUsuario);
  finally
    FreeAndNil(lUsuario);
  end;  // try
end;

function TUserService.FindByEmail(const AEmail: string): TUserViewDTO;
begin
  Result := TAppUtils.ConvertObjectToRecord<TUserViewDTO>(FRepository.FindByEmail(AEmail));

  if Result.Email.IsEmpty then
    raise Exception.Create('Usuário não foi encontrado');
end;

function TUserService.FindById(const AId: string): TUserViewDTO;
begin
  Result := TAppUtils.ConvertObjectToRecord<TUserViewDTO>(FRepository.FindById(AId));

  if Result.Email.IsEmpty then
    raise Exception.Create('Usuário não foi encontrado');
end;

function TUserService.Login(const AEmail: string): TUserDTO;
var
  lUser: TUserModel;
begin
  lUser := FRepository.FindByEmail(AEmail);
  try
    Result := TAppUtils.ConvertObjectToRecord<TUserDTO>(lUser);
  finally
    FreeAndNil(lUser);
  end;
end;

function TUserService.User(AInput: TUserDTO): TUserModel;
begin
  Result := TUserModel.Create;
  Result.Email := AInput.Email;
  Result.Password := TAppUtils.ConvertTextToHash(AInput.Password);
end;

procedure TUserService.Validation(AInput: TUserDTO);
begin
  if AInput.Email.IsEmpty then
    raise Exception.Create('O E-mail deve ser informado');

  if AInput.Password.IsEmpty then
    raise Exception.Create('A senha deve ser informada');

  if ExistsUser(AInput.Email) then
    raise Exception.Create('Usuário já cadastrado');
end;

end.
