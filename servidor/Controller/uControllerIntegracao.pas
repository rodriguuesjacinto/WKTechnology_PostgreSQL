unit uControllerIntegracao ;

interface

uses
  System.Classes, uModelEnderecoIntegracao, uEnumerador, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.JSON, FireDAC.Comp.Client, FireDAC.DApt ;

type
  TControllerIntegracao = class(TThread)
  private
      FModelEnderecoIntegracao: TModelEnderecoIntegracao ;

      function  BuscaEnderecoIntegracao(const aURL : String) : TJSONArray ;
      function  PreparaDadosIntegracao(const Aidendereco : Integer ; const aCEP : String) : Boolean ;

  public
     property ModelEnderecoIntegracao : TModelEnderecoIntegracao read  FModelEnderecoIntegracao write FModelEnderecoIntegracao ;

     constructor Create;
     destructor destroy; override;
  protected
    procedure Execute; override;

  end;

implementation

{ ControllerIntegracao }

constructor TControllerIntegracao.Create;
begin
    FModelEnderecoIntegracao := TModelEnderecoIntegracao.Create ;
    inherited ;
end;

destructor TControllerIntegracao.destroy;
begin
  FModelEnderecoIntegracao.DisposeOf ;
  inherited;
end;


function TControllerIntegracao.BuscaEnderecoIntegracao(const aURL : String) : TJSONArray ;
var
  JsonStream    : TStringStream  ;
  NetHTTPClient : TNetHTTPClient ;
begin
  try
      JsonStream    := TStringStream.Create ;
      NetHTTPClient := TNetHTTPClient.Create(nil) ;
      NetHTTPClient.ContentType    := 'application/json';
      NetHTTPClient.AcceptEncoding := 'UTF-8';
      NetHTTPClient.Get(aURL,JsonStream)  ;

      if  TJSONObject.ParseJSONValue(JsonStream.DataString) is TJSONArray then
          Result := TJSONObject.ParseJSONValue(JsonStream.DataString) as TJSONArray
      else if  TJSONObject.ParseJSONValue(JsonStream.DataString) is TJSONObject then
          Result := TJSONObject.ParseJSONValue('['+JsonStream.DataString+']') as TJSONArray ;

  finally
      JsonStream.DisposeOf     ;
      NetHTTPClient.DisposeOf  ;
  end;
end;

function TControllerIntegracao.PreparaDadosIntegracao(const Aidendereco : Integer ; const  Acep : String) : Boolean ;
var
  StringList : TStringList;
  json       : TJSONArray ;
  currcond   : TJSONObject;
  I     : integer ;
  _erro , _cep : String  ;
begin
    if (Length(Acep) = 9) and (copy(Acep,6,1) = '-') then
    begin
        JSON :=  BuscaEnderecoIntegracao('https://viacep.com.br/ws/'+ aCEP +'/json/')  ;
        for I := 0 to JSON.Count -1 do
        begin
            currcond := json.Items[I] as TJSONObject;
            if not(currcond.TryGetValue('erro',_erro)) then
            begin
               FModelEnderecoIntegracao.idendereco    := Aidendereco  ;
               FModelEnderecoIntegracao.nmlogradouro  := UTF8ToString((currcond.GetValue('logradouro').Value))   ;
               FModelEnderecoIntegracao.dscomplemento := UTF8ToString(currcond.GetValue('complemento').Value)  ;
               FModelEnderecoIntegracao.nmbairro      := UTF8ToString(currcond.GetValue('bairro').Value)       ;
               FModelEnderecoIntegracao.nmcidade      := UTF8ToString(currcond.GetValue('localidade').Value)   ;
               FModelEnderecoIntegracao.dsuf          := UTF8ToString(currcond.GetValue('uf').Value)           ;
            end
            else
            begin
                FModelEnderecoIntegracao.idendereco    := Aidendereco  ;
                FModelEnderecoIntegracao.nmlogradouro  := 'Esse CEP n�o foi encontrado verificar'   ;
                FModelEnderecoIntegracao.dscomplemento := '' ;
                FModelEnderecoIntegracao.nmbairro      := '' ;
                FModelEnderecoIntegracao.nmcidade      := '' ;
                FModelEnderecoIntegracao.dsuf          := '' ;
            end;
            FModelEnderecoIntegracao.enuTipo          := uEnumerador.tipoIncluir ;
        end ;
    end
    else
    begin
        FModelEnderecoIntegracao.idendereco    := Aidendereco  ;
        FModelEnderecoIntegracao.nmlogradouro  := 'Esse CEP n�o foi encontrado verificar'   ;
        FModelEnderecoIntegracao.dscomplemento := '' ;
        FModelEnderecoIntegracao.nmbairro      := '' ;
        FModelEnderecoIntegracao.nmcidade      := '' ;
        FModelEnderecoIntegracao.dsuf          := '' ;
        FModelEnderecoIntegracao.enuTipo       := uEnumerador.tipoIncluir ;
    end;
    FModelEnderecoIntegracao.persistir ;
end;

procedure TControllerIntegracao.Execute;
var
  Query : TFDQuery ;
begin
  NameThreadForDebugging('uControllerIntegracao');
  { Place thread code here }
  Query := FModelEnderecoIntegracao.selecionarCepsNaoIntegrados ;
  try
      Query.Open ;
      while not Query.Eof do
      begin
         PreparaDadosIntegracao(Query.FieldByName('idendereco').AsInteger, Query.FieldByName('dscep').AsString) ;
         Query.Next ;
      end;
  finally
      Query.DisposeOf;
      Terminate;
      WaitFor;
      Free;
  end;
end;

end.
