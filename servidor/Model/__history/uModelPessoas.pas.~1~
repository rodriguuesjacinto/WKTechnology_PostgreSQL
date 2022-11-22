unit uModelClientes;

interface

uses uEnumerador, System.SysUtils , FireDAC.Comp.Client ;

type
  TModelClientes = class
  private
      Fidclientes : Integer ;
      Fcli_nome   : String  ;
      Fcli_cidade : String  ;
      Fcli_uf     : String  ;
      FEnumerador : TEnumerador;


  public
      property intidclientes : Integer      read  Fidclientes   write Fidclientes   ;
      property strcli_nome   : String       read  Fcli_nome     write Fcli_nome     ;
      property strcli_cidade : String       read  Fcli_cidade   write Fcli_cidade   ;
      property strcli_uf     : String       read  Fcli_uf       write Fcli_uf       ;
      property enuTipo       : TEnumerador  read  FEnumerador   write FEnumerador   ;

      function persistir  : Boolean ;
      function selecionar : TFDQuery ;


  end;


implementation

uses uDAOClientes ;

{ TModelClientes }


function TModelClientes.persistir: Boolean;
var
  daoClientes : TDAOClientes ;
begin
  daoClientes := TDAOClientes.Create ;
  try
      case FEnumerador of
        tipoIncluir:
          result := daoClientes.incluir(self) ;
        tipoExcluir:
          result := daoClientes.excluir(self) ;
        tipoAlterar:
          result := daoClientes.alterar(self) ;
      end;
  finally
    FreeAndNil(daoClientes) ;
  end;
end;

function TModelClientes.selecionar: TFDQuery;
var
  daoClientes : TDAOClientes ;
begin
  daoClientes := TDAOClientes.Create ;
  try
    result := daoClientes.selecionarcliente(self) ;
  finally
    FreeAndNil(daoClientes) ;
  end;

end;

end.
