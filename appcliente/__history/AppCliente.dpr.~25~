program AppCliente;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPessoa in 'View\uPessoa.pas' {FormPessoas},
  uPessoaEdit in 'View\uPessoaEdit.pas' {FormPessoaEdit},
  uPessoaLote in 'View\uPessoaLote.pas' {FormPessoaLote},
  uClientModulePessoa in 'Controller\uClientModulePessoa.pas' {ClientModulePessoa: TDataModule},
  uModelPessoas in 'Model\uModelPessoas.pas',
  uModelEndereco in 'Model\uModelEndereco.pas',
  uEnumerador in 'Model\uEnumerador.pas',
  uClientClassesPessoa in 'Model\uClientClassesPessoa.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown  := False ;
  Application.Initialize;
  Application.CreateForm(TClientModulePessoa, ClientModulePessoa);
  Application.CreateForm(TFormPessoas, FormPessoas);
  Application.Run;
end.
