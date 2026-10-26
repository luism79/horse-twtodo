unit App.Enums;

interface

type
  TTaskStatus = (tsPending, tsInProgress, tsCompleted, tsCancelled);
  TTaskPriority = (tpLow, tpMedium, tpHigh);

  TTaskStatusHelper = record helper for TTaskStatus
  public
    function ToInteger: Integer;
    function ToString: string;
  end;

  TTaskPriorityHelper = record helper for TTaskPriority
  public
    function ToInteger: Integer;
    function ToString: string;
  end;

implementation

{ TTaskStatusHelper }

function TTaskStatusHelper.ToInteger: Integer;
begin
  Result := Ord(Self);
end;

function TTaskStatusHelper.ToString: string;
const
  StatusLabel: array[TTaskStatus] of string = ('Pendente', 'Em progresso', 'Concluído', 'Cancelado');
begin
  Result := StatusLabel[Self];
end;

{ TTaskPriorityHelper }

function TTaskPriorityHelper.ToInteger: Integer;
begin
  Result := Ord(Self);
end;

function TTaskPriorityHelper.ToString: string;
const
  PriorityLabel: array[TTaskPriority] of string = ('Baixa', 'Média', 'Alta');
begin
  Result := PriorityLabel[Self];
end;

end.
