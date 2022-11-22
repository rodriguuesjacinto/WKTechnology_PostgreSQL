unit uPessoa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope ,
  FireDAC.Comp.BatchMove.JSON, Data.FireDACJSONReflect, uClientModulePessoa,
  System.ImageList, FMX.ImgList, StrUtils, System.JSON ;

type
  TFormPessoas = class(TForm)
    PanelTop: TPanel;
    PanelGeral: TPanel;
    ButtonAtualizar: TButton;
    ListPessoas: TListView;
    ImageList1: TImageList;
    ButtonNovo: TButton;
    ButtonAlterar: TButton;
    ButtonExcluir: TButton;
    StatusBar1: TStatusBar;
    ButtonLote: TButton;
    ProgressBarAtualizar: TProgressBar;
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonLoteClick(Sender: TObject);
    procedure ButtonExcluirClick(Sender: TObject);
    procedure ButtonAtualizarClick(Sender: TObject);
  private
    { Private declarations }
    procedure TThreadEnd(Sender: TObject);
    procedure AddListPessoas(idpessoa,f1natureza,dsdocumento,nmprimeiro,nmsegundo,dtregistro,endereco : String) ;
    procedure BuscaWSPessoas() ;
  public
    { Public declarations }

  end;

var
  FormPessoas: TFormPessoas;

implementation

{$R *.fmx}

uses uPessoaEdit, uPessoaLote ;

procedure TFormPessoas.TThreadEnd(Sender: TObject);
begin
  if Assigned(TThread(Sender).FatalException) then
     ShowMessage(Exception(TThread(Sender).FatalException).Message)  ;

  ProgressBarAtualizar.Visible := False ;

  ListPessoas.Items.EndUpdate ;
  ListPessoas.SetFocus  ;
end;

procedure TFormPessoas.AddListPessoas(idpessoa, f1natureza, dsdocumento,
  nmprimeiro, nmsegundo, dtregistro, endereco: String);
begin
    with ListPessoas.Items.Add do
    begin
       TListItemText(Objects.FindDrawable('idpessoa')).Text     := idpessoa    ;
       TListItemText(Objects.FindDrawable('f1natureza')).Text   := f1natureza  ;
       TListItemText(Objects.FindDrawable('dsdocumento')).Text  := dsdocumento ;
       TListItemText(Objects.FindDrawable('nmprimeiro')).Text   := nmprimeiro  ;
       TListItemText(Objects.FindDrawable('nmsegundo')).Text    := nmsegundo   ;
       TListItemText(Objects.FindDrawable('dtregistro')).Text   := dtregistro  ;
       TListItemText(Objects.FindDrawable('endereco')).Text     := endereco    ;
    end ;
end;

procedure TFormPessoas.BuscaWSPessoas;
var
   _TThread           : TThread ;
begin
  _TThread := TThread.CreateAnonymousThread(procedure
  var
     _MemTablePessoas   : TFDMemTable ;
     _MemTableEndereco  : TFDMemTable ;
     _EnderecosIntegrado: String ;
     idpessoa,f1natureza,dsdocumento,nmprimeiro,nmsegundo,dtregistro,endereco : String ;
  begin
      try
        _MemTablePessoas   := TFDMemTable.Create(nil)  ;
        _MemTableEndereco  := TFDMemTable.Create(nil)  ;

        _MemTablePessoas.Close ;
        _MemTablePessoas := ClientModulePessoa.Pessoa()[0] ;
        _MemTablePessoas.Open ;

        _MemTableEndereco.Close ;
        _MemTableEndereco := ClientModulePessoa.Pessoa()[1] ;
        _MemTableEndereco.Open  ;

        while not _MemTablePessoas.Eof do
        begin
           idpessoa     := FormatFloat('00000',_MemTablePessoas.FieldByName('idpessoa').AsFloat) ;
           f1natureza   := _MemTablePessoas.FieldByName('f1natureza').AsString  ;
           dsdocumento  := _MemTablePessoas.FieldByName('dsdocumento').AsString ;
           nmprimeiro   := _MemTablePessoas.FieldByName('nmprimeiro').AsString  ;
           nmsegundo    := _MemTablePessoas.FieldByName('nmsegundo').AsString   ;
           dtregistro   := _MemTablePessoas.FieldByName('dtregistro').AsString  ;

           _MemTableEndereco.FilterOptions := [foCaseInsensitive];
           _MemTableEndereco.Filter := 'idpessoa = ' + _MemTablePessoas.FieldByName('idpessoa').AsString ;
           _MemTableEndereco.Filtered := True ;
           _MemTableEndereco.First ;
           endereco := 'Endere�os:' +#13 ;
           while not _MemTableEndereco.Eof do
           begin
              _EnderecosIntegrado :=  '' ;
              endereco := endereco + _MemTableEndereco.FieldByName('dscep').AsString        + ' - [ ' ;

              _EnderecosIntegrado :=     _MemTableEndereco.FieldByName('nmlogradouro').AsString +
                                         ifthen(_MemTableEndereco.FieldByName('nmlogradouro').AsString = '','',', ')    +
                                         _MemTableEndereco.FieldByName('nmbairro').AsString     +
                                         ifthen(_MemTableEndereco.FieldByName('nmbairro').AsString = '','',', ')        +
                                         _MemTableEndereco.FieldByName('nmcidade').AsString     +
                                         ifthen(_MemTableEndereco.FieldByName('nmcidade').AsString = '','','-')         +
                                         _MemTableEndereco.FieldByName('dsuf').AsString         +
                                          ifthen(_MemTableEndereco.FieldByName('nmcidade').AsString = '','',' ')        +
                                         _MemTableEndereco.FieldByName('dscomplemento').AsString ;

              endereco := endereco + ifthen(_EnderecosIntegrado = '','Aguardando Integra��o',_EnderecosIntegrado) ;
              endereco := endereco + ' ] ' ;
              endereco := endereco + #13 ;

              _MemTableEndereco.Next ;
           end;

           TThread.Synchronize(nil , procedure
           begin
             ProgressBarAtualizar.Visible := True ;
             ProgressBarAtualizar.Max     := _MemTablePessoas.RecordCount ;
             ProgressBarAtualizar.Value   := ProgressBarAtualizar.Value + 1 ;
             AddListPessoas(idpessoa,f1natureza,dsdocumento,nmprimeiro,nmsegundo,dtregistro,endereco) ;
           end) ;

           _MemTablePessoas.Next ;
        end ;
      finally
        FreeAndNil(_MemTablePessoas)    ;
        FreeAndNil(_MemTableEndereco)   ;
      end;
  end);
  _TThread.OnTerminate := TThreadEnd ;
  _TThread.Start ;
end;

procedure TFormPessoas.ButtonAtualizarClick(Sender: TObject);
begin
  ListPessoas.Items.BeginUpdate      ;
  ListPessoas.Items.Clear            ;
  BuscaWSPessoas                     ;
end;

procedure TFormPessoas.ButtonAlterarClick(Sender: TObject);
var
 _Enderecos : String ;
 _ListEnderecos : TStringList ;
 I : Integer ;
begin
  FormPessoaEdit := TFormPessoaEdit.create ( nil );
  try
    // Carrego os Edits com os dados do List
    _ListEnderecos := TStringList.Create ;
    with FormPessoaEdit do
    begin
       FormPessoaEdit.Tag        := 0 ;
       ButtonConfirmar.Text      := 'Alterar' ;
       Edit_idpessoa.Text        := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('idpessoa')).Text                 ;
       Edit_f1natureza.ItemIndex := strtoint(TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('f1natureza')).Text) -1  ;
       Edit_dsdocumento.Text     := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('dsdocumento')).Text              ;
       Edit_nmprimeiro.Text      := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('nmprimeiro')).Text               ;
       Edit_nmsegundo.Text       := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('nmsegundo')).Text                ;
       Edit_dtregistro.Data      := StrToDate(TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('dtregistro')).Text)    ;
      _Enderecos                 := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('endereco')).Text  ;              ;

       ExtractStrings(['|'], [], PChar(_Enderecos), _ListEnderecos);

       for I := 1 to _ListEnderecos.Count -1 do
          TListItemText(ListViewEndereco.Items.Add.Objects.FindDrawable('endereco')).Text  := _ListEnderecos[I] ;
    end;

    FormPessoaEdit.ShowModal   ;
  finally
    FreeAndNil(FormPessoaEdit) ;
    FreeAndNil(_ListEnderecos) ;
  end;
end;

procedure TFormPessoas.ButtonExcluirClick(Sender: TObject);
var
 _Enderecos : String ;
 _ListEnderecos : TStringList ;
 I : Integer ;
begin
  FormPessoaEdit := TFormPessoaEdit.create ( nil );
  try
    // Carrego os Edits com os dados do List
    _ListEnderecos := TStringList.Create ;
    with FormPessoaEdit do
    begin
       FormPessoaEdit.Tag        := 1 ;
       ButtonConfirmar.Text      := 'Excluir' ;
       Edit_idpessoa.Text        := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('idpessoa')).Text              ;
       Edit_f1natureza.ItemIndex := strtoint(TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('f1natureza')).Text)  ;
       Edit_dsdocumento.Text     := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('dsdocumento')).Text           ;
       Edit_nmprimeiro.Text      := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('nmprimeiro')).Text            ;
       Edit_nmsegundo.Text       := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('nmsegundo')).Text             ;
       Edit_dtregistro.Data      := StrToDate(TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('dtregistro')).Text) ;
      _Enderecos                 := TListItemText(ListPessoas.Items[ListPessoas.Selected.Index].Objects.FindDrawable('endereco')).Text  ;             ;

       ExtractStrings(['|'], [], PChar(_Enderecos), _ListEnderecos);

       for I := 1 to _ListEnderecos.Count -1 do
          TListItemText(ListViewEndereco.Items.Add.Objects.FindDrawable('endereco')).Text  := _ListEnderecos[I] ;
    end;

    FormPessoaEdit.ShowModal   ;
  finally
    FreeAndNil(FormPessoaEdit) ;
    FreeAndNil(_ListEnderecos) ;
  end;

end;

procedure TFormPessoas.ButtonLoteClick(Sender: TObject);
begin
  FormPessoaLote := TFormPessoaLote.create ( nil );
  try
    FormPessoaLote.ShowModal ;
  finally
    FreeAndNil(FormPessoaEdit)
  end;
end;

procedure TFormPessoas.ButtonNovoClick(Sender: TObject);
begin
  FormPessoaEdit := TFormPessoaEdit.create ( nil );
  try
    FormPessoaEdit.Tag    := 0 ;
    FormPessoaEdit.ButtonConfirmar.Text := 'Incluir' ;
    FormPessoaEdit.ShowModal ;
  finally
    FreeAndNil(FormPessoaEdit)
  end;
end;

end.
