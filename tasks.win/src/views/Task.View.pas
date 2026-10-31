unit Task.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Custom.View, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXPanels,
  crStaticText, IAuth.Service, App.Enums, ITask.Service, Task.Model, System.Generics.Collections,
  Task.Card;

type
  TTaskStatusCounts = record
    Pending: Integer;
    InProgress: Integer;
    Completed: Integer;
    Cancelled: Integer;
    Count: Integer;
  end;

  TActionType = (atSum, atSub);

  TfrmTaskView = class(TfrmCustomView)
    pnlFlters: TPanel;
    pnlTasksTotal: TPanel;
    shpTasksTotal: TShape;
    lblTasksTotal: TLabel;
    lblCountTotal: TLabel;
    pnlTasksPending: TPanel;
    shpTasksPending: TShape;
    lblTasksPending: TLabel;
    lblCountPending: TLabel;
    pnlTasksInProgress: TPanel;
    shpTasksInProgress: TShape;
    lblTasksInProgress: TLabel;
    lblCountInProgress: TLabel;
    pnlTasksCompleted: TPanel;
    shpTasksCompleted: TShape;
    lblTasksCompleted: TLabel;
    lblCountCompleted: TLabel;
    pnlTasksCancelled: TPanel;
    shpTasksCancelled: TShape;
    lblTasksCancelled: TLabel;
    lblCountCancelled: TLabel;
    lblStatus: TLabel;
    cbStatus: TComboBox;
    lblPriority: TLabel;
    cbPriority: TComboBox;
    btnAdd: TcrStaticText;
    btnSearch: TcrStaticText;
    scrlbxTasks: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    FTasksCounts: TTaskStatusCounts;
    FService: ITaskService;
    FListTasks: TObjectDictionary<Integer, TTaskModelCard>;

    procedure AddTask(ATask: TTaskModelCard);
    procedure AddTaskCard(ATask: TTaskModelCard; var ATop: Integer);
    procedure AddItemToCombo(const AItem: string; ACtrl: TCustomComboBox);
    procedure ConfigPanel(APanel: TPanel; AStatus: TTaskStatus); overload;
    procedure ConfigPanel(APanel: TPanel; const ACaption: string; AColor: TColor); overload;
    function GetAuthService: IAuthService;
    procedure InitData;
    procedure LoadStatus;
    procedure LoadPriority;
    procedure OnButtonClickNotify(AButton: TcrStaticText; const ACardIndex: Integer; ATypeForm: TTypeForm);
    procedure OnButtonImageNotify(AButton: TcrStaticText; ATypeForm: TTypeForm);
    procedure RemoveTask(ATask: TTaskModelCard);
    procedure ResetListTasks;
    procedure ResetTaskStatusCounts;
    procedure SetAuthService(const Value: IAuthService);
    procedure SetService(const Value: ITaskService);
    function ShowFormTaskManagement(ATypeForm: TTypeForm; var ATask: TTaskModelCard): Boolean;
    procedure UpdateTask(const ATaskOld, ATask: TTaskModelCard);
    procedure UpdateTaskCounts; overload;
    procedure UpdateTaskCounts(AStatus: TTaskStatus; const AAction: TActionType); overload;
  protected
    procedure Loaded; override;

  public
    { Public declarations }
    destructor Destroy; override;

    property AuthService: IAuthService read GetAuthService;
  end;

var
  frmTaskView: TfrmTaskView;

implementation

uses
  App.Win, App.Utils, App.Consts, Task.Service, Lib.Images, Task.Management, Custom.Exceptions, Task.DTO;

const
  MSG_ERROR_SERVICE = 'Não foi instanciado o serviço de tarefas';
  MSG_ERROR_SERVICE_AUTH = 'Não foi instanciado o serviço de autenticação';

{$R *.dfm}

{ TfrmTaskView }

procedure TfrmTaskView.AddItemToCombo(const AItem: string; ACtrl: TCustomComboBox);
begin
  ACtrl.Items.Add(AItem);
  ACtrl.ItemIndex := Pred(ACtrl.Items.Count);
end;

procedure TfrmTaskView.ConfigPanel(APanel: TPanel; const ACaption: string; AColor: TColor);

  function _labelTitle: TLabel;
  var
    sName: string;
  begin
    sName := StringReplace(APanel.Name, 'pnl', 'lbl', [rfIgnoreCase]);
    Result := TLabel(FindComponent(sName));
  end;

  function _labelCount: TLabel;
  var
    sName: string;
  begin
    sName := StringReplace(APanel.Name, 'pnlTasks', 'lblCount', [rfIgnoreCase]);
    Result := TLabel(FindComponent(sName));
  end;

var
  lLabel: TLabel;
begin
  lLabel := _labelTitle;
  if Assigned(lLabel) then
    lLabel.Caption := ACaption;

  lLabel := _labelCount;
  if Assigned(lLabel) then
    lLabel.Font.Color := AColor;
end;

destructor TfrmTaskView.Destroy;
begin
  ResetTaskStatusCounts;
  FreeAndNil(FListTasks);
  inherited Destroy;
end;

procedure TfrmTaskView.AddTask(ATask: TTaskModelCard);
var
  lTask: TTaskModel;
  lTaskDto: TTaskAddInputDTO;
  lTop: Integer;
begin
  try
    lTask := TTaskModel.Create;
    try
      lTask.Assign(ATask);
      lTaskDto := TAppUtils.ConvertObjectToRecord<TTaskAddInputDTO>(lTask);
    finally
      FreeAndNil(lTask);
    end;

    ATask.UserId := TAppWin.AuthService.UserId;
    ATask.Id := FService.Add(lTaskDto);

    lTop := 0;
    AddTaskCard(ATask, lTop);
  except
    on E: EValidateAuthenticationException do
        Application.MessageBox(PWideChar(E.Message), 'Atenção', MB_ICONWARNING);

    on E: Exception do
      Application.MessageBox(PWideChar(E.Message), 'Falha na inclusão', MB_ICONERROR);
  end;
end;

procedure TfrmTaskView.AddTaskCard(ATask: TTaskModelCard; var ATop: Integer);
begin
  ATask.IndexCard := FTasksCounts.Count;

  TTaskCard.New(scrlbxTasks, ATask, ATop);
  FListTasks.Add(ATask.IndexCard, ATask);
  UpdateTaskCounts(ATask.Status, atSum);
end;

procedure TfrmTaskView.btnAddClick(Sender: TObject);
var
  lTask: TTaskModelCard;
begin
  lTask := TTaskModelCard.Create;
  if not ShowFormTaskManagement(tfAdd, lTask) then
    FreeAndNil(lTask);
end;

procedure TfrmTaskView.btnSearchClick(Sender: TObject);

  procedure _addParamService(AQueryParams: TStrings; ACombo: TComboBox);
  var
    lParamName: string;
  begin
    if ACombo.ItemIndex < Pred(ACombo.Items.Count) then
    begin
      lParamName := StringReplace(ACombo.Name, 'cb', '', [rfIgnoreCase]).ToLower;
      AQueryParams.Values[lParamName] := ACombo.ItemIndex.ToString;
    end;
  end;

  function _queryParams: TStrings;
  begin
    Result := TStringList.Create;

    _addParamService(Result, cbStatus);
    _addParamService(Result, cbPriority);
  end;

var
  lList: TObjectList<TCustomTaskModel>;
  item: TCustomTaskModel;
  lTask: TTaskModelCard;
  lQueryParams: TStrings;
  lTop: Integer;
begin
  ResetTaskStatusCounts;

  lQueryParams := _queryParams;
  try
    try
      lList := FService.FindAll(lQueryParams);
      try

        if Assigned(lList) then
        begin
          lTop := 0;
          for item in lList do
          begin
            lTask := TTaskModelCard.Create;
            lTask.Assign(item);
            AddTaskCard(lTask, lTop);
          end;
        end;
      finally
        lList.Clear;
        FreeAndNil(lList);
      end;
    except
      on E: EValidateAuthenticationException do
        Application.MessageBox(PWideChar(E.Message), 'Atenção', MB_ICONWARNING);

      on E: Exception do
        Application.MessageBox(PWideChar(E.Message), 'Falha na pesquisa', MB_ICONERROR);
    end;
  finally
    FreeAndNil(lQueryParams);
  end;
  UpdateTaskCounts;
end;

procedure TfrmTaskView.ConfigPanel(APanel: TPanel; AStatus: TTaskStatus);
begin
  ConfigPanel(APanel, AStatus.ToString, TaskStatusColor[AStatus]);
end;

procedure TfrmTaskView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmTaskView.FormCreate(Sender: TObject);
begin
  FListTasks := TObjectDictionary<Integer, TTaskModelCard>.Create([doOwnsValues]);
  ResetTaskStatusCounts;
  UpdateTaskCounts;
end;

procedure TfrmTaskView.FormShow(Sender: TObject);
begin
  SetAuthService(TAppWin.AuthService);
end;

function TfrmTaskView.GetAuthService: IAuthService;
begin
  if not Assigned(FService) then
    Exit(nil);

  Result := FService.AuthService;
end;

procedure TfrmTaskView.InitData;
begin
  LoadStatus;
  LoadPriority;

  ConfigPanel(pnlTasksTotal, 'Total', pnlHeader.Font.Color);
  ConfigPanel(pnlTasksPending, tsPending);
  ConfigPanel(pnlTasksInProgress, tsInProgress);
  ConfigPanel(pnlTasksCompleted, tsCompleted);
  ConfigPanel(pnlTasksCancelled, tsCancelled);
end;

procedure TfrmTaskView.Loaded;
begin
  inherited Loaded;
  InitData;
  TTaskCard.OnButtonImageNotify := OnButtonImageNotify;
  TTaskCard.OnButtonClick := OnButtonClickNotify;
end;

procedure TfrmTaskView.LoadPriority;
begin
  TAppUtils.GetPriorityToStringList(TStringList(cbPriority.Items));
  AddItemToCombo('Todas', cbPriority);
end;

procedure TfrmTaskView.LoadStatus;
begin
  TAppUtils.GetStatusToStringList(cbStatus.Items);
  AddItemToCombo('Todos', cbStatus);
end;

procedure TfrmTaskView.OnButtonClickNotify(AButton: TcrStaticText; const ACardIndex: Integer; ATypeForm: TTypeForm);
var
  lTask: TTaskModelCard;
  lResult: Integer;
begin
  if ATypeForm = tfRemove then
  begin
    lResult := Application.MessageBox('Deseja remover esta tarefa?',
      'Remover', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    if lResult <> mrYes then
      Exit;

    TThread.ForceQueue(
      nil,
      procedure
      var
        lTaskRemove: TTaskModelCard;
      begin
        if FListTasks.TryGetValue(ACardIndex, lTaskRemove) then
          RemoveTask(lTaskRemove);
      end
    );
  end
  else
  begin
    lTask := nil;
    if FListTasks.TryGetValue(ACardIndex, lTask) then
      ShowFormTaskManagement(ATypeForm, lTask);
  end;
end;

procedure TfrmTaskView.OnButtonImageNotify(AButton: TcrStaticText; ATypeForm: TTypeForm);
const
  ImageLibIndex: array[TTypeForm] of Integer = (1, -1, 2, 3);

var
  lImg: TGraphic;
begin
  lImg := TAppLibImages.Image(ImageLibIndex[ATypeForm]);
  try
    if Assigned(lImg) then
      AButton.OptionsImage.Glyph.Assign(lImg);
  finally
    FreeAndNil(lImg);
  end;
end;

procedure TfrmTaskView.RemoveTask(ATask: TTaskModelCard);
var
  lCard: TCustomPanel;
begin
  try
    FService.ValidateAuthentication;

    FService.Remove(ATask.Id);

    lCard := ATask.Card;
    try
      UpdateTaskCounts(ATask.Status, atSub);
      FListTasks.Remove(ATask.IndexCard);
      UpdateTaskCounts;
    finally
      FreeAndNil(lCard);
    end;
  except
    on E: EValidateAuthenticationException do
      Application.MessageBox(PWideChar(E.Message), 'Atenção', MB_ICONWARNING);

    on E: Exception do
      Application.MessageBox(PWideChar(E.Message), 'Falha na exclusão', MB_ICONERROR);
  end;
end;

procedure TfrmTaskView.ResetListTasks;
var
  lPanel: TCustomPanel;
  lKey: Integer;
begin
  for lKey in FListTasks.Keys do
  begin
    lPanel := FListTasks.Items[lKey].Card;
    FreeAndNil(lPanel);
  end;
  FListTasks.Clear;
end;

procedure TfrmTaskView.ResetTaskStatusCounts;
begin
  ResetListTasks;
  FTasksCounts := Default(TTaskStatusCounts);
end;

procedure TfrmTaskView.SetAuthService(const Value: IAuthService);
begin
  if not Assigned(Value) then
    raise Exception.Create(MSG_ERROR_SERVICE_AUTH);

  SetService(TTaskService.Create(Value, TAppWin.Params));

  if Assigned(AuthService) then
    lblHeaderTitle.Caption := Format('Bem-vindo - [%s]', [AuthService.LoggedEmail]);
end;

procedure TfrmTaskView.SetService(const Value: ITaskService);
begin
  if not Assigned(Value) then
    raise Exception.Create(MSG_ERROR_SERVICE);

  FService := Value;
end;


function TfrmTaskView.ShowFormTaskManagement(ATypeForm: TTypeForm; var ATask: TTaskModelCard): Boolean;
begin
  Result := False;
  try
    if ATypeForm in [tfAdd, tfEdit] then
      FService.ValidateAuthentication;

    frmTaskManagement := TfrmTaskManagement.Create(Self, ATypeForm);
    try
      frmTaskManagement.Task := ATask;
      Result := frmTaskManagement.ShowModal = mrOk;
      if Result then
      begin
        ATask.Assign(frmTaskManagement.Task);
        case ATypeForm of
          tfAdd:
            AddTask(
              ATask
            );

          tfEdit:
            UpdateTask(
              TTaskModelCard(frmTaskManagement.TaskOldValues),
              ATask
            );
        end;
      end;
    finally
      FreeAndNil(frmTaskManagement);
    end;
  except
    on E: EValidateAuthenticationException do
      Application.MessageBox(PWideChar(E.Message), 'Atenção', MB_ICONWARNING);
  end;
end;

procedure TfrmTaskView.UpdateTask(const ATaskOld, ATask: TTaskModelCard);
var
  lTask: TTaskModel;
  lTaskDto: TTaskUptInputDTO;
begin
  try
    FService.ValidateAuthentication;

    lTask := TTaskModel.Create;
    try
      lTask.Assign(ATask);
      lTaskDto := TAppUtils.ConvertObjectToRecord<TTaskUptInputDTO>(lTask);
    finally
      FreeAndNil(lTask);
    end;

    FService.Update(lTaskDto);
    TTaskCard.Update(ATask);
    UpdateTaskCounts(ATaskOld.Status, atSub);
    UpdateTaskCounts(ATask.Status, atSum);
    UpdateTaskCounts;
  except
    on E: EValidateAuthenticationException do
        Application.MessageBox(PWideChar(E.Message), 'Atenção', MB_ICONWARNING);

    on E: Exception do
      Application.MessageBox(PWideChar(E.Message), 'Falha na alteração', MB_ICONERROR);

  end;
end;

procedure TfrmTaskView.UpdateTaskCounts(AStatus: TTaskStatus; const AAction: TActionType);
begin
  if AAction = atSum then
  begin
    case AStatus of
      tsPending:
        Inc(FTasksCounts.Pending);

      tsInProgress:
        Inc(FTasksCounts.InProgress);

      tsCompleted:
        Inc(FTasksCounts.Completed);

      tsCancelled:
        Inc(FTasksCounts.Cancelled);
    end;

    Inc(FTasksCounts.Count);
  end
  else
  begin
    case AStatus of
      tsPending:
        Dec(FTasksCounts.Pending);

      tsInProgress:
        Dec(FTasksCounts.InProgress);

      tsCompleted:
        Dec(FTasksCounts.Completed);

      tsCancelled:
        Dec(FTasksCounts.Cancelled);
    end;
  end;
end;

procedure TfrmTaskView.UpdateTaskCounts;
begin
  lblCountTotal.Caption := FListTasks.Count.ToString;
  lblCountPending.Caption := FTasksCounts.Pending.ToString;
  lblCountInProgress.Caption := FTasksCounts.InProgress.ToString;
  lblCountCompleted.Caption := FTasksCounts.Completed.ToString;
  lblCountCancelled.Caption := FTasksCounts.Cancelled.ToString;
end;

end.
