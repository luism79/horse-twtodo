unit AppRoutes;

interface

type
  TRegistryRoutes = class
  public
    class procedure Registry;
  end;

implementation

uses
  Horse, System.JSON, User.Route, Task.Route, Auth.Route;

{ TRegistryRoutes }

class procedure TRegistryRoutes.Registry;
begin
  THorse.Get('/',
    procedure(Res: THorseResponse)
    begin
      Res.Send<TJSONObject>(
        TJSONObject.Create
          .AddPair(
            'horse version',
            THorse.Version
          )
        );
    end);

  TUserRoute.Registry;
  TAuthRoute.Registry(TUserRoute.Service);
  TTaskRoute.Registry(TUserRoute.Service);
end;

end.
