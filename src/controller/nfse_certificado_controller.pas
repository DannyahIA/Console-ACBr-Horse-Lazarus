unit nfse_certificado_controller;

{$IF DEFINED(FPC)}
   {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Classes,
  SysUtils,

  { Horse }
  Horse,

  { Json }
  Jsons,

  { UTIL's }
  nfse_valid_json,
  acbr_nfse_service;

type
  { INFSeCertificadoController }
  INFSeCertificadoController = interface

  end;

  { TNFSeCertificadoController }
  TNFSeCertificadoController = class(TInterfacedObject, INFSeCertificadoController)
  private

  public

  end;

procedure Registry;

{ ROTAS }
procedure PostCertificado(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure PutCertificado(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure DeleteCertificado(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure GetCertificado(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

{ RECEBE UM CNPJ PEGA DADOS DO CERTIFICADO E RETORNA EM JSON }
procedure PostCertificado(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Header: string;
  Json: Jsons.TJson;
  ResponseDescription: string;
  ResponseStatusCode: integer;
begin
  Header := Req.Headers.Content.Values['x-authorization'];

  TACBrNFSeService.GetCertificadoInfo(Header);

    try
      try
      Json := Jsons.TJson.Create;

      Json.Put('numero_serie', CertificadoInfo.NumeroSerie);
      Json.Put('razao_social', CertificadoInfo.RazaoSocial);
      Json.Put('cnpj', CertificadoInfo.Cnpj);
      Json.Put('data_vencimento', DateToStr(CertificadoInfo.DataVencimento));
      Json.Put('dias_vencimento', IntToStr(CertificadoInfo.DiasVencimento));
      Json.Put('tipo', CertificadoInfo.Tipo);

      ResponseDescription := Json.Stringify;
      ResponseStatusCode := 200;

      except
        on E: Exception do
        begin
          ResponseDescription := 'Parse Error';
          ResponseStatusCode := 400;
        end;

      end;

    finally
      Json.Free;
    end;
  end;

  Res.Send(ResponseDescription).Status(ResponseStatusCode);
end;

procedure GetCertificado(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Get Certificado').Status(THTTPStatus.OK);
end;

procedure PutCertificado(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Put Certificado').Status(200);
end;

procedure DeleteCertificado(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Delete Certificado').Status(200);
end;

procedure Registry;
begin
  THorse.Group.Prefix('geral')
    .Post('certificado', PostCertificado)
    .Put('certificado', PutCertificado)
    .Delete('certificado', DeleteCertificado)
    .Get('certificado', GetCertificado);
end;

end.
