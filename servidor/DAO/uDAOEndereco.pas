unit uDAOEndereco;

interface

uses System.SysUtils, uModelEndereco, FireDAC.Comp.Client, uControllerConexao, FireDAC.DApt ;

type
  TDAOEndereco = class

  public
    function selecionar(ModelEndereco : TModelEndereco): TFDQuery;
    function incluir (ModelEndereco : TModelEndereco): Boolean;
    function excluir (ModelEndereco : TModelEndereco): Boolean;
    function alterar (ModelEndereco : TModelEndereco): Boolean;

  end;

implementation

{ TDAOEndereco }


function TDAOEndereco.alterar(ModelEndereco : TModelEndereco): Boolean;
var
  Query : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;
    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.ExecSQL('update endereco set idpessoa = :idpessoa, dscep = :dscep where idendereco = :idendereco',
                        [ModelEndereco.idpessoa, ModelEndereco.dscep, ModelEndereco.idpessoa]
                       ) ;
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

function TDAOEndereco.excluir(ModelEndereco : TModelEndereco): Boolean;
var
  Query : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.ExecSQL('delete from endereco where idendereco = :idendereco',[ModelEndereco.idendereco]) ;
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

function TDAOEndereco.incluir(ModelEndereco : TModelEndereco): Boolean;
var
  Query : TFDQuery ;
begin
  try
     TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.ExecSQL('insert into endereco (idendereco ,idpessoa,dscep) values (:idendereco ,:idpessoa,:dscep)',
                        [ModelEndereco.idendereco,ModelEndereco.idpessoa, ModelEndereco.dscep]
                      ) ;
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

function TDAOEndereco.selecionar(ModelEndereco : TModelEndereco): TFDQuery;
var
  Query : TFDQuery ;
begin
  Query := TControllerConexao.getInstance.daoConexao.criarQrery;
  if ModelEndereco.idpessoa > 0   then
     Query.Open('select e.idendereco, e.idpessoa, e.dscep,dsuf,nmcidade,nmbairro,nmlogradouro,dscomplemento from endereco e left join endereco_integracao ei on ei.idendereco = e.idendereco where idpessoa = :idpessoa',[ModelEndereco.idpessoa])
  else
     Query.Open('select e.idendereco, e.idpessoa, e.dscep,dsuf,nmcidade,nmbairro,nmlogradouro,dscomplemento from endereco e left join endereco_integracao ei on ei.idendereco = e.idendereco') ;
  result := Query ;
end;

end.
