program ServidorDatasnap;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  uServerConst in 'uServerConst.pas',
  DMServerContainer in 'DMServerContainer.pas' {ServerContainer: TDataModule},
  uDAOConexao in 'DAO\uDAOConexao.pas',
  uDAOPessoas in 'DAO\uDAOPessoas.pas',
  uControllerConexao in 'Controller\uControllerConexao.pas',
  uControllerPessoas in 'Controller\uControllerPessoas.pas',
  uWSPessoas in 'View\uWSPessoas.pas' {WSPessoas: TDSServerModule},
  uDAOEndereco in 'DAO\uDAOEndereco.pas',
  uEnumerador in 'Model\uEnumerador.pas',
  uModelEndereco in 'Model\uModelEndereco.pas',
  uModelEnderecoIntegracao in 'Model\uModelEnderecoIntegracao.pas',
  uModelPessoas in 'Model\uModelPessoas.pas',
  uControllerIntegracao in 'Controller\uControllerIntegracao.pas',
  uControllerLotePessoas in 'Controller\uControllerLotePessoas.pas';

begin
  try
    ReportMemoryLeaksOnShutdown  := False ;
    RunDSServer;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.

