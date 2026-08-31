unit ITask.Service;

interface

uses
  System.Classes, System.Generics.Collections, ICustom.Service, IAuth.Service, Task.Model;

type
  ITaskService = interface(ICustomService)
    ['{B0D094C8-53EE-4FE7-B8CF-F887B7EDEF08}']

    function Add(ATask: TTaskModel): string;
    function FindAll(AQueryParams: TStrings): TObjectList<TCustomTaskModel>;
    function GetAuthService: IAuthService;
    function Remove(const AId: string): Boolean;
    function Update(ATask: TTaskModel): Boolean;
    procedure ValidateAuthentication;

    property AuthService: IAuthService read GetAuthService;
  end;

implementation

end.
