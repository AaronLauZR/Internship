unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, System.Generics.Defaults, System.Math,
  Vcl.Graphics,Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  cxSpinButton, Data.DB, cxStyles, cxGrid,  cxGridDBTableView, cxGridLevel,
  Data.SqlExpr, Datasnap.Provider, Datasnap.DBClient, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, cxDBData, Data.DBXFirebird, Data.FMTBcd, cxClasses,
  cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxTextEdit,
  cxMaskEdit, cxSpinEdit, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Phys.SQLiteVDataSet;


type

  TForm1 = class(TForm)
    Label1: TLabel;
    cxSpinButton1: TcxSpinButton;
    Label2: TLabel;
    Edit1: TEdit;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxGrid1DBTableView1ItemCode: TcxGridDBColumn;
    cxGrid1DBTableView1ConfidenceScore: TcxGridDBColumn;
    cxGrid1DBTableView1CoOccurrenceFrequency: TcxGridDBColumn;
    cxGrid1DBTableView1AvgQty: TcxGridDBColumn;
    cxGrid1DBTableView1Description: TcxGridDBColumn;
    Button1: TButton;
    cxGrid1DBTableView1TotalQty: TcxGridDBColumn;
    procedure cxSpinButton1PropertiesChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxGrid1DBTableView1DataControllerFilterRecord(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var Accept: Boolean);
    procedure cxGrid1DBTableView1ConfidenceScoreGetDisplayText(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: string);
    procedure cxGrid1DBTableView1AvgQtyGetDisplayText(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: string);


  private
    { Private declarations }
    SQLConnection1: TSQLConnection;
    FetchDataQuery: TSQLQuery;
    DataSetProvider: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    DataSource : TDataSource;
    procedure CreateSQLConnection;
    procedure CreateClientDataset;
    procedure CreateQuery(const ItemCode: string);
    procedure CreateDataSetProvider;
    procedure CreateDataSource;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  queryLimit: Integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  SQLConnection1 := TSQLConnection.Create(nil);
  FetchDataQuery := TSQLQuery.Create(nil);
  DataSetProvider := TDataSetProvider.Create(nil);
  ClientDataSet1 := TClientDataSet.Create(nil);
  DataSource := TDataSource.Create(nil);
  CreateSQLConnection;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SQLConnection1.Free;
  FetchDataQuery.Free;
  ClientDataSet1.Free;
  DataSetProvider.Free;
  DataSource.Free;
end;

procedure TForm1.CreateSQLConnection;
begin

  try
    SQLConnection1.DriverName := 'Firebird';
    SQLConnection1.Params.Values['Database'] := 'C:\eStream\SQLAccounting\DB\BOK OPT SDN BHD.FDB';
    SQLConnection1.Params.Values['Password'] := 'masterkey';
    SQLConnection1.Params.Values['UserName'] := 'sysdba';
    SQLConnection1.LoginPrompt := false;
    SQLConnection1.KeepConnection := true;
    SQLConnection1.Connected := True;

  except
    on E: Exception do
    begin
      ShowMessage('Error occurred: ' + E.Message);
    end;
  end;
end;

procedure TForm1.cxGrid1DBTableView1AvgQtyGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
    //Avg Qty = Total Qty / CoOccurence (Average of the quantity that an item is bought tgt with the item with item code “BBSR001” in a single order)
    AText := FormatFloat('0.000', Trunc((ARecord.Values[cxGrid1DBTableView1TotalQty.Index] / ARecord.Values[cxGrid1DBTableView1CoOccurrenceFrequency.Index])*1000)/1000);
end;

procedure TForm1.cxGrid1DBTableView1ConfidenceScoreGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
   //Confidence score = CoOccurence of the item / Total Occurence (Probability of an item is bought tgt with the item user selected (eg. item code “BBSR001”)
   AText := FormatFloat('0.000', Trunc((ARecord.Values[cxGrid1DBTableView1CoOccurrenceFrequency.Index] / Integer(ClientDataSet1.Aggregates[0].Value))*1000)/1000);
end;

procedure TForm1.CreateQuery(const ItemCode: string);
begin

  try
    FetchDataQuery.SQLConnection := SQLConnection1;

    FetchDataQuery.SQL.Text :='''
                               SELECT t2.ITEMCODE AS ItemCode, si2.DESCRIPTION AS Description,
                               SUM(t2.QTY) AS TotalQty, COUNT(*) AS Occurence
                               FROM SL_IVDTL t1
                               JOIN SL_IVDTL t2 ON t1.DOCKEY = t2.DOCKEY AND t1.ITEMCODE <> t2.ITEMCODE
                               JOIN ST_ITEM si2 ON t2.ITEMCODE = si2.CODE
                               WHERE t1.ITEMCODE = :ItemCode
                               Group by ItemCode, Description
                               Order by Occurence DESC;
                               ''';

    FetchDataQuery.ParamByName('ItemCode').AsString := ItemCode;

    FetchDataQuery.Open;

  except

  end;
end;

procedure TForm1.CreateDataSetProvider;
begin

  DataSetProvider.DataSet := FetchDataQuery;
end;

procedure TForm1.CreateClientDataset;
begin
    ClientDataSet1.SetProvider(DataSetProvider);
    ClientDataSet1.Open;
    with ClientDataSet1.Aggregates.Add do
    begin
      Name := 'TotalOccurrence';
      Expression := 'Sum(Occurence)';
      Active := True;
    end;
    ClientDataSet1.AggregatesActive := True;
end;

procedure TForm1.CreateDataSource;
begin

  DataSource.DataSet := ClientDataSet1;
  cxGrid1DBTableView1.DataController.DataSource := DataSource;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  cxGrid1DBTableView1.DataController.RecordCount := 0;
  CreateQuery('BBSR001');
  CreateDataSetProvider;
  CreateClientDataset;
  CreateDataSource;
  cxGrid1DBTableView1.DataController.Filter.Active := false;
  cxGrid1DBTableView1.DataController.Filter.Active := true;

end;

procedure TForm1.cxSpinButton1PropertiesChange(Sender: TObject);
begin
  Edit1.Text := cxSpinButton1.Value;
  queryLimit := StrToIntDef(cxSpinButton1.Value, 0);
  cxGrid1DBTableView1.DataController.Filter.Active := false;
  cxGrid1DBTableView1.DataController.Filter.Active := true;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NumRecords: Integer;
begin
  if Key = VK_RETURN then
  begin
    if TryStrToInt(Edit1.Text, NumRecords) then
    begin
      NumRecords := Max(0, NumRecords);

    end
    else
    begin
      ShowMessage('Please enter a valid number.');
      Edit1.Text := '0';
    end;
    cxSpinButton1.Value := StrtoInt(Edit1.Text);
  end;
end;

procedure TForm1.cxGrid1DBTableView1DataControllerFilterRecord(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var Accept: Boolean);
begin
  if (ARecordIndex <= Round(cxSpinButton1.Value - 1)) then
    Accept := true
  else
    Accept := false;
end;

end.


