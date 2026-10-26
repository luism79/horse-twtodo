unit Task.Management;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Custom.View, Vcl.ExtCtrls, Vcl.StdCtrls, crStaticText,
  App.Enums, Task.Model;

type
  TfrmTaskManagement = class(TfrmCustomView)
    lblHeaderSubTitle: TLabel;
    lblTitle: TLabel;
    edtTitle: TEdit;
    lblMsgErrorTitle: TLabel;
    lblDescription: TLabel;
    lblPriority: TLabel;
    cbPriority: TComboBox;
    lblStatus: TLabel;
    cbStatus: TComboBox;
    mmoDescription: TMemo;
    lblCreatedAt: TLabel;
    lblUpdatedAt: TLabel;
    edtCreatedAt: TEdit;
    edtUpdatedAt: TEdit;
    pnlFooter: TPanel;
    btnConfirm: TcrStaticText;
    btnCancel: TcrStaticText;
    lblMsgErrorDescription: TLabel;
    procedure cbStatusClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
  private
    { Private declarations }
    FTypeForm: TTypeForm;
    FTask: TTaskModel;
    FTaskOldValues: TTaskModel;

    procedure AssignToTask;
    procedure ApplyStatusInfoDate(AStatus: TTaskStatus);
    procedure ChangeTaskStatus(const AStatus: TTaskStatus);
    function ConvertDateTimeToString(const ADateTime: TDateTime): string;
    function GetCaptionDateTime(AStatus: TTaskStatus): string;
    function GetDateTimeTask: TDateTime;
    procedure LoadDataTask;
    procedure LoadStatus;
    procedure LoadPriority;
    procedure ResetErrors;
    procedure SetDateTimeToTask(AStatus: TTaskStatus); overload;
    procedure SetEnableControls;
    procedure SetTask(Value: TTaskModel);
    procedure SetTypeForm(const Value: TTypeForm);
    function ValidateTask: Boolean;
  protected
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ATypeForm: TTypeForm = tfView;
      ATask: TTaskModel = nil; APosition: TPosition = poMainFormCenter); reintroduce;

    property TaskOldValues: TTaskModel read FTaskOldValues;
    property Task: TTaskModel read FTask;
    property TypeForm: TTypeForm read FTypeForm;
  end;

var
  frmTaskManagement: TfrmTaskManagement;

implementation

uses
  App.Utils;


const
  DEFAULT_DROP_DOWN_COUNT = 8;

{$R *.dfm}

{ TfrmTaskManagement }

procedure TfrmTaskManagement.ApplyStatusInfoDate(AStatus: TTaskStatus);
begin
  SetDateTimeToTask(AStatus);
  lblUpdatedAt.Caption := GetCaptionDateTime(AStatus);
  edtUpdatedAt.Text := ConvertDateTimeToString(GetDateTimeTask);
end;

procedure TfrmTaskManagement.AssignToTask;
begin
  FTask.Title := edtTitle.Text;
  FTask.Description := mmoDescription.Text;
  FTask.Priority := TTaskPriority(cbPriority.ItemIndex);
  FTask.Status := TTaskStatus(cbStatus.ItemIndex);
end;

procedure TfrmTaskManagement.btnConfirmClick(Sender: TObject);
begin
  ResetErrors;
  if not ValidateTask then
    ActiveControl := edtTitle
  else
  begin
    AssignToTask;
    ModalResult :=  mrOk;
  end;
end;

procedure TfrmTaskManagement.cbStatusClick(Sender: TObject);
begin
  ChangeTaskStatus(TTaskStatus(cbStatus.ItemIndex));
end;

procedure TfrmTaskManagement.ChangeTaskStatus(const AStatus: TTaskStatus);
begin
  FTask.Status := AStatus;
  ApplyStatusInfoDate(AStatus);
end;

function TfrmTaskManagement.ConvertDateTimeToString(const ADateTime: TDateTime): string;
begin
  Result := '';
  if ADateTime > 0 then
    Result := FormatDateTime('dd/mm/yyyy hh:nn', ADateTime);
end;

constructor TfrmTaskManagement.Create(AOwner: TComponent; ATypeForm: TTypeForm;
  ATask: TTaskModel; APosition: TPosition);
begin
  inherited Create(AOwner);

  Position := APosition;
  SetTypeForm(ATypeForm);

  LoadPriority;
  LoadStatus;
  SetTask(ATask);
end;

function TfrmTaskManagement.GetCaptionDateTime(AStatus: TTaskStatus): string;
begin
  Result := 'Data/Hora da alteração';
  case AStatus of
    tsCompleted:
      Result := 'Data/Hora concluído';

    tsCancelled:
      Result := 'Data/Hora cancelado';
  end;
end;

function TfrmTaskManagement.GetDateTimeTask: TDateTime;
begin
  if (FTypeForm in [tfAdd]) and
     (FTask.Status in [tsCompleted, tsCancelled]) then
    Exit(Now);

  Result := FTask.UpdatedAt;
  case FTask.Status of
    tsCompleted:
      Result := FTask.CompletedAt;

    tsCancelled:
      Result := FTask.CancelledAt;
  end;
end;

procedure TfrmTaskManagement.LoadDataTask;
begin
  edtTitle.Text := FTask.Title;
  mmoDescription.Text := FTask.Description;
  edtCreatedAt.Text := ConvertDateTimeToString(FTask.CreatedAt);

  ApplyStatusInfoDate(FTask.Status);

  cbPriority.ItemIndex := FTask.Priority.ToInteger;
  cbStatus.ItemIndex := FTask.Status.ToInteger;
end;

procedure TfrmTaskManagement.Loaded;
begin
  inherited Loaded;
end;

procedure TfrmTaskManagement.LoadPriority;
begin
  TAppUtils.GetPriorityToStringList(TStringList(cbPriority.Items));
  //DropDownCount := DropDownCount > devido a bug do Delphi
  cbPriority.DropDownCount := DEFAULT_DROP_DOWN_COUNT;
end;

procedure TfrmTaskManagement.LoadStatus;
begin
  TAppUtils.GetStatusToStringList(cbStatus.Items);
  //DropDownCount := DropDownCount > devido a bug do Delphi
  cbStatus.DropDownCount := DEFAULT_DROP_DOWN_COUNT;
end;

procedure TfrmTaskManagement.ResetErrors;
begin
  lblMsgErrorTitle.Visible := False;
end;

procedure TfrmTaskManagement.SetDateTimeToTask(AStatus: TTaskStatus);
begin
  FTask.CompletedAt := 0;
  FTask.CancelledAt := 0;

  if FTypeForm = tfEdit then
    FTask.UpdatedAt := Now;

  case AStatus of
    tsCompleted:
      FTask.CompletedAt := Now;

    tsCancelled:
      FTask.CancelledAt := Now;
  end;
end;

procedure TfrmTaskManagement.SetEnableControls;
const
  CtrlStyleColor: array[Boolean] of TColor = (clWindow, $00F4EEEC);

  procedure _setColorInControl(ACtrl: TControl; AEnabled: Boolean);
  begin
    TEdit(ACtrl).Color := CtrlStyleColor[AEnabled];
  end;

var
  I: Integer;
  lCtrl: TControl;
  lEnabled: Boolean;
begin
  for I := 0 to Pred(pnlBody.ControlCount) do
  begin
    lCtrl := pnlBody.Controls[I];
    if Assigned(lCtrl) and (TWinControl(lCtrl).Tag = 0) then
    begin
      lEnabled := FTypeForm in [tfEdit, tfAdd];
      if lCtrl is TCustomCombo then
      begin
        TComboBox(lCtrl).Enabled := lEnabled;
        _setColorInControl(lCtrl, lEnabled);
      end
      else
      begin
        TCustomEdit(lCtrl).ReadOnly := not lEnabled;
        _setColorInControl(lCtrl, not lEnabled);
      end;
    end;
  end;

  btnConfirm.Enabled := FTypeForm in [tfEdit, tfAdd];
end;

procedure TfrmTaskManagement.SetTask(Value: TTaskModel);
begin
  if FTypeForm = tfAdd then
    FTask := TTaskModelCard.Create
  else
  begin
    if not Assigned(Value) then
      raise Exception.Create('Não foi possível carregar a tarefa');

    FTaskOldValues := TTaskModelCard.Create;
    FTaskOldValues.Assign(Value);
    FTask := Value;
  end;
  LoadDataTask;
end;

procedure TfrmTaskManagement.SetTypeForm(const Value: TTypeForm);
const
  HeaderSubTitleLabel: array[TTypeForm] of string = ('Dados da tarefa',
    'Preencha os dados para cadastrar uma nova tarefa',
    'Altere os dados tarefa',
    '');

begin
  FTypeForm := Value;
  SetEnableControls;

  lblHeaderTitle.Caption := Format('%s Tarefa', [FTypeForm.ToString]);
  lblHeaderSubTitle.Caption := HeaderSubTitleLabel[FTypeForm];
end;

function TfrmTaskManagement.ValidateTask: Boolean;
begin
  lblMsgErrorTitle.Visible := Trim(edtTitle.Text).IsEmpty;
  lblMsgErrorDescription.Visible := Trim(mmoDescription.Text).IsEmpty;

  Result := not lblMsgErrorTitle.Visible and
            not lblMsgErrorDescription.Visible;
end;

end.
