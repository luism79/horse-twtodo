unit ICustom.Service;

interface

uses
  System.Classes, System.Net.HttpClient;

type
  ICustomService = interface
    ['{41BDEE93-E308-4B87-B362-5DD5A04E65EE}']
    function GetBaseUrl: string;
    function GetHost: string;
    function GetPort: Integer;
    function GetHttp: THTTPClient;

    property Http: THTTPClient read GetHttp;
    property BaseUrl: string read GetBaseUrl;
    property Host: string read GetHost;
    property Port: Integer read GetPort;
  end;

implementation

end.
