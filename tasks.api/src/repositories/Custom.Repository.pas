unit Custom.Repository;

interface

uses
  FireDAC.Comp.Client, IConnection.Factory;

type
  TCustomRepository = class(TInterfacedObject)
  private
    function GetConnection: TFDCustomConnection;
  protected
    FSQLDefault: string;
    FConnectionFactory: IConnectionFactory;

  public
    constructor Create(AConnectionFactory: IConnectionFactory); virtual;

    property Connection: TFDCustomConnection read GetConnection;
  end;

implementation

uses
  System.SysUtils;

{ TCustomRepository }

constructor TCustomRepository.Create(AConnectionFactory: IConnectionFactory);
begin
  FConnectionFactory := AConnectionFactory;
end;

function TCustomRepository.GetConnection: TFDCustomConnection;
begin
  Result := FConnectionFactory.Connection;
end;

end.
