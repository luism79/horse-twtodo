unit IUser.Repository;

interface

uses
  ICrud.Repository, User.Model;

type
  IUserRepository = interface(ICrudRepository<TUserModel>)
    ['{B9DCE7A1-B732-4992-BC2C-982DF8AC18E6}']
    function FindByEmail(const AEmail: string): TUserModel;
  end;

implementation

end.
