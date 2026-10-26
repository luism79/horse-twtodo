unit IUser.Current;

interface

type
  IUserCurrenct = interface
    ['{4780F692-5C16-401E-9C88-A68391CC5C31}']
    function GetId: string;

    property Id: string read GetId;
  end;

implementation

end.
