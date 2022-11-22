unit uControllerClientes;

interface

uses uModelClientes, FireDAC.Comp.Client, System.SysUtils ;

type
 TControllerClientes = class
 private
    FModelClientes: TModelClientes;

 public
   property ModelClientes : TModelClientes read  FModelClientes write FModelClientes;

   function persistir  : Boolean ;
   function selecionar : TFDQuery ;

   constructor Create;
   destructor destroy; override;

 end;

implementation

{ TControllerClientes }

constructor TControllerClientes.Create;
begin
    FModelClientes := TModelClientes.Create;
    inherited ;
end;

destructor TControllerClientes.destroy;
begin
  FreeAndNil(FModelClientes);
  inherited;
end;

function TControllerClientes.persistir: Boolean;
begin
  result := FModelClientes.persistir ;
end;

function TControllerClientes.selecionar: TFDQuery;
begin
  result := FModelClientes.selecionar ;
end;

end.
