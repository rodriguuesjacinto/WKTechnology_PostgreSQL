unit uDAOPessoas;

interface

uses System.SysUtils, uModelPessoas, uModelEndereco, FireDAC.Comp.Client, uControllerConexao,
System.Generics.Collections, FireDAC.DApt ;

type
  TDAOPessoas = class
  private


  public
    function selecionar(ModelPessoas : TModelPessoas): TFDQuery;
    function incluir (ModelPessoas : TModelPessoas): Boolean;
    function excluir (ModelPessoas : TModelPessoas): Boolean;
    function alterar (ModelPessoas : TModelPessoas): Boolean;
    function incluirLote(
          ModelPessoasList: TObjectList<TModelPessoas>): Boolean;
  end;

implementation

{ TDAOPessoas }


function TDAOPessoas.alterar(ModelPessoas: TModelPessoas): Boolean;
var
  Query : TFDQuery ;
  _EnderecoColection : TModelEndereco ;
   listaCeps : string ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;
    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.ExecSQL('update pessoa set f1natureza = :f1natureza, dsdocumento = :dsdocumento, nmprimeiro = :nmprimeiro , nmsegundo = :nmsegundo  where idpessoa = :idpessoa',
                        [ModelPessoas.f1natureza, ModelPessoas.dsdocumento, ModelPessoas.nmprimeiro, ModelPessoas.nmsegundo, ModelPessoas.idpessoa]
                       ) ;

       //Estou fazendo o tratamento dos CEP aqui para envolver em uma unica Transaction
       listaCeps := '' ;
       for _EnderecoColection in ModelPessoas.dscep do
       begin
           if listaCeps <> ''  then
             listaCeps := listaCeps + ' , ' ;
           listaCeps := listaCeps + QuotedStr( _EnderecoColection.dscep ) ;
       end;
       Query.ExecSQL('delete from endereco e where e.idpessoa = :idpessoa and e.dscep not in ('+ listaCeps +')',[ModelPessoas.idpessoa])  ;

       for _EnderecoColection in ModelPessoas.dscep do
       begin
          Query.ExecSQL('insert into endereco (idpessoa,dscep) SELECT :_idpessoa,:_dscep where not exists (select e.idpessoa, e.dscep from endereco e where e.idpessoa = :_idpessoa and e.dscep = :_dscep )',
                        [ModelPessoas.idpessoa,_EnderecoColection.dscep ])  ;
       end;

    finally
      FreeAndNil(Query) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.Commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOPessoas.excluir(ModelPessoas: TModelPessoas): Boolean;
var
  Query : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.ExecSQL('delete from pessoa where idpessoa = :idpessoa',[ModelPessoas.idpessoa]) ;
    finally
      FreeAndNil(Query) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.Commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOPessoas.incluir(ModelPessoas: TModelPessoas): Boolean;
var
  Query : TFDQuery ;
  _EnderecoColection : TModelEndereco ;
begin
  try
     TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.Open('insert into pessoa (f1natureza,dsdocumento,nmprimeiro,nmsegundo,dtregistro) values (:f1natureza,:dsdocumento,:nmprimeiro,:nmsegundo,CURRENT_DATE) RETURNING idpessoa  ;',
                        [ModelPessoas.f1natureza, ModelPessoas.dsdocumento, ModelPessoas.nmprimeiro, ModelPessoas.nmsegundo]
                ) ;
       ModelPessoas.idpessoa := Query.Fields[0].AsInteger ;

       for _EnderecoColection in ModelPessoas.dscep do
       begin
          Query.ExecSQL('insert into endereco (idpessoa,dscep) SELECT :_idpessoa,:_dscep where not exists (select e.idpessoa, e.dscep from endereco e where e.idpessoa = :_idpessoa and e.dscep = :_dscep )',
                        [ModelPessoas.idpessoa,_EnderecoColection.dscep ])  ;
       end;
    finally
      FreeAndNil(Query) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.Commit   ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOPessoas.selecionar(ModelPessoas : TModelPessoas): TFDQuery;
var
  Query : TFDQuery ;
begin
  Query := TControllerConexao.getInstance.daoConexao.criarQrery;
  if ModelPessoas.idpessoa > 0   then
     Query.Open('select * from pessoa where idclientes = :idclientes',[ModelPessoas.idpessoa])
  else
     Query.Open('select * from pessoa') ;
  result := Query ;
end;

function TDAOPessoas.incluirLote(ModelPessoasList: TObjectList<TModelPessoas>): Boolean;
var
  Query : TFDQuery ;
  ModelPessoas       : TModelPessoas  ;
  _EnderecoColection : TModelEndereco ;
   listaCeps : string ;
   I : Integer ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;
    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
        for I := 0 to ModelPessoasList.Count -1 do
        begin

          Query.Open('insert into pessoa (f1natureza,dsdocumento,nmprimeiro,nmsegundo,dtregistro) values (:f1natureza,:dsdocumento,:nmprimeiro,:nmsegundo,CURRENT_DATE) RETURNING idpessoa ;',
                            [ModelPessoasList.Items[I].f1natureza, ModelPessoasList.Items[I].dsdocumento, ModelPessoasList.Items[I].nmprimeiro, ModelPessoasList.Items[I].nmsegundo]
                          ) ;
           ModelPessoasList.Items[I].idpessoa := Query.Fields[0].AsInteger ;

           for _EnderecoColection in ModelPessoasList.Items[I].dscep do
           begin
               Query.ExecSQL('insert into endereco (idpessoa,dscep) SELECT :_idpessoa,:_dscep where not exists (select e.idpessoa, e.dscep from endereco e where e.idpessoa = :_idpessoa and e.dscep = :_dscep )',
                              [ModelPessoasList.Items[I].idpessoa,_EnderecoColection.dscep ])  ;
           end;

        end;
    finally
      FreeAndNil(Query) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.Commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;

end;

end.
