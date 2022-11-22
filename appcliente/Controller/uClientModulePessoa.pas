unit uClientModulePessoa;

interface

uses
  System.SysUtils, System.Classes, uClientClassesPessoa, Datasnap.DSClientRest,
  DataSnap.DSProviderDataModuleAdapter,
  Datasnap.DSServer, Datasnap.DSAuth,  FireDAC.Comp.BatchMove.JSON, Data.FireDACJSONReflect,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uModelPessoas, uModelEndereco, FireDAC.Stan.Async,
  FireDAC.DApt, System.Generics.Collections ;

type
  TClientModulePessoa = class(TDataModule)
    DSRestConnection: TDSRestConnection;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
  private
    FInstanceOwner: Boolean;
    FWSPessoasClient: TWSPessoasClient;
    function GetWSPessoasClient: TWSPessoasClient;
    function PreparaTablePessoas(ModelPessoas: TModelPessoas)  : TFDMemTable ;
    function PreparaTableEndereco(ModelPessoas: TModelPessoas) : TFDMemTable ;

    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property WSPessoasClient: TWSPessoasClient read GetWSPessoasClient write FWSPessoasClient;

    function Pessoa(const AID_Pessoa: Integer = 0): TFDObjList  ;
    function AcceptPessoa(ModelPessoas: TModelPessoas): boolean ;
    function UpdatePessoa(ModelPessoas: TModelPessoas): boolean ;
    function CancelPessoa(ModelPessoas: TModelPessoas): boolean ;
    function LotePessoa(_LDataSetList  : TFDJSONDataSets): boolean;

end;

var
  ClientModulePessoa: TClientModulePessoa ;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses uEnumerador;

{$R *.dfm}

constructor TClientModulePessoa.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
end;

destructor TClientModulePessoa.Destroy;
begin
  FWSPessoasClient.Free;
  inherited;
end;

function TClientModulePessoa.GetWSPessoasClient: TWSPessoasClient;
begin
  if FWSPessoasClient = nil then
    FWSPessoasClient:= TWSPessoasClient.Create(DSRestConnection, FInstanceOwner);
  Result := FWSPessoasClient;
end;

function TClientModulePessoa.PreparaTableEndereco(
  ModelPessoas: TModelPessoas): TFDMemTable;
var
  _EnderecoColection : TModelEndereco ;
begin
    Result := TFDMemTable.Create(nil)  ;
    Result.Close ;
      Result.FieldDefs.Add('idendereco' , ftInteger) ;
      Result.FieldDefs.Add('idpessoa'   , ftInteger) ;
      Result.FieldDefs.Add('dscep'      , ftString, 15, false)  ;
    Result.CreateDataset;
    Result.Open  ;

     for _EnderecoColection in ModelPessoas.dscep do
     begin
         Result.InsertRecord([ _EnderecoColection.idendereco,_EnderecoColection.idpessoa,_EnderecoColection.dscep ]) ;
     end;
end;

function TClientModulePessoa.PreparaTablePessoas(
  ModelPessoas: TModelPessoas): TFDMemTable;
begin
    Result  := TFDMemTable.Create(nil)  ;
    Result.Close ;
      Result.FieldDefs.Add('idpessoa'    , ftInteger) ;
      Result.FieldDefs.Add('f1natureza'  , ftInteger) ;
      Result.FieldDefs.Add('dsdocumento' , ftString, 20 , false)  ;
      Result.FieldDefs.Add('nmprimeiro'  , ftString, 100, false)  ;
      Result.FieldDefs.Add('nmsegundo'   , ftString, 100, false)  ;
      Result.FieldDefs.Add('dtregistro'  , ftDate)  ;
    Result.CreateDataset;
    Result.Open ;

    Result.InsertRecord([  ModelPessoas.idpessoa    ,
                           ModelPessoas.f1natureza  ,
                           ModelPessoas.dsdocumento ,
                           ModelPessoas.nmprimeiro  ,
                           ModelPessoas.nmsegundo   ,
                           ModelPessoas.dtregistro  ]) ;
end;

function TClientModulePessoa.Pessoa(const AID_Pessoa: Integer): TFDObjList ;
var
  LDataSetList : TFDJSONDataSets  ;
  _MemTableLista : TFDObjList     ;
  _MemTablePessoas: TFDMemTable   ;
  _MemTableEndereco: TFDMemTable  ;
begin
  LDataSetList := WSPessoasClient.Pessoa(AID_Pessoa)  ;
  _MemTablePessoas := TFDMemTable.Create(nil) ;
  _MemTablePessoas.Close ;
  _MemTablePessoas.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0) ) ;

  _MemTableEndereco := TFDMemTable.Create(nil) ;
  _MemTableEndereco.Close ;
  _MemTableEndereco.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 1) ) ;

  _MemTableLista  := TFDObjList.Create    ;
  _MemTableLista.Add(_MemTablePessoas)    ;
  _MemTableLista.Add(_MemTableEndereco)   ;
  Result := _MemTableLista ;
end;

function TClientModulePessoa.UpdatePessoa(ModelPessoas: TModelPessoas) : boolean ;
var
   _LDataSetList      : TFDJSONDataSets ;
begin
  try
    _LDataSetList := TFDJSONDataSets.Create ;
                     TFDJSONDataSetsWriter.ListAdd(_LDataSetList,PreparaTablePessoas(ModelPessoas))  ;
                     TFDJSONDataSetsWriter.ListAdd(_LDataSetList,PreparaTableEndereco(ModelPessoas)) ;
    WSPessoasClient.UpdatePessoa(_LDataSetList) ;
    Result := True ;
  finally

  end;
end;

function TClientModulePessoa.AcceptPessoa(ModelPessoas: TModelPessoas): boolean;
var
   _LDataSetList      : TFDJSONDataSets ;
begin
  try
    _LDataSetList := TFDJSONDataSets.Create ;
                     TFDJSONDataSetsWriter.ListAdd(_LDataSetList,PreparaTablePessoas(ModelPessoas))  ;
                     TFDJSONDataSetsWriter.ListAdd(_LDataSetList,PreparaTableEndereco(ModelPessoas)) ;
    WSPessoasClient.AcceptPessoa(_LDataSetList) ;

    Result := True ;

  finally

  end;
end;

function TClientModulePessoa.CancelPessoa(ModelPessoas: TModelPessoas): boolean;
var
   _LDataSetList      : TFDJSONDataSets ;
begin
  try
    _LDataSetList := TFDJSONDataSets.Create ;
                     TFDJSONDataSetsWriter.ListAdd(_LDataSetList,PreparaTablePessoas(ModelPessoas))  ;
    WSPessoasClient.CancelPessoa(_LDataSetList) ;

    Result := True ;

  finally

  end;
end;

function TClientModulePessoa.LotePessoa(_LDataSetList  : TFDJSONDataSets) : boolean ;
begin
  try
    WSPessoasClient.LotePessoa(_LDataSetList) ;
    Result := True ;
  finally

  end;
end;


end.
