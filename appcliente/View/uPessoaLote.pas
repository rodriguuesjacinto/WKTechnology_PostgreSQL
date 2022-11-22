unit uPessoaLote;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit,
  System.ImageList, FMX.ImgList, StrUtils , uClientModulePessoa,
  FireDAC.Comp.BatchMove.JSON, Data.FireDACJSONReflect, FireDAC.DApt ,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uModelPessoas, uModelEndereco, FireDAC.Stan.Async, System.Generics.Collections ;

type
  TFormPessoaLote = class(TForm)
    StatusBar1: TStatusBar;
    PanelTop: TPanel;
    PanelCentro: TPanel;
    Label1: TLabel;
    ListViewArquivo: TListView;
    Label2: TLabel;
    EditPathArquivo: TEdit;
    Button_arquivo: TButton;
    ImageList1: TImageList;
    ProgressBar_arquivo: TProgressBar;
    Label_progresso: TLabel;
    OpenArquivo: TOpenDialog;
    ButtonExportaLote: TButton;
    ButtoVerificar: TButton;
    procedure Button_arquivoClick(Sender: TObject);
    procedure MontaListaArquivo(const _Path_ArquivoLote : string) ;
    procedure AddListViewArquivo(const dsdocumento, nmprimeiro, nmsegundo, ceps : string) ;
    procedure ButtoVerificarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonExportaLoteClick(Sender: TObject);
  private
    { Private declarations }
    function ValidaDados(const dsdocumento, nmprimeiro, nmsegundo, ceps : string): Boolean ;
    function GetStrNumber(const S: string): string;
    procedure TThreadEnd(Sender: TObject);

  public
    { Public declarations }
  end;

var
  FormPessoaLote : TFormPessoaLote;
  ListaMemTableIntegrar  : TObjectList<TFDMemTable>      ;
  _MemTableIntegrar: TFDMemTable     ;
implementation

{$R *.fmx}

function TFormPessoaLote.GetStrNumber(const S: string): string;
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

function TFormPessoaLote.ValidaDados(const dsdocumento, nmprimeiro, nmsegundo,
  ceps: string): Boolean;
begin

   result := true ;
end;


procedure TFormPessoaLote.AddListViewArquivo(const dsdocumento, nmprimeiro,
  nmsegundo, ceps: string);
begin
  with ListViewArquivo.Items.Add do
  begin
     TListItemText(Objects.FindDrawable('dsdocumento')).Text  :=  dsdocumento ;
     TListItemText(Objects.FindDrawable('nmprimeiro')).Text   :=  nmprimeiro  ;
     TListItemText(Objects.FindDrawable('nmsegundo')).Text    :=  nmsegundo   ;
     TListItemText(Objects.FindDrawable('ceps')).Text         :=  ceps        ;
   end;
end;

procedure TFormPessoaLote.ButtonExportaLoteClick(Sender: TObject);
begin

   if ClientModulePessoa.LotePessoa(_MemTableIntegrar) then
   begin
      ShowMessage('Atenção! '+#13+'Pacote de Arquivo enviado para o Servidor.') ;
      ListaMemTableIntegrar.Clear ;
      ListViewArquivo.Items.Clear ;
      EditPathArquivo.Text := ''  ;
      ProgressBar_arquivo.Value := 0 ;
      Label_progresso.Text      := 'Verificando estrutura do arquivo ...'   ;
   end
   else
      ShowMessage('Atenção! '+#13+'Err ao enviar Pacote de Arquivo para o Servidor.') ;

end;

procedure TFormPessoaLote.Button_arquivoClick(Sender: TObject);
begin
   if OpenArquivo.Execute then
      EditPathArquivo.Text := OpenArquivo.FileName
   else
      EditPathArquivo.Text := '' ;
end;

procedure TFormPessoaLote.ButtoVerificarClick(Sender: TObject);
begin
    if FileExists(EditPathArquivo.Text) then
    begin
      ListViewArquivo.BeginUpdate ;
        MontaListaArquivo(EditPathArquivo.Text) ;
      ListViewArquivo.EndUpdate   ;
    end
    else
      ShowMessage('Atenção! '+#13+'Arquivo não encontrado.') ;
end;

procedure TFormPessoaLote.FormCreate(Sender: TObject);
begin
   ListaMemTableIntegrar :=  TObjectList<TFDMemTable>.Create ;
end;

procedure TFormPessoaLote.FormDestroy(Sender: TObject);
begin
   FreeAndNil(ListaMemTableIntegrar) ;
end;

procedure TFormPessoaLote.TThreadEnd(Sender: TObject);
begin
  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage('Atenção! '+#13+'Erro ao Carregar os Dados! Não Foi Possivel carregar os Dados ' +
                 Exception(TThread(Sender).FatalException).Message
               );
    Label_progresso.Text      := 'Erro ao Carregar os Dados! Não Foi Possivel carregar os Dados.' ;
  end
  else
  begin
    Label_progresso.Text      := 'Arquivo preparado para envio em lote.{ Total de registros :'+ FormatFloat('00000',ProgressBar_arquivo.Max) +'}' + ' Número de Pacotes : ' + FormatFloat('000',ListaMemTableIntegrar.Count + 1) ;
    ButtonExportaLote.Enabled := True ;
  end ;
end;

procedure TFormPessoaLote.MontaListaArquivo(const _Path_ArquivoLote: string);
var
  _TThread           : TThread ;
begin
  _TThread := TThread.CreateAnonymousThread(procedure
  var
      I, J : Integer ;
      LinhaDados , Arquivo : TStringList ;
      dsdocumento, nmprimeiro, nmsegundo, ceps: string ;
  begin
      try
          ListaMemTableIntegrar.Clear ;
          ListViewArquivo.Items.Clear ;
          Arquivo           := TStringList.Create;
          LinhaDados        := TStringList.Create;
          _MemTableIntegrar := TFDMemTable.Create(nil);
          begin
              _MemTableIntegrar.Close ;
              _MemTableIntegrar.FieldDefs.Add('dsdocumento' , ftString, 20 , false)  ;
              _MemTableIntegrar.FieldDefs.Add('nmprimeiro'  , ftString, 100, false)  ;
              _MemTableIntegrar.FieldDefs.Add('nmsegundo'   , ftString, 100, false)  ;
              _MemTableIntegrar.FieldDefs.Add('ceps'        , ftString, 200, false)  ;
              _MemTableIntegrar.CreateDataset;
              _MemTableIntegrar.Open ;
          end;

          Arquivo.LoadFromFile(_Path_ArquivoLote);

          TThread.Synchronize(nil , procedure
          begin
              ButtonExportaLote.Enabled := False ;
              ProgressBar_arquivo.Max   := Arquivo.Count ;
          end ) ;

          for I := 0 to Arquivo.Count -1 do
          begin
              LinhaDados.Clear ;
              ExtractStrings([';'], [], PChar(Arquivo[I]), LinhaDados);

              dsdocumento := GetStrNumber(copy(LinhaDados[0],0,20))  ;
              nmprimeiro  := UTF8ToString(copy(LinhaDados[1],0,100)) ;
              nmsegundo   := UTF8ToString(copy(LinhaDados[2],0,100)) ;
              ceps        := '' ;
              for J := 3 to LinhaDados.Count -1 do
                  ceps    := ceps + IfThen(ceps = '','','|') +  copy(GetStrNumber(LinhaDados[J]),0,5)+'-'+copy(GetStrNumber(LinhaDados[J]),5,3)  ;

              //desenvolver função para verificar integridade de dados
              if ValidaDados( dsdocumento, nmprimeiro, nmsegundo, ceps ) then
              begin
                  //Preparo os Objetos para enviar para o servidor
                  _MemTableIntegrar.InsertRecord([  dsdocumento, nmprimeiro, nmsegundo, ceps  ]) ;
              end ;

              {
              _MemTableIntegrar.FieldByName('nmsegundo').AsString ;
              if _MemTableIntegrar.RecordCount = 100 then
              begin
                 ListaMemTableIntegrar.Add(TFDMemTable.Create(nil))    ;
                 ListaMemTableIntegrar[ListaMemTableIntegrar.Count -1].CopyDataSet(_MemTableIntegrar)   ;
                 _MemTableIntegrar.EmptyDataSet ;
              end;
               }

              TThread.Synchronize(nil , procedure
              begin
                AddListViewArquivo(dsdocumento, nmprimeiro, nmsegundo, ceps) ;
                ProgressBar_arquivo.Value := I + 1 ;
                Label_progresso.Text      := 'Verificando registros ' + FormatFloat('00000',I) + ' de ' + FormatFloat('00000',Arquivo.Count) + ' .' ;
                Application.ProcessMessages ;
              end) ;

          end;

          {
          if _MemTableIntegrar.RecordCount > 0 then
          begin
                 ListaMemTableIntegrar.Add(_MemTableIntegrar)    ;
                 ListaMemTableIntegrar[ListaMemTableIntegrar.Count -1].FieldByName('dsdocumento').AsString  ;
          end ;
          }
      finally
        FreeAndNil(LinhaDados) ;
        FreeAndNil(Arquivo) ;
        //FreeAndNil(_MemTableIntegrar) ;
      end;

  end) ;

  _TThread.OnTerminate := TThreadEnd ;
  _TThread.Start ;
end;

end.
