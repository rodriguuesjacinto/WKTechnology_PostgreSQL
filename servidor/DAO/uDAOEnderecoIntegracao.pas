unit uDAOEnderecoIntegracao;

interface

uses System.SysUtils, uModelEnderecoIntegracao, FireDAC.Comp.Client, uControllerConexao, FireDAC.DApt ;

type
  TDAOEnderecoIntegracao = class
  private


  public
    function selecionar(ModelEnderecoIntegracao : TModelEnderecoIntegracao): TFDQuery;
    function incluir (ModelEnderecoIntegracao : TModelEnderecoIntegracao): Boolean;
    function excluir (ModelEnderecoIntegracao : TModelEnderecoIntegracao): Boolean;
    function alterar (ModelEnderecoIntegracao : TModelEnderecoIntegracao): Boolean;
    function selecionarCepsNaoIntegrados: TFDQuery;
  end;

implementation

{ TDAOEnderecoIntegracao }


function TDAOEnderecoIntegracao.alterar(ModelEnderecoIntegracao : TModelEnderecoIntegracao): Boolean;
var
  Query : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;
    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.ExecSQL('update endereco_integracao set dsuf = :dsuf, nmcidade = :nmcidade , nmbairro = :nmbairro, nmlogradouro = :nmlogradouro , dscomplemento = :dscomplemento where idendereco = :idendereco',
                    [ModelEnderecoIntegracao.dsuf, ModelEnderecoIntegracao.nmcidade, ModelEnderecoIntegracao.nmbairro, ModelEnderecoIntegracao.nmlogradouro, ModelEnderecoIntegracao.nmlogradouro, ModelEnderecoIntegracao.dscomplemento, ModelEnderecoIntegracao.idendereco]
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

function TDAOEnderecoIntegracao.excluir(ModelEnderecoIntegracao : TModelEnderecoIntegracao): Boolean;
var
  Query : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.ExecSQL('delete from endereco_integracao where idendereco = :idendereco',[ModelEnderecoIntegracao.idendereco]) ;
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

function TDAOEnderecoIntegracao.incluir(ModelEnderecoIntegracao : TModelEnderecoIntegracao): Boolean;
var
  Query : TFDQuery ;
begin
  try
     TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    Query := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      Query.ExecSQL('insert into endereco_integracao (idendereco,dsuf,nmcidade,nmbairro,nmlogradouro,dscomplemento) values (:idendereco,:dsuf,:nmcidade,:nmbairro,:nmlogradouro,:dscomplemento)',
                    [ModelEnderecoIntegracao.idendereco, ModelEnderecoIntegracao.dsuf, ModelEnderecoIntegracao.nmcidade, ModelEnderecoIntegracao.nmbairro, ModelEnderecoIntegracao.nmlogradouro, ModelEnderecoIntegracao.dscomplemento]
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

function TDAOEnderecoIntegracao.selecionar(ModelEnderecoIntegracao : TModelEnderecoIntegracao): TFDQuery;
var
  Query : TFDQuery ;
begin
  Query := TControllerConexao.getInstance.daoConexao.criarQrery;
  if ModelEnderecoIntegracao.idendereco > 0   then
     Query.Open('select * from endereco_integracao where idendereco = :idendereco',[ModelEnderecoIntegracao.idendereco])
  else
     Query.Open('select * from endereco_integracao') ;
  result := Query ;
end;

function TDAOEnderecoIntegracao.selecionarCepsNaoIntegrados(): TFDQuery;
var
  Query : TFDQuery ;
begin
  Query := TControllerConexao.getInstance.daoConexao.criarQrery;
  Query.Open('select e.idendereco, e.dscep from endereco e  where e.idendereco not in (select ei.idendereco from endereco_integracao ei )')  ;
  result := Query ;
end;

end.
