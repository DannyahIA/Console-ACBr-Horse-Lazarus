unit cliente_main_view;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  ExtCtrls,

  { SDK }
  nfse_sdk,
  certificado_info_dto;

type
  { TForm1 }
  TForm1 = class(TForm)
    btmGetInfoCertificado: TButton;
    btmSaveFilePdf: TButton;
    btmSaveFileXml: TButton;
    edtCnpj: TEdit;
    mmResult: TMemo;
    Panel1: TPanel;
    procedure btmGetInfoCertificadoClick(Sender: TObject);
    procedure btmSaveFilePdfClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btmGetInfoCertificadoClick(Sender: TObject);
var
  SDK: TNFSeSDK;
  CertificadoInfo: TCertificadoInfo;
begin
  SDK := TNFSeSDK.Create;

  CertificadoInfo := SDK.GetCertificadoInfo(edtCnpj.Text);

  if (SDK.GetStatusCode <> 200) then
  begin
    ShowMessage(IntToStr(SDK.GetStatusCode) + SLineBreak + SDK.GetResponseError);
    exit;
  end
  else

    { MOSTRA INFORMAÇÕES }
    mmResult.Clear;
  mmResult.Lines.Add('Numero de Serie: ' + CertificadoInfo.NumeroSerie);
  mmResult.Lines.Add('Razão Social: ' + CertificadoInfo.RazaoSocial);
  mmResult.Lines.Add('Cnpj: ' + CertificadoInfo.Cnpj);
  mmResult.Lines.Add('Data Vencimento: ' + DateToStr(CertificadoInfo.DataVencimento));
  mmResult.Lines.Add('Dias pro Vencimento: ' + IntToStr(CertificadoInfo.DiasVencimento));
  mmResult.Lines.Add('Tipo: ' + CertificadoInfo.Tipo);

end;

procedure TForm1.btmSaveFilePdfClick(Sender: TObject);
var
  SDK: TNFSeSDK;
begin
  SDK := TNFSeSDK.Create;

  SDK.GetNFSePDF;

  Showmessage('Arquivo salvo d:\temp\meu_teste.pdf');

end;

end.
