unit IUser.Service;

interface

uses
  System.Generics.Collections, User.DTO;

type
  IUserService = interface
    ['{34D7D00F-8E57-42AE-B2A9-119F4916D392}']
    function Add(const AInput: TUserDTO): string;
    function FindByEmail(const AEmail: string): TUserViewDTO;
    function FindById(const AId: string): TUserViewDTO;
    function Login(const AEmail: string): TUserDTO;
  end;

implementation

end.
