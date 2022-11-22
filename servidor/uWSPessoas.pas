unit uWSPessoas;

interface

uses System.SysUtils, System.Classes, DataSnap.DSProviderDataModuleAdapter,
    Datasnap.DSServer, Datasnap.DSAuth, System.JSON;

type
  TWSPessoas = class(TDSServerModule)

  private
     { private declarations }
  protected
     { protected declarations }
  public
     { public declarations }

     function Pessoa(): TJSONObject ;
     function AcceptPessoa(const AID_Pessoa: Integer): TJSONObject ;
     function UpdatePessoa(): TJSONObject ;
     function CancelPessoa(const AID_Pessoa: Integer): TJSONObject ;

     constructor Create;
     destructor destroy; override;
  published
     { published declarations }
  end;

implementation
 //uses uControllerPessoas ;

{%CLASSGROUP 'System.Classes.TPersistent'}
{TWSPessoas}


function TWSPessoas.AcceptPessoa(const AID_Pessoa: Integer): TJSONObject;
var
    jsonObj : TJSONObject ;
begin
    try
      jsonObj := TJSONObject.Create ;
      jsonObj.AddPair('Menssagem','Consumindo AcceptPessoa') ;
      Result := jsonObj  ;
   finally
      jsonObj.DisposeOf ;
    end;
end;

function TWSPessoas.CancelPessoa(const AID_Pessoa: Integer): TJSONObject;
var
    jsonObj : TJSONObject ;
begin
    try
      jsonObj := TJSONObject.Create ;
      jsonObj.AddPair('Menssagem','Consumindo CancelPessoa') ;
      Result := jsonObj  ;
   finally
      jsonObj.DisposeOf ;
    end;
end;

constructor TWSPessoas.Create;
begin

end;

destructor TWSPessoas.destroy;
begin

  inherited;
end;

function TWSPessoas.Pessoa(): TJSONObject;
var
  //controllerClientes : TControllerClientes ;
  jsonObj : TJSONObject ;
begin
  {  controllerClientes := TControllerClientes.Create;
    controllerClientes.ModelClientes.intidclientes := AID_Pessoa ;

    // Create dataset list
    Result := TFDJSONDataSets.Create;
    // Add departments dataset
    TFDJSONDataSetsWriter.ListAdd(Result, controllerClientes.selecionar);
    // Add employees dataset
    TFDJSONDataSetsWriter.ListAdd(Result, controllerClientes.selecionar); }
    try
      jsonObj := TJSONObject.Create ;
      jsonObj.AddPair('Menssagem','Consumindo Pessoa') ;
      Result := jsonObj  ;
   finally
      jsonObj.DisposeOf ;
    end;
end;

function TWSPessoas.UpdatePessoa: TJSONObject;
var
    jsonObj : TJSONObject ;
begin
    try
      jsonObj := TJSONObject.Create ;
      jsonObj.AddPair('Menssagem','Consumindo UpdatePessoa')  ;
      Result := jsonObj  ;
   finally
      jsonObj.DisposeOf ;
    end;
end;

end.
