unit App.Win;

interface

uses
  System.Classes, System.SysUtils, Params.Model, IAuth.Service;

type
  TAppWin = class
  private
    class var FAuthService: IAuthService;
    class function GetDir: string; static;
    class function GetParams: TParamsModel; static;
  public
    class procedure Init;

    class property Dir: string read GetDir;
    class property Params: TParamsModel read GetParams;
    class property AuthService: IAuthService read FAuthService write FAuthService;
  end;

implementation

uses
  App.APIParams;

var
  FParams: TParamsModel;

{ TAppWin }

class function TAppWin.GetDir: string;
begin
  Result := ExtractFileDir(ParamStr(0));
end;

class function TAppWin.GetParams: TParamsModel;
begin
  Result := FParams;
end;

class procedure TAppWin.Init;
begin
  try
    FParams := TAppAPIParams.Params(GetDir);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
