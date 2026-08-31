unit Custom.Repository;

interface

uses
  FireDAC.Comp.Client;

type
  TCustomRepository = class(TInterfacedObject)
  private
    FConnection: TFDCustomConnection;
  protected
    FSQLDefault: string;

    procedure SetConnected(Active: Boolean = True);
  public
    constructor Create(AConnection: TFDCustomConnection); virtual;

    property Connection: TFDCustomConnection read FConnection;
  end;

implementation

{ TCustomRepository }

constructor TCustomRepository.Create(AConnection: TFDCustomConnection);
begin
  FConnection := AConnection;
end;


procedure TCustomRepository.SetConnected(Active: Boolean);
begin
  FConnection.Connected := Active;
end;

end.
