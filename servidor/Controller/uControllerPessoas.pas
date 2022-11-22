unit uControllerPessoas;

interface

uses uModelPessoas, uModelEndereco, FireDAC.Comp.Client, System.SysUtils, FireDAC.Comp.BatchMove.JSON, Data.FireDACJSONReflect ;

type
 TControllerPessoas = class
 private
    FModelPessoas: TModelPessoas;
    FModelEndereco: TModelEndereco;

 public
   property ModelPessoas  : TModelPessoas  read  FModelPessoas  write FModelPessoas  ;
   property ModelEndereco : TModelEndereco read  FModelEndereco write FModelEndereco ;

   function persistir  : Boolean ;
   function selecionar : TFDJSONDataSets ;

   constructor Create;
   destructor destroy; override;

 end;

implementation

{ TControllerPessoas }

constructor TControllerPessoas.Create;
begin
    FModelPessoas  := TModelPessoas.Create  ;
    FModelEndereco := TModelEndereco.Create ;
    inherited ;
end;

destructor TControllerPessoas.destroy;
begin
  FreeAndNil(FModelPessoas) ;
  FreeAndNil(FModelEndereco);
  inherited;
end;

function TControllerPessoas.persistir: Boolean;
begin
  result := FModelPessoas.persistir ;
end;

function TControllerPessoas.selecionar: TFDJSONDataSets;
begin
  result := TFDJSONDataSets.Create ;
            TFDJSONDataSetsWriter.ListAdd(result,FModelPessoas.selecionar)  ;
            TFDJSONDataSetsWriter.ListAdd(result,FModelEndereco.selecionar) ;
end;

end.
