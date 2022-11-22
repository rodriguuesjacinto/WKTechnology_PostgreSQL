unit uDAOConexao;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, FireDAC.Stan.StorageJSON,
  DataSnap.DSProviderDataModuleAdapter, Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.StorageBin;

type
  TdaoDataModule = class(TDSServerModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    FDStanStorageBinLink: TFDStanStorageBinLink;
    FDStanStorageJSONLink: TFDStanStorageJSONLink;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  daoDataModule: TdaoDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
