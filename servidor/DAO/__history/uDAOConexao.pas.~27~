unit uDAOConexao;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error , System.SysUtils,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, System.Classes, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL,  IniFiles,  FireDAC.Phys.PG ;

type
  TDAOConexao = class
  private
    FConexao: TFDConnection;
    FMySQLDriverLink : TFDPhysMySQLDriverLink ;
    FDPhysPgDriverLink: TFDPhysPgDriverLink   ;

    procedure LerIni() ;

  public

    function getConexao: TFDConnection;
    function criarQrery: TFDQuery;
    function getGDBdefault: String ;

    constructor Create;
    destructor Destroy; Override ;

  end;

implementation

{ TDAOConexao }
var
  cVendorLib, cDriverID , cDatabase, cUserName, cPassword , cPort, cServer , cGDBdefault : String ;

constructor TDAOConexao.Create;
begin
  inherited Create;

  LerIni;

  if cGDBdefault = 'MySQL' then
  begin
     FMySQLDriverLink    := TFDPhysMySQLDriverLink.Create(nil) ;
     FDPhysPgDriverLink.VendorLib  := cVendorLib ;
  end
  else
  begin
    FDPhysPgDriverLink  := TFDPhysPgDriverLink.Create(nil) ;
    FDPhysPgDriverLink.VendorLib  := cVendorLib ;
  end;

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
  if cGDBdefault = 'PostgreSQL' then
     FreeAndNil(FDPhysPgDriverLink);
  if cGDBdefault = 'MySQL' then
     FreeAndNil(FMySQLDriverLink);
end;

function TDAOConexao.getConexao: TFDConnection;
begin
  result := FConexao;
end;

function TDAOConexao.getGDBdefault: String;
begin
   result := cGDBdefault ;
end;

procedure TDAOConexao.LerIni;
var
  ArquivoINI: TIniFile;
begin
   ArquivoINI := TIniFile.Create(ExtractFilePath(ParamStr(0))+'\Conexao.ini');

   cGDBdefault := ArquivoINI.ReadString('GDBdefault', 'cGDBdefault', '' );
   if cGDBdefault = 'MySQL' then
   begin
       cVendorLib := ArquivoINI.ReadString('MySQL', 'cVendorLib', '' );
       cDriverID  := ArquivoINI.ReadString('MySQL', 'cDriverID' , '' );
       cDatabase  := ArquivoINI.ReadString('MySQL', 'cDatabase' , '' );
       cUserName  := ArquivoINI.ReadString('MySQL', 'cUserName' , '' );
       cPassword  := ArquivoINI.ReadString('MySQL', 'cPassword' , '' );
       cPort      := ArquivoINI.ReadString('MySQL', 'cPort'     , '' );
       cServer    := ArquivoINI.ReadString('MySQL', 'cServer'   , '' );
   end
   else
   begin
       cVendorLib := ArquivoINI.ReadString('PostgreSQL', 'cVendorLib', '' );
       cDriverID  := ArquivoINI.ReadString('PostgreSQL', 'cDriverID' , '' );
       cDatabase  := ArquivoINI.ReadString('PostgreSQL', 'cDatabase' , '' );
       cUserName  := ArquivoINI.ReadString('PostgreSQL', 'cUserName' , '' );
       cPassword  := ArquivoINI.ReadString('PostgreSQL', 'cPassword' , '' );
       cPort      := ArquivoINI.ReadString('PostgreSQL', 'cPort'     , '' );
       cServer    := ArquivoINI.ReadString('PostgreSQL', 'cServer'   , '' );
   end;
   ArquivoINI.Free ;
end;

end.
