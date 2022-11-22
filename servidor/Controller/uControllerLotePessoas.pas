unit uControllerLotePessoas;

interface

uses
  System.Classes, uModelEnderecoIntegracao, uEnumerador, System.Net.URLClient, System.Net.HttpClient,
  System.SysUtils, System.Generics.Collections, System.Net.HttpClientComponent, uControllerIntegracao,
  System.JSON, FireDAC.Comp.Client, FireDAC.DApt, uModelPessoas, uModelEndereco, uDAOPessoas ;


type
  TControllerLotePessoas = class(TThread)
  private
    FModelEnderecoIntegracao: TModelEnderecoIntegracao ;
    FModelEndereco: TModelEndereco;
    FModelPessoas: TModelPessoas;
    FLotePessoasDados : TFDMemTable;
    FListLotePessoasDados  : TObjectList<TModelPessoas> ;
    FListaMemTableIntegrar : TObjectList<TFDMemTable>   ;

    function PreparaDadosModelPessoas(dsdocumento, nmprimeiro, nmsegundo,
      ceps: String): TModelPessoas;

  public
     property ModelPessoas    : TModelPessoas  read  FModelPessoas     write FModelPessoas  ;
     property ModelEndereco   : TModelEndereco read  FModelEndereco    write FModelEndereco ;
     property LotePessoasDados: TFDMemTable    read  FLotePessoasDados write FLotePessoasDados ;
     property ListLotePessoasDados : TObjectList<TModelPessoas>   read  FListLotePessoasDados  write FListLotePessoasDados ;
     property ListaMemTableIntegrar: TObjectList<TFDMemTable>     read  FListaMemTableIntegrar write FListaMemTableIntegrar ;

     constructor Create  ;
     destructor destroy; override;
  protected
    procedure Execute; override;

  end;

implementation

{ ControllerIntegracao }

constructor TControllerLotePessoas.Create   ;
begin
    inherited Create (True);
    FreeOnTerminate := True;
    FListLotePessoasDados := TObjectList<TModelPessoas>.Create ;
    FListaMemTableIntegrar:= TObjectList<TFDMemTable>.Create   ;
    FModelPessoas  := TModelPessoas.Create  ;
    FModelEndereco := TModelEndereco.Create ;
    FLotePessoasDados := LotePessoasDados   ;
end;

destructor TControllerLotePessoas.destroy;
var
  ControllerIntegracao : TControllerIntegracao ;
begin
  FreeAndNil(FModelPessoas) ;
  FreeAndNil(FModelEndereco);

  //Inicio a Integração CEPs
  if FExecutarControllerIntegracao then
     ControllerIntegracao := TControllerIntegracao.Create ;

  inherited;
end;


procedure TControllerLotePessoas.Execute;
var
  daoPessoas        : TDAOPessoas ;
  dsdocumento, nmprimeiro, nmsegundo, ceps : String ;
  I : Integer ;
begin

  NameThreadForDebugging('uControllerIntegracao');
  { Place thread code here }
  daoPessoas := TDAOPessoas.Create ;
     for I := 0 to FListaMemTableIntegrar.Count - 1 do
     begin
        FListaMemTableIntegrar[I].Open ;
        while not FListaMemTableIntegrar[I].Eof do
        begin
           dsdocumento  := FListaMemTableIntegrar[I].FieldByName('dsdocumento').AsString ;
           nmprimeiro   := FListaMemTableIntegrar[I].FieldByName('nmprimeiro').AsString  ;
           nmsegundo    := FListaMemTableIntegrar[I].FieldByName('nmsegundo').AsString   ;
           ceps         := FListaMemTableIntegrar[I].FieldByName('ceps').AsString        ;

           PreparaDadosModelPessoas(dsdocumento, nmprimeiro, nmsegundo, ceps)    ;

           FListaMemTableIntegrar[I].Next ;
        end;

        daoPessoas.incluirLote(ListLotePessoasDados) ;

     end ;

     FreeOnTerminate := True;
end;

function TControllerLotePessoas.PreparaDadosModelPessoas(dsdocumento, nmprimeiro, nmsegundo, ceps : String ) : TModelPessoas ;
var
 _ListEnderecos : TStringList ;
 I : Integer ;
begin
   ListLotePessoasDados.add(TModelPessoas.Create) ;

   ListLotePessoasDados[ListLotePessoasDados.Count-1].idpessoa     :=  0     ;
   if Length(dsdocumento) > 11  then
      ListLotePessoasDados[ListLotePessoasDados.Count-1].f1natureza   :=  0
   else
      ListLotePessoasDados[ListLotePessoasDados.Count-1].f1natureza   :=  1 ;
   ListLotePessoasDados[ListLotePessoasDados.Count-1].dsdocumento  :=  dsdocumento   ;
   ListLotePessoasDados[ListLotePessoasDados.Count-1].nmprimeiro   :=  nmprimeiro    ;
   ListLotePessoasDados[ListLotePessoasDados.Count-1].nmsegundo    :=  nmsegundo     ;
   ListLotePessoasDados[ListLotePessoasDados.Count-1].dtregistro   :=  Date()        ;
   ListLotePessoasDados[ListLotePessoasDados.Count-1].enuTipo      :=  uEnumerador.tipoIncluir ;

   _ListEnderecos  := TStringList.Create ;
   ExtractStrings(['|'], [], PChar(ceps), _ListEnderecos);
   for I := 0 to _ListEnderecos.Count -1 do
   begin
          ListLotePessoasDados[ListLotePessoasDados.Count-1].dscep.Add(TModelEndereco.Create) ;
          ListLotePessoasDados[ListLotePessoasDados.Count-1].dscep[ListLotePessoasDados[ListLotePessoasDados.Count-1].dscep.Count-1].idendereco  := 0   ;
          ListLotePessoasDados[ListLotePessoasDados.Count-1].dscep[ListLotePessoasDados[ListLotePessoasDados.Count-1].dscep.Count-1].idpessoa    := 0   ;
          ListLotePessoasDados[ListLotePessoasDados.Count-1].dscep[ListLotePessoasDados[ListLotePessoasDados.Count-1].dscep.Count-1].dscep       := _ListEnderecos[I]   ;
   end;
end;

end.
