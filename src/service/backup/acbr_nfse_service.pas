unit acbr_nfse_service;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  Math,

  { ACBr }
  ACBrBase,
  ACBrDFe,
  ACBrDFeUtil,
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.FilesIO,
  ACBrDFeReport,
  ACBrMail,
  ACBrNFSeX,
  ACBrNFSeXConversao,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXDANFSeClass,
  ACBrDFeSSL,
  inifiles,
  pcnConversao,
  blcksock,

  { DTO }
  nfse_dto;

type
  { INFSeService }
  IACBrNFSeService = interface
    function GetCertificadoInfo: TCertificadoInfo;

  end;

  { TACBrNFSeService }

  TACBrNFSeService = class(TInterfacedObject, IACBrNFSeService)
  private
    FACBrNFSeX: TACBrNFSeX;

  public
    { Methods }
    function GetInstance(cnpj: string): TACBrNFSeX;
    function GetCertificadoInfo: TCertificadoInfo;

    { Constructor & Destructor }
    constructor Create;
    destructor Destroy; override;

    class function New: IACBrNFSeService;
  end;

implementation

{ TACBrNFSeService Constructor & Destructor }
constructor TACBrNFSeService.Create;
begin
  inherited Create;
  FACBrNFSeX := TACBrNFSeX.Create(nil);
end;

destructor TACBrNFSeService.Destroy;
begin
  FAcbrNFSEx.Free;
  inherited Destroy;
end;

class function TACBrNFSeService.New: IACBrNFSeService;
begin
  Result := Self.Create;
end;

{ TACBrNFSeService }
function TACBrNFSeService.GetInstance(cnpj: string): TACBrNFSeX;
begin
  try
    FACBrNFSeX.Configuracoes.Geral.SSLLib := TSSLLib.libWinCrypt;
    FACBrNFSeX.SSL.SSLType := TSSLType.LT_TLSv1_2;

    // Configura o Certificado
    FACBrNFSeX.Configuracoes.Certificados.ArquivoPFX :=
      ExtractFilePath(ParamStr(0)) + 'certificados\' + cnpj + '.pfx';

    FACBrNFSeX.Configuracoes.Certificados.Senha := 'ED120971';
  except
    on E: Exception do
    begin
      raise Exception.Create('Error' + E.Message);

    end;
  end;

end;

function TACBrNFSeService.GetCertificadoInfo: TCertificadoInfo;
begin

  NumeroSerie := ACBrNFSeX.SSL.CertNumeroSerie;
  RazaoSocial := ACBrNFSeX.SSL.CertRazaoSocial;
  Cnpj := ACBrNFSeX.SSL.CertCNPJ;
  DataVencimento := ACBrNFSeX.SSL.CertDataVenc;
  DiasVencimento := Trunc(DataVencimento - Now);

  case ACBrNFSeX.SSL.CertTipo of
    tpcDesconhecido: Tipo := 'Desconhecido';
    tpcA1: Tipo := 'A1';
    tpcA3: Tipo := 'A3';
  end;

  Json.Put('numero_serie', CertificadoInfo.NumeroSerie);
  Json.Put('razao_social', CertificadoInfo.RazaoSocial);
  Json.Put('cnpj', CertificadoInfo.Cnpj);
  Json.Put('data_vencimento', DateToStr(CertificadoInfo.DataVencimento));
  Json.Put('dias_vencimento', IntToStr(CertificadoInfo.DiasVencimento));
  Json.Put('tipo', CertificadoInfo.Tipo);

  ResponseDescription := Json.Stringify;
end;


end.
