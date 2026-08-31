unit Params.Model;

interface

uses
  System.JSON.Serializers;

type
  TParamsModel = class
  private
    FHost: string;
    FPort: integer;
    FConnectionTimeout: integer;
    FResponseTimeout: integer;
  public
    /// <summary>
    /// Endereço IP ou hostname onde o servidor Horse irá escutar (Ex: 'localhost', '127.0.0.1' ou '0.0.0.0').
    /// </summary>
    property Host: string read FHost write FHost;

    /// <summary>
    /// Porta TCP/IP em que a aplicação Horse ficará disponível para receber requisições HTTP (Ex: 8080, 9000).
    /// </summary>
    property Port: integer read FPort write FPort;

    /// <summary>
    /// Tempo limite de conexão em milissegundos (Ex: 8000 > 8 segundos).
    /// </summary>
    property ConnectionTimeout: integer read FConnectionTimeout write FConnectionTimeout;

    /// <summary>
    /// Tempo limite de resposta em milissegundos (Ex: 15000 > 15 segundos).
    /// </summary>
    property ResponseTimeout: integer read FResponseTimeout write FResponseTimeout;
  end;

implementation

end.
