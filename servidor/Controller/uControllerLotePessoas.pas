unit uControllerLotePessoas;

interface

uses
  System.Classes, uModelEnderecoIntegracao, uEnumerador, System.Net.URLClient, System.Net.HttpClient,
  System.SysUtils, System.Generics.Collections, System.Net.HttpClientComponent, uControllerIntegracao,
  System.JSON, FireDAC.Comp.Client, FireDAC.DApt, uModelPessoas, uModelEndereco, uDAOConexao ;


type
  TControllerLotePessoas = class(TThread)
  private
    FModelEnderecoIntegracao: TModelEnderecoIntegracao ;
    FModelEndereco: TModelEndereco;
    FModelPessoas: TModelPessoas;
    FLotePessoasDados : TFDMemTable;
    FListLotePessoasDados  : TObjectList<TModelPessoas> ;
    FListaMemTableIntegrar : TObjectList<TFDMemTable>   ;
    FConexaoThreads : TDAOConexao;

    function PreparaDadosModelPessoas(dsdocumento, nmprimeiro, nmsegundo,
      ceps: String): TModelPessoas;
    function incluirLote(ModelPessoasList: TObjectList<TModelPessoas>): Boolean;

  public
     property ModelPessoas    : TModelPessoas  read  FModelPessoas     write FModelPessoas     ;
     property ModelEndereco   : TModelEndereco read  FModelEndereco    write FModelEndereco    ;
     property LotePessoasDados: TFDMemTable    read  FLotePessoasDados write FLotePessoasDados ;
     property daoConexaoThreads      : TDAOConexao    read FConexaoThreads           write FConexaoThreads          ;

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
    FreeOnTerminate       := True;
    FConexaoThreads       := TDAOConexao.Create;
    FListLotePessoasDados := TObjectList<TModelPessoas>.Create ;
    FListaMemTableIntegrar:= TObjectList<TFDMemTable>.Create   ;
    FModelPessoas         := TModelPessoas.Create  ;
    FModelEndereco        := TModelEndereco.Create ;
    FLotePessoasDados     := LotePessoasDados   ;
end;

destructor TControllerLotePessoas.destroy;
var
  ControllerIntegracao : TControllerIntegracao ;
begin
  FreeAndNil(FModelPessoas) ;
  FreeAndNil(FModelEndereco);
  FreeAndNil(FConexaoThreads)      ;

  //Inicio a Integração CEPs
  ControllerIntegracao := TControllerIntegracao.Create ;

  inherited;
end;


procedure TControllerLotePessoas.Execute;
var
  dsdocumento, nmprimeiro, nmsegundo, ceps : String ;
  I : Integer ;
begin
     NameThreadForDebugging('ControllerLotePessoas');

     for I := 0 to FListaMemTableIntegrar.Count - 1 do
     begin
        ListLotePessoasDados.Clear ;
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

        incluirLote(ListLotePessoasDados) ;

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

function TControllerLotePessoas.incluirLote(ModelPessoasList: TObjectList<TModelPessoas>): Boolean;
var
  QueryLote : TFDQuery ;
  ModelPessoas       : TModelPessoas  ;
  _EnderecoColection : TModelEndereco ;
   listaCeps  : string ;
   sqlBuscaID : string ;
   I : Integer ;
begin
  try
      { select LAST_INSERT_ID() mysql | RETURNING idpessoa PostGres }
      if FConexaoThreads.getGDBdefault = 'MySQL' then
         sqlBuscaID := '; select LAST_INSERT_ID();'  else sqlBuscaID := ' RETURNING idpessoa;' ;

      FConexaoThreads.getConexao.StartTransaction ;
      QueryLote := FConexaoThreads.criarQrery;
      try
          for I := 0 to ModelPessoasList.Count -1 do
          begin

            QueryLote.Open('insert into pessoa (f1natureza,dsdocumento,nmprimeiro,nmsegundo,dtregistro) values (:f1natureza,:dsdocumento,:nmprimeiro,:nmsegundo,CURRENT_DATE) ' + sqlBuscaID ,
                              [ModelPessoasList.Items[I].f1natureza, ModelPessoasList.Items[I].dsdocumento, ModelPessoasList.Items[I].nmprimeiro, ModelPessoasList.Items[I].nmsegundo]
                            ) ;
             ModelPessoasList.Items[I].idpessoa := QueryLote.Fields[0].AsInteger ;

             for _EnderecoColection in ModelPessoasList.Items[I].dscep do
             begin
                 QueryLote.ExecSQL('insert into endereco (idpessoa,dscep) SELECT :_idpessoa,:_dscep where not exists (select e.idpessoa, e.dscep from endereco e where e.idpessoa = :_idpessoa and e.dscep = :_dscep )',
                                [ModelPessoasList.Items[I].idpessoa,_EnderecoColection.dscep ])  ;
             end;

          end;

      FConexaoThreads.getConexao.Commit ;
      result := true ;
    except
      FConexaoThreads.getConexao.Rollback ;
      result := false ;
    end;
  finally
      FreeAndNil(QueryLote) ;
  end;

end;

end.
