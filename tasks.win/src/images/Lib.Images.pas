unit Lib.Images;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, dxGDIPlusClasses, Vcl.Imaging.pngimage;

type
  TAppLibImages = class
  public
    class function Image(const AIndex: integer): TGraphic;
  end;

  TfrmLibImages = class(TForm)
    img003_: TImage;
    img002: TImage;
    img001: TImage;
    img003: TImage;
    img2_old: TImage;
  private
    { Private declarations }
    function GetImage(index: integer): TGraphic;
  public
    { Public declarations }
    property Image[index: integer]: TGraphic read GetImage;
  end;

var
  frmLibImages: TfrmLibImages;

implementation

{$R *.dfm}

{ TAppLibImages }

class function TAppLibImages.Image(const AIndex: integer): TGraphic;
begin
  frmLibImages := TfrmLibImages.Create(nil);
  try
    Result := frmLibImages.Image[AIndex];
  finally
    FreeAndNil(frmLibImages);
  end;
end;

{ TfrmLibImages }

function TfrmLibImages.GetImage(index: integer): TGraphic;
var
  lName: string;
  lCtrl: TComponent;

begin
  lName := Format('img%.3d', [index]);
  lCtrl := FindComponent(lName);

  if not Assigned(lCtrl) then
    Exit(nil)
  else
  begin
    Result := TBitmap.Create;

    TBitmap(Result).PixelFormat := pf32bit;
    Result.SetSize(TImage(lCtrl).Width, TImage(lCtrl).Height);
    Result.Assign(TImage(lCtrl).Picture.Graphic);
  end;
end;

end.
