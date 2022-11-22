unit uDAOConexao;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, System.Classes, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, SysUtils,  IniFiles;

type
  TDAOConexao = class
  private
    FConexao: TFDConnection;
    FMySQLDriverLink : TFDPhysMySQLDriverLink ;

  public
    function getConexao: TFDConnection;
    function criarQrery: TFDQuery;


    constructor Create;
    destructor Destroy; Override;

    procedure LerIni() ;

  end;

implementation

{ TDAOConexao }
var
  cVendorLib, cDriverID , cDatabase, cUserName, cPassword , cPort, cServer : String ;
constructor TDAOConexao.Create;
begin
  inherited Create;

  LerIni;

  FMySQLDriverLink  := TFDPhysMySQLDriverLink.Create(nil) ;
  FMySQLDriverLink.VendorLib := cVendorLib ;

  FConexao := TFDConnection.Create(nil);
  FConexao.Params.DriverID := cDriverID    ;
  FConexao.Params.Database := cDatabase    ;
  FConexao.Params.UserName := cUserName    ;
  FConexao.Params.Password := cPassword    ;
  FConexao.Params.Add (cPort)     ;
  FConexao.Params.Add (cServer)   ;
end;

function TDAOConexao.criarQrery: TFDQuery;
var
  Query : TFDQuery ;
begin
  Query            := TFDQuery.Create(nil) ;
  Query.Connection := FConexao;

  result := Query ;
end;

destructor TDAOConexao.Destroy;
begin
  inherited;
  FreeAndNil(FConexao);
  FreeAndNil(FMySQLDriverLink);
end;

function TDAOConexao.getConexao: TFDConnection;
begin
  result := FConexao;
end;

procedure TDAOConexao.LerIni;
var
  ArquivoINI: TIniFile;
begin
   ArquivoINI := TIniFile.Create('D:\WKTechnology\MySQL.ini');

   cVendorLib := ArquivoINI.ReadString('mysql', 'cVendorLib', '' );
   cDriverID  := ArquivoINI.ReadString('mysql', 'cDriverID' , '' );
   cDatabase  := ArquivoINI.ReadString('mysql', 'cDatabase' , '' );
   cUserName  := ArquivoINI.ReadString('mysql', 'cUserName' , '' );
   cPassword  := ArquivoINI.ReadString('mysql', 'cPassword' , '' );
   cPort      := ArquivoINI.ReadString('mysql', 'cPort'     , '' );
   cServer    := ArquivoINI.ReadString('mysql', 'cServer'   , '' );

   ArquivoINI.Free ;
end;

end.
