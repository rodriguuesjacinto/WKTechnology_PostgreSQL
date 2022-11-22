unit uControllerLotePessoas;

interface

uses
  System.Classes, uModelEnderecoIntegracao, uEnumerador, System.Net.URLClient, System.Net.HttpClient,
  System.SysUtils, System.Generics.Collections, System.Net.HttpClientComponent,
  System.JSON, FireDAC.Comp.Client, FireDAC.DApt, uModelPessoas, uModelEndereco, uDAOPessoas ;


type
  TControllerLotePessoas = class(TThread)
  private
    FModelEnderecoIntegracao: TModelEnderecoIntegracao ;
    FModelEndereco: TModelEndereco;
    FModelPessoas: TModelPessoas;
    FLotePessoasDados : TFDMemTable;
    FListLotePessoasDados  : TObjectList<TModelPessoas> ;
    function PreparaDadosModelPessoas(dsdocumento, nmprimeiro, nmsegundo,
      ceps: String): TModelPessoas;

  public
     property ModelPessoas    : TModelPessoas  read  FModelPessoas     write FModelPessoas  ;
     property ModelEndereco   : TModelEndereco read  FModelEndereco    write FModelEndereco ;
     property LotePessoasDados: TFDMemTable    read  FLotePessoasDados write FLotePessoasDados ;
     property ListLotePessoasDados: TObjectList<TModelPessoas>    read  FListLotePessoasDados write FListLotePessoasDados ;

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
    FModelPessoas  := TModelPessoas.Create  ;
    FModelEndereco := TModelEndereco.Create ;
    FLotePessoasDados := LotePessoasDados   ;
end;

destructor TControllerLotePessoas.destroy;
begin
  FreeAndNil(FModelPessoas) ;
  FreeAndNil(FModelEndereco);
  inherited;
end;


procedure TControllerLotePessoas.Execute;
var
  daoPessoas        : TDAOPessoas ;
  dsdocumento, nmprimeiro, nmsegundo, ceps : String ;
begin

  NameThreadForDebugging('uControllerIntegracao');
  { Place thread code here }
  daoPessoas := TDAOPessoas.Create ;
  FLotePessoasDados.Open ;
  while not FLotePessoasDados.Eof do
  begin
     dsdocumento  := FLotePessoasDados.FieldByName('dsdocumento').AsString ;
     nmprimeiro   := FLotePessoasDados.FieldByName('nmprimeiro').AsString  ;
     nmsegundo    := FLotePessoasDados.FieldByName('nmsegundo').AsString   ;
     ceps         := FLotePessoasDados.FieldByName('ceps').AsString        ;

     PreparaDadosModelPessoas(dsdocumento, nmprimeiro, nmsegundo, ceps)    ;

     FLotePessoasDados.Next ;
  end;

  daoPessoas.incluirLote(ListLotePessoasDados) ;
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
