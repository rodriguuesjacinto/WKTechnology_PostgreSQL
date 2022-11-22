unit uPessoaLoteExemplo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TFormPessoaLoteExemplo = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPessoaLoteExemplo: TFormPessoaLoteExemplo;

implementation

{$R *.fmx}

procedure TFormPessoaLoteExemplo.Button1Click(Sender: TObject);
begin
  close ;
end;

end.
