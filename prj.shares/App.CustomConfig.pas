unit App.CustomConfig;

interface

uses
  System.IniFiles;

type
  TCustomConfig =  class(TIniFile)
  private
    procedure AssignError(ASource: TObject);
  protected
    procedure LoadData; virtual; abstract;
    procedure SaveData; virtual; abstract;
  public
    constructor Create(const AFileName: string); virtual;
    destructor Destroy; override;

    procedure Assign(ASource: TObject); virtual;
  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TCustomConfig }

procedure TCustomConfig.Assign(ASource: TObject);
begin
  if not Assigned(ASource) then
    AssignError(ASource);
end;

procedure TCustomConfig.AssignError(ASource: TObject);
const
  MsgError = 'Cannot assign a %s to a %s';

var
  lName: string;
begin
  if Assigned(ASource) then
    lName := ASource.ClassName
  else lName := 'nil';

  raise EConvertError.CreateFmt('Cannot assign a %s to a %s', [lName, ClassName]);
end;

constructor TCustomConfig.Create(const AFileName: string);
begin
  inherited Create(AFileName);
  LoadData;
end;

destructor TCustomConfig.Destroy;
begin
  inherited Destroy;
end;

end.
