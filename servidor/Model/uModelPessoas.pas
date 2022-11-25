unit uModelPessoas;

interface

uses uEnumerador, uModelEndereco, System.SysUtils, System.Generics.Collections , FireDAC.Comp.Client ;

type
  TModelPessoas = class
  private
      Fidpessoa   : Integer ;
      Ff1natureza : Integer ;
      Fdsdocumento: String  ;
      Fnmprimeiro : String  ;
      Fnmsegundo  : String  ;
      Fdtregistro : TDate   ;
      Fdscep      : TObjectList<TModelEndereco> ;
      FEnumerador : TEnumerador;
      Fpagina: Integer;


  public
      property idpessoa     : Integer                        read  Fidpessoa    write Fidpessoa     ;
      property f1natureza   : Integer                        read  Ff1natureza  write Ff1natureza   ;
      property dsdocumento  : String                         read  Fdsdocumento write Fdsdocumento  ;
      property nmprimeiro   : String                         read  Fnmprimeiro  write Fnmprimeiro   ;
      property nmsegundo    : String                         read  Fnmsegundo   write Fnmsegundo    ;
      property dtregistro   : TDate                          read  Fdtregistro  write Fdtregistro   ;
      property dscep        : TObjectList<TModelEndereco>    read  Fdscep       write Fdscep        ;
      property enuTipo      : TEnumerador                    read  FEnumerador  write FEnumerador   ;
      property pagina       : Integer                        read  Fpagina      write Fpagina       ;

      constructor Create;
      destructor destroy; override;

      function persistir  : Boolean ;
      function selecionar : TFDQuery ;


  end;


implementation

uses  uDAOPessoas ;

{ TModelPessoas }


constructor TModelPessoas.Create;
begin
  inherited Create ;
  Fdscep  := TObjectList<TModelEndereco>.Create ;
end;

destructor TModelPessoas.destroy;
begin
  inherited;
  FreeAndNil(Fdscep) ;
end;

function TModelPessoas.persistir: Boolean;
var
  daoPessoas : TDAOPessoas ;
begin
  daoPessoas := TDAOPessoas.Create ;
  try
      case FEnumerador of
        tipoIncluir:
          result := daoPessoas.incluir(self) ;
        tipoExcluir:
          result := daoPessoas.excluir(self) ;
        tipoAlterar:
          result := daoPessoas.alterar(self) ;
      end;
  finally
    FreeAndNil(daoPessoas) ;
  end;
end;

function TModelPessoas.selecionar: TFDQuery;
var
  daoPessoas : TDAOPessoas ;
begin
  daoPessoas := TDAOPessoas.Create ;
  try
    result := daoPessoas.selecionar(self) ;
  finally
    FreeAndNil(daoPessoas) ;
  end;

end;

end.
