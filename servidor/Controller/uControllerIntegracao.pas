unit uControllerIntegracao ;

interface

uses
  SysUtils, System.Classes, uModelEnderecoIntegracao, uEnumerador, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.JSON, FireDAC.Comp.Client, FireDAC.DApt, uDAOConexao ;

type
  TControllerIntegracao = class(TThread)
  private
    FModelEnderecoIntegracao: TModelEnderecoIntegracao ;
    FConexaoThreads: TDAOConexao;

    function  BuscaEnderecoIntegracao(const aURL : String) : TJSONArray ;
    procedure  PreparaDadosIntegracao(const Aidendereco : Integer ; const aCEP : String) ;
    procedure incluir(
      ModelEnderecoIntegracao: TModelEnderecoIntegracao) ;
    function selecionarCepsNaoIntegrados: TFDQuery;

  public
     property ModelEnderecoIntegracao : TModelEnderecoIntegracao read  FModelEnderecoIntegracao write FModelEnderecoIntegracao ;
     property daoConexaoThreads       : TDAOConexao              read FConexaoThreads           write FConexaoThreads          ;

     constructor Create;
     destructor destroy; override;
  protected
    procedure Execute; override;

  end;

implementation

{ ControllerIntegracao }

constructor TControllerIntegracao.Create;
begin
    FreeOnTerminate          := True;
    FModelEnderecoIntegracao := TModelEnderecoIntegracao.Create ;
    FConexaoThreads          := TDAOConexao.Create ;

    inherited ;
end;

destructor TControllerIntegracao.destroy;
begin
  FreeAndNil(FModelEnderecoIntegracao) ;
  FreeAndNil(FConexaoThreads)          ;

  inherited;
end;

procedure TControllerIntegracao.Execute;
var
  Query : TFDQuery ;
begin
  NameThreadForDebugging('uControllerIntegracao');
  Query := selecionarCepsNaoIntegrados ;
  try
      Query.Open ;
      while not Query.Eof do
      begin
         PreparaDadosIntegracao(Query.FieldByName('idendereco').AsInteger, Query.FieldByName('dscep').AsString) ;
         Query.Next ;
      end;
  finally
      FreeAndNil(Query)  ;
  end;
  FreeOnTerminate := True;
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

procedure TControllerIntegracao.PreparaDadosIntegracao(const Aidendereco : Integer ; const  Acep : String) ;
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
                FModelEnderecoIntegracao.nmlogradouro  := 'Esse CEP não foi encontrado verificar'   ;
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
        FModelEnderecoIntegracao.nmlogradouro  := 'Esse CEP não foi encontrado verificar'   ;
        FModelEnderecoIntegracao.dscomplemento := '' ;
        FModelEnderecoIntegracao.nmbairro      := '' ;
        FModelEnderecoIntegracao.nmcidade      := '' ;
        FModelEnderecoIntegracao.dsuf          := '' ;
        FModelEnderecoIntegracao.enuTipo       := uEnumerador.tipoIncluir ;
    end;

    incluir(FModelEnderecoIntegracao) ;

end;

function TControllerIntegracao.selecionarCepsNaoIntegrados(): TFDQuery;
var
  Query : TFDQuery ;
begin
  Query := FConexaoThreads.criarQrery;
  Query.Open('select e.idendereco, e.dscep from endereco e  where e.idendereco not in (select ei.idendereco from endereco_integracao ei )')  ;
  result := Query ;
end;

procedure TControllerIntegracao.incluir(ModelEnderecoIntegracao : TModelEnderecoIntegracao) ;
var
  Query : TFDQuery ;
begin
  try
     FConexaoThreads.getConexao.StartTransaction ;

    Query := FConexaoThreads.criarQrery;
    try
      Query.ExecSQL('insert into endereco_integracao (idendereco,dsuf,nmcidade,nmbairro,nmlogradouro,dscomplemento) values (:idendereco,:dsuf,:nmcidade,:nmbairro,:nmlogradouro,:dscomplemento)',
                    [ModelEnderecoIntegracao.idendereco, ModelEnderecoIntegracao.dsuf, ModelEnderecoIntegracao.nmcidade, ModelEnderecoIntegracao.nmbairro, ModelEnderecoIntegracao.nmlogradouro, ModelEnderecoIntegracao.dscomplemento]
                  ) ;
    finally
      FreeAndNil(Query) ;
    end;

    FConexaoThreads.getConexao.Commit ;

  except
    FConexaoThreads.getConexao.Rollback ;
  end;
end;


end.
