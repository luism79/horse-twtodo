unit User.Model;

interface

uses
  System.JSON.Serializers;

type
  TUserModel = class
  private
    [JsonName('id')]
    FId: string;

    [JsonName('e-mail')]
    FEmail: string;

    [JsonName('password')]
    FPassword: string;

    [JsonName('active')]
    FActive: Boolean;

    [JsonName('date-time-created')]
    FDateTimeCreated: TDateTime;

    [JsonName('date-time-updated')]
    FDateTimeUpdated: TDateTime;

    [JsonName('date-time-deactivated')]
    FDateTimeDeactivated: TDateTime;

  public
    constructor Create;

    property Active: Boolean read FActive write FActive default True;
    property DateTimeUpdated: TDateTime read FDateTimeUpdated write FDateTimeUpdated;
    property DateTimeDeactivated: TDateTime read FDateTimeDeactivated write FDateTimeDeactivated;
    property DateTimeCreated: TDateTime read FDateTimeCreated write FDateTimeCreated;
    property Email: string read FEmail write FEmail;
    property Id: string read FId write FId;
    property Password: string read FPassword write FPassword;
  end;

implementation

{ TUserModel }

constructor TUserModel.Create;
begin
  FActive := True;
end;

end.
