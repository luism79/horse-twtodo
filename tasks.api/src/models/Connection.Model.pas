unit Connection.Model;

interface

type
  TParamsConnection = class
  private
    FHost: string;
    FDatabase: string;
    FUserName: string;
    FPassword: string;
    FPort: integer;
    FDriverName: string;
  public
    constructor Create(const ADriveName: string);

    /// <summary>
    /// Nome do banco de dados a ser conectado
    /// </summary>
    property Database: string read FDatabase write FDatabase;

    /// <summary>
    /// Driver de qual banco de dados a ser conectado
    /// </summary>
    property DriverName: string read FDriverName write FDriverName;

    /// <summary>
    /// Endereço do servidor (padrão: localhost)
    /// </summary>
    property Host: string read FHost write FHost;

    /// <summary>
    /// Senha para autenticação no banco de dados
    /// </summary>
    property Password: string read FPassword write FPassword;

    /// <summary>
    /// Porta de conexão com o servidor (padrão: 5432)
    /// </summary>
    property Port: integer read FPort write FPort;

    /// <summary>
    /// Nome do usuário para autenticar no banco de dados
    /// </summary>
    property UserName: string read FUserName write FUserName;
  end;

implementation

const
  HOST_DEFAULT = 'localhost';
  PORT_DEFAULT = 5432;

{ TConnectionDatabase }

constructor TParamsConnection.Create(const ADriveName: string);
begin
  FHost := HOST_DEFAULT;
  FPort := PORT_DEFAULT;
  FDriverName := ADriveName;
end;

end.
