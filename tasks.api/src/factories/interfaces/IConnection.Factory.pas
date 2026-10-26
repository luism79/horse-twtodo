unit IConnection.Factory;

interface

uses
  FireDAC.Comp.Client;

type
  IConnectionFactory = interface
    ['{49E8C428-A30D-4880-97CC-C9ACF79A0678}']
    function GetConnection: TFDCustomConnection;

    property Connection: TFDCustomConnection read GetConnection;
  end;

implementation

end.
