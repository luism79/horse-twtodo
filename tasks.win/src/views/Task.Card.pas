unit Task.Card;

interface

uses
  System.Classes, Vcl.Controls, Vcl.ExtCtrls, crStaticText, Task.Model, App.Enums;

const
  DEFAULT_CARD_HEIGHT = 40;

type
  TButtonImageNotify = procedure(AButton: TcrStaticText; ATypeForm: TTypeForm) of object;
  TButtonCardClickNotify = procedure(const ACardIndex: Integer; ATypeForm: TTypeForm) of object;

  TTaskCard = class
  private
    class function GetButtonImageNotify: TButtonImageNotify; static;
    class procedure SetButtonImageNotify(const Value: TButtonImageNotify); static;
    class function GetButtonClick: TButtonCardClickNotify; static;
    class procedure SetButtonClick(const Value: TButtonCardClickNotify); static;
    class procedure ClickButtonNotify(ASender: TObject);
  public
    class function New(AOwner: TComponent; ATask: TTaskModelCard; var Top: integer): TCustomPanel;
    class function Update(ATask: TTaskModelCard): Boolean;

    class property OnButtonImageNotify: TButtonImageNotify read GetButtonImageNotify write SetButtonImageNotify;
    class property OnButtonClick: TButtonCardClickNotify read GetButtonClick write SetButtonClick;
  end;

implementation

uses
  System.SysUtils, Vcl.StdCtrls, Vcl.Graphics, System.Types, App.Consts, crSystemTypes,
  crCustomBorderStyle, crCustomPropertyPersistent;

var
  FOwnerCtrl: TComponent;
  FTask: TTaskModelCard;
  FButtonImageNotify: TButtonImageNotify;
  FButtonClickNotify: TButtonCardClickNotify;

procedure SetTask(Value: TTaskModelCard);
begin
  if not Assigned(Value) then
    raise Exception.Create('É obrigatório informar uma Tarefa');

  FTask := Value;
end;

function AddMargins(AControl: TControl; ARect: TRect): TMargins;
begin
  Result := TMargins.Create(AControl);
  Result.SetBounds(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
end;

function NewPanel(AOwner: TComponent): TPanel;
begin
  Result := TPanel.Create(AOwner);
  Result.Parent := TWinControl(AOwner);
  Result.BevelOuter := bvNone;
  Result.StyleElements := [];
  Result.ShowCaption := False;
end;

function AddLabel(AOwner: TComponent): TLabel;
begin
  Result := TLabel.Create(AOwner);
  Result.Parent := TWinControl(AOwner);
  Result.Layout := tlCenter;
end;

function AddButton(AOwner: TComponent): TcrStaticText;
const
  ControlStyleColor: array[0..2] of TColor = ($00F4EEEC, $00D0C2BB, $00E2D8D3);
  ControlStyleBorderColor: array[0..2] of TColor = ($00F4EEEC, $00786860, $00A09088);

  procedure _setButtonStyle(ACtrlStyle: TcrCustomStyleControl; AStyle: Integer);
  begin
    ACtrlStyle.Color := ControlStyleColor[AStyle];
    ACtrlStyle.BorderStyle.Border := cbsSingle;
    ACtrlStyle.BorderStyle.BorderColor := ControlStyleBorderColor[AStyle];
  end;

begin
  Result := TcrStaticText.Create(AOwner);
  Result.Parent := TWinControl(AOwner);
  Result.SetBounds(0, 0, 33, 33);

  Result.Properties.Alignment.Horz := taCenter;
  Result.Properties.Alignment.Vert := taVCenter;
  Result.Properties.ShowCaption := False;
  Result.Properties.FocusRect := True;
  Result.Properties.TabStop := True;

  Result.Style.HotTrack := True;

  _setButtonStyle(Result.Style, 0);
  _setButtonStyle(Result.StyleFocused, 1);
  _setButtonStyle(Result.StyleHotTrack, 2);
end;

procedure AddPanelDateInfo(AOwner: TComponent; ATitle: string; ADateTime: TDateTime;
  AFontStyles: TFontStyles = []);

  function _convertDateTimeToString: string;
  begin
    Result := '';
    if ADateTime > 0 then
      Result := FormatDateTime('dd/mm/yyyy hh:nn', ADateTime);
  end;

var
  lPanel: TPanel;
  lLabel: TLabel;
begin
  lPanel := NewPanel(AOwner);
  lPanel.Align := alLeft;
  lPanel.Width := 170;
  lPanel.StyleElements := [seClient];
  lPanel.AlignWithMargins := True;
  lPanel.Margins.Assign(AddMargins(lPanel, Rect(5, 0, 0, 0)));

  lLabel := AddLabel(lPanel);
  lLabel.Align := alClient;
  lLabel.Font.Style := AFontStyles;
  lLabel.Caption := Format('%s em %s', [ATitle, _convertDateTimeToString])
end;

procedure AddPanelInfo(AOwner: TComponent; ATitle: string; AColor: TColor);
var
  lPanel: TPanel;
  lLabel: TLabel;
  lShape: TShape;
begin
  lPanel := NewPanel(AOwner);
  lPanel.Align := alLeft;
  lPanel.Width := 100;
  lPanel.StyleElements := [seClient];
  lPanel.AlignWithMargins := True;
  lPanel.Margins.Assign(AddMargins(lPanel, Rect(5, 0, 0, 0)));

  lShape := TShape.Create(lPanel);
  lShape.Parent := TWinControl(lPanel);
  lShape.Align := alLeft;
  lShape.Brush.Color := AColor;
  lShape.Width := 10;
  lShape.Shape := stRoundSquare;
  lShape.AlignWithMargins := True;
  lShape.Pen.Style := psClear;
  lShape.Margins.Assign(AddMargins(lShape, Rect(5, 2, 5, 0)));

  lLabel := AddLabel(lPanel);
  lLabel.Align := alClient;
  lLabel.Caption := ATitle;
  lLabel.Font.Color := AColor;
end;

procedure AddPanelActions(AOwner: TComponent);

  procedure _internalAddButton(var ALeft: Integer;
    AButton: TcrStaticText; ATypeForm: TTypeForm; ARect: TRect);
  begin
    AButton.Hint := ATypeForm.ToString;
    AButton.ShowHint := True;
    AButton.Left := ALeft;
    AButton.Align := alLeft;
    AButton.AlignWithMargins := True;
    AButton.Tag := ATypeForm.ToInteger;
    AButton.Margins.Assign(AddMargins(AButton, ARect));
    AButton.OnClick := TTaskCard.ClickButtonNotify;

    if Assigned(FButtonImageNotify) then
      FButtonImageNotify(AButton, ATypeForm);

    Inc(ALeft, AButton.Width + 1);
  end;

var
  lPanel: TPanel;
  lLeft: Integer;
begin
  lLeft := 0;
  lPanel := NewPanel(AOwner);
  lPanel.Width := (5 * 4) + (33 * 3);
  lPanel.Align := alRight;
  lPanel.StyleElements := [seClient];

  _internalAddButton(lLeft, AddButton(lPanel), tfView, Rect(5, 5, 0, 5));
  _internalAddButton(lLeft, AddButton(lPanel), tfEdit, Rect(5, 5, 0, 5));
  _internalAddButton(lLeft, AddButton(lPanel), tfRemove, Rect(5, 5, 5, 5));
end;

procedure AddPanelBody(AOwner: TComponent);

  function _getDateInfo: TDateTime;
  begin
    Result := FTask.UpdatedAt;

    case FTask.Status of
      tsCompleted:
        Result := FTask.CompletedAt;

      tsCancelled:
        Result := FTask.CancelledAt;
    end;
  end;

  function _getTitleDateInfo: string;
  begin
    Result := 'Alterada';

    case FTask.Status of
      tsCompleted:
        Result := 'Concluída';

      tsCancelled:
        Result := 'Cancelada';
    end;
  end;

const
  LabelDateFontStyle: array[Boolean] of TFontStyles = ([], [fsBold]);
  LabelTitleFontStyle: array[Boolean] of TFontStyles = ([fsBold], [fsBold, fsStrikeOut]);
var
  lPanel: TPanel;
  lPanelFooter: TPanel;
  lLabel: TLabel;
begin
  lPanel := NewPanel(AOwner);
  lPanel.Align := alClient;
  lPanel.ParentBackground := True;
  lPanel.StyleElements := [seClient];
  lPanel.Name := Format('pnlCardBody_%d', [FTask.IndexCard]);

  lLabel := AddLabel(lPanel);
  lLabel.Align := alClient;
  lLabel.Font.Size := 10;
  lLabel.Font.Style := LabelTitleFontStyle[FTask.Status = tsCompleted];
  lLabel.AlignWithMargins := True;
  lLabel.Margins.Assign(AddMargins(lLabel, Rect(10,3,3,3)));
  lLabel.Caption := FTask.Title;

  lPanelFooter := NewPanel(lPanel);
  lPanelFooter.Height := 17;
  lPanelFooter.Align := alBottom;
  lPanelFooter.StyleElements := [seClient];


  AddPanelDateInfo(lPanelFooter, _getTitleDateInfo,
    _getDateInfo, LabelDateFontStyle[FTask.Status = tsCompleted]);
  AddPanelDateInfo(lPanelFooter, 'Criada', FTask.CreatedAt);
  AddPanelInfo(lPanelFooter, FTask.Priority.ToString, TaskPriorityColor[FTask.Priority]);
  AddPanelInfo(lPanelFooter, FTask.Status.ToString, TaskStatusColor[FTask.Status]);
end;

function AddShape(AOwner: TComponent; APriority: TTaskPriority): TShape;
begin
  Result := TShape.Create(AOwner.Owner);
  Result.Parent := TWinControl(AOwner);
  Result.Align := alLeft;
  Result.Width := 9;
  Result.Shape := stRoundRect;
  Result.Brush.Color := TaskPriorityColor[APriority];
  Result.Pen.Color := TaskPriorityBorderColor[APriority];
end;

function NewCard(ATop: Integer): TPanel;
begin
  Result := NewPanel(FOwnerCtrl);
  Result.Top := ATop;
  Result.Height := DEFAULT_CARD_HEIGHT;
  Result.AlignWithMargins := True;
  Result.Margins.Assign(AddMargins(Result, Rect(0,0,0,5)));
  Result.Color := clWhite;
  Result.Align := alTop;
  Result.Tag := FTask.IndexCard;
  Result.Name := Format('pnlCard_%d', [FTask.IndexCard]);

  FTask.Card := Result;

  AddShape(Result, FTask.Priority);
  AddPanelBody(Result);
  AddPanelActions(Result);
end;

{ TTaskCard }

class function TTaskCard.GetButtonClick: TButtonCardClickNotify;
begin
  Result := FButtonClickNotify;
end;

class function TTaskCard.GetButtonImageNotify: TButtonImageNotify;
begin
  Result := FButtonImageNotify;
end;

class function TTaskCard.New(AOwner: TComponent; ATask: TTaskModelCard; var Top: integer): TCustomPanel;
begin
  SetTask(ATask);
  FOwnerCtrl := AOwner;
  Result := NewCard(Top);
  Inc(Top, Result.Height + 1);
end;

class procedure TTaskCard.SetButtonClick(const Value: TButtonCardClickNotify);
begin
  FButtonClickNotify := Value;
end;

class procedure TTaskCard.SetButtonImageNotify(const Value: TButtonImageNotify);
begin
  FButtonImageNotify := Value;
end;

class function TTaskCard.Update(ATask: TTaskModelCard): Boolean;
var
  lCtrl: TControl;
  lPanel: TPanel;
  lCtrlName: string;
begin
  SetTask(ATask);

  lPanel := TPanel(ATask.Card);
  lCtrlName := Format('pnlCardBody_%d', [FTask.IndexCard]);

  lCtrl := lPanel.FindChildControl(lCtrlName);
  if Assigned(lCtrl) then
  begin
    FreeAndNil(lCtrl);
    AddPanelBody(lPanel);
  end;

  Result := True;
end;

class procedure TTaskCard.ClickButtonNotify(ASender: TObject);
var
  lButton: TcrStaticText;
begin
  if Assigned(FButtonClickNotify) then
  begin
    lButton := TcrStaticText(ASender);
    FButtonClickNotify(lButton.Owner.Owner.Tag, TTypeForm(lButton.Tag));
  end;
end;

end.
