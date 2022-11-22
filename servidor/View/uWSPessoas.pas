unit uWSPessoas;

interface

uses System.SysUtils, System.Classes, System.Json, DataSnap.DSProviderDataModuleAdapter,
     Datasnap.DSServer, Datasnap.DSAuth,  FireDAC.Comp.BatchMove.JSON, Data.FireDACJSONReflect,
     FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin, FireDAC.Stan.Intf, FireDAC.DatS,
     FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.Comp.Client,
     FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,uEnumerador ,
     System.Generics.Collections, uControllerIntegracao , uControllerLotePessoas,
  FireDAC.Phys.PGDef, FireDAC.Phys, FireDAC.Phys.PG ;

type
  TWSPessoas = class(TDSServerModule)
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
  private
    procedure PreparaDadosModelPessoas(_MemTablePessoas: TFDMemTable ; _MemTableEndereco: TFDMemTable ; _enuTipo :TEnumerador ) ;

    { Private declarations }
  public
    { Public declarations }

     function Pessoa(const AID_Pessoa: Integer = 0): TFDJSONDataSets     ;
     procedure AcceptPessoa(const LDataSetList : TFDJSONDataSets)        ;
     procedure UpdatePessoa(const LDataSetList : TFDJSONDataSets)        ;
     procedure CancelPessoa(const LDataSetList : TFDJSONDataSets)        ;
     procedure LotePessoa(const LDataSetList: TFDJSONDataSets);

  end;

implementation


{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

uses System.StrUtils, uControllerPessoas, uModelEndereco;


function TWSPessoas.Pessoa(const AID_Pessoa: Integer = 0): TFDJSONDataSets;
var
  controllerPessoas : TControllerPessoas ;
begin
    try
        controllerPessoas := TControllerPessoas.Create;
        controllerPessoas.ModelPessoas.idpessoa  := AID_Pessoa ;
        controllerPessoas.ModelEndereco.idpessoa := AID_Pessoa ;
        Result := controllerPessoas.selecionar ;
    finally
        FreeAndNil(controllerPessoas)   ;
    end;
end;

procedure TWSPessoas.PreparaDadosModelPessoas(_MemTablePessoas: TFDMemTable ; _MemTableEndereco: TFDMemTable ; _enuTipo :TEnumerador );
var
  controllerPessoas    : TControllerPessoas    ;
  ControllerIntegracao : TControllerIntegracao ;
begin
    controllerPessoas := TControllerPessoas.Create ;
    _MemTablePessoas.Open ;

    while not _MemTablePessoas.Eof do
    begin
        with controllerPessoas do
        begin

           ModelPessoas.idpessoa     := _MemTablePessoas.FieldByName('idpessoa').AsInteger     ;
           ModelPessoas.f1natureza   := _MemTablePessoas.FieldByName('f1natureza').AsInteger   ;
           ModelPessoas.dsdocumento  := _MemTablePessoas.FieldByName('dsdocumento').AsString   ;
           ModelPessoas.nmprimeiro   := _MemTablePessoas.FieldByName('nmprimeiro').AsString    ;
           ModelPessoas.nmsegundo    := _MemTablePessoas.FieldByName('nmsegundo').AsString     ;
           ModelPessoas.dtregistro   := _MemTablePessoas.FieldByName('dtregistro').AsDateTime  ;
           ModelPessoas.enuTipo      :=  _enuTipo ;

           if (_MemTableEndereco <> nil) then
           begin
               _MemTableEndereco.Open  ;
               while not _MemTableEndereco.Eof do
               begin
                     ModelPessoas.dscep.Add(TModelEndereco.Create) ;
                      ModelPessoas.dscep[ModelPessoas.dscep.Count-1].idendereco  := _MemTableEndereco.FieldByName('idendereco').AsInteger   ;
                      ModelPessoas.dscep[ModelPessoas.dscep.Count-1].idpessoa    := _MemTableEndereco.FieldByName('idpessoa').AsInteger     ;
                      ModelPessoas.dscep[ModelPessoas.dscep.Count-1].dscep       := _MemTableEndereco.FieldByName('dscep').AsString         ;

                  _MemTableEndereco.Next ;
               end;
           end;

        end;

        _MemTablePessoas.Next ;
    end ;

    controllerPessoas.persistir ;

    ControllerIntegracao := TControllerIntegracao.Create ;
end;


procedure TWSPessoas.UpdatePessoa(const LDataSetList : TFDJSONDataSets) ;
var
   _MemTablePessoas   : TFDMemTable ;
   _MemTableEndereco  : TFDMemTable ;
begin
  try
    _MemTablePessoas  := TFDMemTable.Create(nil)  ;
    _MemTablePessoas.Close ;
    _MemTablePessoas.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0)) ;

    _MemTableEndereco := TFDMemTable.Create(nil)  ;
    _MemTableEndereco.Close ;
    _MemTableEndereco.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 1)) ;

    PreparaDadosModelPessoas( _MemTablePessoas, _MemTableEndereco, tipoIncluir) ;

  finally
    FreeAndNil(_MemTablePessoas)   ;
    FreeAndNil(_MemTableEndereco)  ;
  end;
end;

procedure TWSPessoas.AcceptPessoa(const LDataSetList : TFDJSONDataSets) ;
var
   _MemTablePessoas   : TFDMemTable ;
   _MemTableEndereco  : TFDMemTable ;
begin
  try
    _MemTablePessoas  := TFDMemTable.Create(nil)  ;
    _MemTablePessoas.Close ;
    _MemTablePessoas.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0)) ;

    _MemTableEndereco := TFDMemTable.Create(nil)  ;
    _MemTableEndereco.Close ;
    _MemTableEndereco.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 1)) ;

    PreparaDadosModelPessoas( _MemTablePessoas, _MemTableEndereco, tipoAlterar) ;

  finally
    FreeAndNil(_MemTablePessoas)   ;
    FreeAndNil(_MemTableEndereco)  ;
  end;
end;

procedure TWSPessoas.CancelPessoa(const LDataSetList : TFDJSONDataSets) ;
var
   _MemTablePessoas   : TFDMemTable ;
begin
  try
    _MemTablePessoas  := TFDMemTable.Create(nil)  ;
    _MemTablePessoas.Close ;
    _MemTablePessoas.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0)) ;

    PreparaDadosModelPessoas( _MemTablePessoas, nil, tipoExcluir) ;

  finally
    FreeAndNil(_MemTablePessoas)   ;
  end;
end;

procedure TWSPessoas.LotePessoa(const LDataSetList : TFDJSONDataSets) ;
var
  ControllerLotePessoas : TControllerLotePessoas ;
begin
  try
     ControllerLotePessoas := TControllerLotePessoas.Create     ;
     ControllerLotePessoas.LotePessoasDados := TFDMemTable.Create(nil)  ;
     ControllerLotePessoas.LotePessoasDados.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0)) ;
     ControllerLotePessoas.start ;
  finally

  end;
end;

end.


