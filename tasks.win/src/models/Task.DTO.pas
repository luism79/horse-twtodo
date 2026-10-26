unit Task.DTO;

interface

uses
  System.JSON.Serializers;

type
  TTaskAddInputDTO = record
    [JSONName('titulo')]
    Title: string;

    [JSONName('descricao')]
    Description: string;

    [JSONName('prioridade')]
    Priority: Integer;

    [JSONName('status')]
    Status: Integer;
  end;

  TTaskUptInputDTO = record
    [JSONName('id')]
    Id: string;

    [JSONName('titulo')]
    Title: string;

    [JSONName('descricao')]
    Description: string;

    [JSONName('prioridade')]
    Priority: Integer;

    [JSONName('status')]
    Status: Integer;
  end;

implementation

end.
