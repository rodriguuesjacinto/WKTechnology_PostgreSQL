unit uModelEndereco;

interface

uses uEnumerador, System.SysUtils , FireDAC.Comp.Client ;

type
  TModelEndereco = class
  private
      Fidendereco   : Integer ;
      Fidpessoa     : Integer ;
      Fdscep        : String  ;
      FEnumerador   : TEnumerador;

  public
      property idendereco   : Integer      read  Fidendereco  write Fidendereco   ;
      property idpessoa     : Integer      read  Fidpessoa    write Fidpessoa     ;
      property dscep        : String       read  Fdscep       write Fdscep        ;
      property enuTipo      : TEnumerador  read  FEnumerador  write FEnumerador   ;

      function persistir  : Boolean  ;
      function selecionar : TFDQuery ;


  end;


implementation

uses  uDAOEndereco ;

{ TModelEndereco }


function TModelEndereco.persistir: Boolean;
var
  daoEndereco : TDAOEndereco ;
begin
  daoEndereco := TDAOEndereco.Create ;
  try
      case FEnumerador of
        tipoIncluir:
          result := daoEndereco.incluir(self) ;
        tipoExcluir:
          result := daoEndereco.excluir(self) ;
        tipoAlterar:
          result := daoEndereco.alterar(self) ;
      end;
  finally
    FreeAndNil(daoEndereco) ;
  end;
end;

function TModelEndereco.selecionar: TFDQuery;
var
  daoEndereco : TDAOEndereco ;
begin
  daoEndereco := TDAOEndereco.Create ;
  try
    result := daoEndereco.selecionar(self) ;
  finally
    FreeAndNil(daoEndereco) ;
  end;

end;

end.
