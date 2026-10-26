unit ITask.Repository;

interface

uses
  ICrud.Repository, System.Generics.Collections, Task.Model, Task.DTO;

type
  ITaskRepository = interface(ICrudRepository<TTaskModel>)
//    function Add(const AObj: TTaskModel): string;
    function FindAll(const A: TTaskQueryParamsDTO): TObjectList<TTaskModel>;
//    function FindById(const Id: string): TTaskModel;
//    function Remove(const Id: string): Boolean;
//    function Update(const AObj: TTaskModel): Boolean;
  end;

implementation

end.
