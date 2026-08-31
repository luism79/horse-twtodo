unit App.Consts;

interface

uses
  Vcl.Graphics, App.Enums;

const
  TaskStatusColor: array[TTaskStatus] of TColor = ($000B9EF5, $00F16663, $0081B910, $008B7464);

  TaskPriorityColor: array[TTaskPriority] of TColor = ($00A4A399, $00279FEF, $006060E6);
  TaskPriorityHoverColor: array[TTaskPriority] of TColor = ($00B7B6AC, $0040ABF2, $006666E8);
  TaskPriorityFocusedColor: array[TTaskPriority] of TColor = ($0088877D, $001B8BD7,  $003738C4);
  TaskPriorityBorderColor: array[TTaskPriority] of TColor = ($0088877D, $001B8BD7, $003738C4);

implementation

end.
