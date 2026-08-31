unit Custom.Exceptions;

interface

uses
  System.SysUtils, System.Classes;

type
  EValidateAuthenticationException = class(Exception);

  EAPIException = class(Exception)
  private
    FStatusCode: Integer;
  public
    constructor Create(const AMsg: string; AStatusCode: Integer = 0);
    property StatusCode: Integer read FStatusCode;
  end;

implementation

{ EAPIException }

constructor EAPIException.Create(const AMsg: string; AStatusCode: Integer);
begin
  inherited Create(AMsg);
  FStatusCode := AStatusCode;
end;

end.
