unit uModelEnderecoIntegracao;

interface

uses uEnumerador, System.SysUtils , FireDAC.Comp.Client ;

type
  TModelEnderecoIntegracao = class
  private
      Fidendereco    : Integer ;
      Fdsuf          : String  ;
      Fnmcidade      : String  ;
      Fnmbairro      : String  ;
      Fnmlogradouro  : String  ;
      Fdscomplemento : String  ;
      FEnumerador    : TEnumerador;

  public
      property idendereco    : Integer      read  Fidendereco      write Fidendereco           ;
      property dsuf          : String       read  Fdsuf            write Fdsuf                 ;
      property nmcidade      : String       read  Fnmcidade        write Fnmcidade             ;
      property nmbairro      : String       read  Fnmbairro        write Fnmbairro             ;
      property nmlogradouro  : String       read  Fnmlogradouro    write Fnmlogradouro         ;
      property dscomplemento : String       read  Fdscomplemento   write Fdscomplemento        ;
      property enuTipo       : TEnumerador  read  FEnumerador      write FEnumerador           ;

      function persistir  : Boolean  ;
      function selecionar : TFDQuery ;
      function selecionarCepsNaoIntegrados : TFDQuery ;


  end;


implementation

uses  uDAOEnderecoIntegracao ;

{ TModelEnderecoIntegracao }


function TModelEnderecoIntegracao.persistir: Boolean;
var
  daoEnderecoIntegracao : TDAOEnderecoIntegracao ;
begin
  daoEnderecoIntegracao := TDAOEnderecoIntegracao.Create ;
  try
      case FEnumerador of
        tipoIncluir:
          result := daoEnderecoIntegracao.incluir(self) ;
        tipoExcluir:
          result := daoEnderecoIntegracao.excluir(self) ;
        tipoAlterar:
          result := daoEnderecoIntegracao.alterar(self) ;
      end;
  finally
    FreeAndNil(daoEnderecoIntegracao) ;
  end;
end;

function TModelEnderecoIntegracao.selecionar: TFDQuery;
var
  daoEnderecoIntegracao : TDAOEnderecoIntegracao ;
begin
  daoEnderecoIntegracao := TDAOEnderecoIntegracao.Create ;
  try
    result := daoEnderecoIntegracao.selecionar(self) ;
  finally
    FreeAndNil(daoEnderecoIntegracao) ;
  end;

end;

function TModelEnderecoIntegracao.selecionarCepsNaoIntegrados: TFDQuery;
var
  daoEnderecoIntegracao : TDAOEnderecoIntegracao ;
begin
  daoEnderecoIntegracao := TDAOEnderecoIntegracao.Create ;
  try
    result := daoEnderecoIntegracao.selecionarCepsNaoIntegrados() ;
  finally
    FreeAndNil(daoEnderecoIntegracao) ;
  end;

end;

end.
