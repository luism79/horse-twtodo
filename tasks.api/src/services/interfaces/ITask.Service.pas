unit ITask.Service;

interface

uses
  System.Classes, System.Generics.Collections, Task.DTO;

type
  ITaskService = interface
    ['{DC561B9A-D288-4E12-ACA3-BF07E60136F0}']
    function Add(const AInput: TTaskInputDTO): string;
    function FindById(const AId: string): TTaskDTO;
    function FindAll(const AQueryParams: TTaskQueryParamsDTO): TArray<TTaskDTO>;
    function Remove(const AId: string): Boolean;
    function Update(const AId: string; const AInput: TTaskInputDTO): Boolean;
  end;

implementation

end.
