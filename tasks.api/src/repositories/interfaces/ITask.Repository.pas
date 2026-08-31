unit ITask.Repository;

interface

uses
  ICrud.Repository, System.Generics.Collections, Task.Model, Task.DTO;

type
  ITaskRepository = interface(ICrudRepository<TTaskModel>)
    function FindAll(const A: TTaskQueryParamsDTO): TObjectList<TTaskModel>;
  end;

implementation

end.
