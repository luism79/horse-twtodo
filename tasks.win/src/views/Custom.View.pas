unit Custom.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, crStaticText, Vcl.StdCtrls;

type
  TfrmCustomView = class(TForm)
    pnlHeader: TPanel;
    pnlBody: TPanel;
    lblHeaderTitle: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCustomView: TfrmCustomView;

implementation

{$R *.dfm}

end.
