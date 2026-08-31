unit ICrud.Repository;

interface

uses
  System.Classes, System.Generics.Collections, Task.DTO;

type
  ICrudRepository<T: class> = interface
    ['{3F0B7C0F-1C38-44B5-85AD-C62A662429C3}']
    function Add(const AObj: T): string;
    function FindAll: TObjectList<T>;
    function FindById(const Id: string): T;
    function Remove(const Id: string): Boolean;
    function Update(const AObj: T): Boolean;
  end;

implementation

end.
