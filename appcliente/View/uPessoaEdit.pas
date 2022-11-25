unit uPessoaEdit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ComboEdit, FMX.DateTimeCtrls,
  FMX.Edit, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

type
  TFormPessoaEdit = class(TForm)
    Panel_dados: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit_idpessoa: TEdit;
    Edit_dsdocumento: TEdit;
    Edit_nmprimeiro: TEdit;
    Edit_nmsegundo: TEdit;
    Edit_dtregistro: TDateEdit;
    Edit_f1natureza: TComboEdit;
    Panel_cep: TPanel;
    Panel3: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    ButtonCancelar: TButton;
    ButtonConfirmar: TButton;
    Edit_CEP: TEdit;
    ButtonCEP: TButton;
    StatusBar1: TStatusBar;
    ListViewEndereco: TListView;
    ButtonExcluirCps: TButton;
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonCEPClick(Sender: TObject);
    procedure ButtonConfirmarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ButtonExcluirCpsClick(Sender: TObject);
  private
    function GetStrNumber(const S: string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPessoaEdit: TFormPessoaEdit;

implementation

{$R *.fmx}

uses uModelPessoas , uEnumerador, uModelEndereco ;

function TFormPessoaEdit.GetStrNumber(const S: string): string;
var
  vText : PChar;
begin
  vText := PChar(S);
  Result := '';

  while (vText^ <> #0) do
  begin
    {$IFDEF UNICODE}
    if CharInSet(vText^, ['0'..'9']) then
    {$ELSE}
    if vText^ in ['0'..'9'] then
    {$ENDIF}
      Result := Result + vText^;

    Inc(vText);
  end;
end;

procedure TFormPessoaEdit.ButtonCancelarClick(Sender: TObject);
begin
    close ;
end;

procedure TFormPessoaEdit.ButtonCEPClick(Sender: TObject);
begin
   if Length(GetStrNumber(Edit_CEP.Text)) = 8 then
   begin
       TListItemText(ListViewEndereco.Items.Add.Objects.FindDrawable('endereco')).Text := copy(GetStrNumber(Edit_CEP.Text),0,5)+'-'+copy(GetStrNumber(Edit_CEP.Text),6,3) + ' - [ Aguardando Integração ]' ;
       Edit_CEP.Text := '' ;
       Edit_CEP.SetFocus   ;
   end
   else
        ShowMessage('CEP Informado esta incompleto.') ;
end;

procedure TFormPessoaEdit.ButtonConfirmarClick(Sender: TObject);
var
  ModelPessoas      : TModelPessoas  ;
  I : Integer ;
begin

      if (ListViewEndereco.Items.Count = 0) then
      begin
         ShowMessage('Cliente deve conter um ou mais endereços validos.') ;
         exit ;
      end;

      ModelPessoas  := TModelPessoas.Create  ;

      ModelPessoas.idpessoa      :=   strtoint(Edit_idpessoa.Text)  ;
      ModelPessoas.f1natureza    :=   Edit_f1natureza.ItemIndex + 1 ;
      ModelPessoas.dsdocumento   :=   Edit_dsdocumento.Text         ;
      ModelPessoas.nmprimeiro    :=   Edit_nmprimeiro.Text          ;
      ModelPessoas.nmsegundo     :=   Edit_nmsegundo.Text           ;
      ModelPessoas.dtregistro    :=   Edit_dtregistro.Date          ;
      if Edit_idpessoa.Text = '0' then
         ModelPessoas.enuTipo       :=   uEnumerador.tipoIncluir
      else
         ModelPessoas.enuTipo       :=   uEnumerador.tipoAlterar  ;

      if FormPessoaEdit.Tag = 1 then
            ModelPessoas.enuTipo    :=   uEnumerador.tipoExcluir  ;

      for I := 0 to ListViewEndereco.Items.Count -1 do
      begin
          ModelPessoas.dscep.Add(TModelEndereco.Create) ;
            ModelPessoas.dscep[I].idendereco  := 0   ;
            ModelPessoas.dscep[I].idpessoa    := strtoint(Edit_idpessoa.Text)  ;
            ModelPessoas.dscep[I].dscep       := copy(TListItemText(ListViewEndereco.Items[I].Objects.FindDrawable('endereco')).Text,0,9) ;
      end;

      ModelPessoas.persistir ;

      close ;

end;

procedure TFormPessoaEdit.ButtonExcluirCpsClick(Sender: TObject);
begin
      if not( ((ListViewEndereco.Selected = nil)or(ListViewEndereco.Items.Count = 0)) ) then
         ListViewEndereco.Items.Delete(ListViewEndereco.Selected.Index) ;

      if ListViewEndereco.Items.Count > 0 then
         ListViewEndereco.SetFocus
      else
         Edit_CEP.SetFocus ;
end;

procedure TFormPessoaEdit.FormActivate(Sender: TObject);
begin
   Panel_dados.Enabled := FormPessoaEdit.Tag = 0  ;
   Panel_cep.Enabled   := FormPessoaEdit.Tag = 0  ;
end;

end.
