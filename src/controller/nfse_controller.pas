unit nfse_controller;

{$IF DEFINED(FPC)}
   {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Horse,
  Horse.OctetStream,
  //Jsons,
  SysUtils,
  Classes,
  nfse_acbr_service,
  nfse_dto,
  json_nfsedto_adapter;

type
  { INfseController }
  INfseController = interface
    function GetDescription: string;
    function GetStatusCode: THTTPStatus;
  end;

  { TNfseController }
  TNfseController = class(TInterfacedObject, INfseController)
  private
    FDescription: string;
    FStatusCode: THTTPStatus;

  public
    function GetDescription: string;
    function GetStatusCode: THTTPStatus;
  end;

procedure Registry;

{ ROTAS }
procedure GetNFSeEnvia(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure GetNFSeConsulta(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure PostNFSeCancela(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure PostNFSeEmail(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure GetNFSeEmailPeriodo(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure GetNFSeArquivoXML(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure GetNFSeArquivoPDF(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

{ TNfseController }

function TNfseController.GetDescription: string;
begin
  Result := FDescription;
end;

function TNfseController.GetStatusCode: THTTPStatus;
begin
  Result := FStatusCode;
end;

procedure Registry;
begin
  THorse.Group.Prefix('nfse')
    .Get('envia', GetNFSeEnvia)
    .Get('consulta', GetNFSeConsulta)
    .Post('cancela', PostNFSeCancela)
    .Post('email', PostNFSeEmail)
    .Get('email/periodo', GetNFSeEmailPeriodo)
    .Get('arquivo/xml', GetNFSeArquivoXML)
    .Get('arquivo/pdf', GetNFSeArquivoPDF);
end;

procedure GetNFSeEnvia(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Get NFSe Envia').Status(200);
end;

procedure GetNFSeConsulta(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Get NFSe Consulta').Status(200);
end;

procedure PostNFSeCancela(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Post NFSe Cancela').Status(200);
end;

procedure PostNFSeEmail(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Post NFSe Email').Status(200);
end;

procedure GetNFSeEmailPeriodo(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Get NFSe Email Periodo').Status(200);
end;

procedure GetNFSeArquivoXML(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LStream: TStream;
  FileName : string;
begin
  FileName := 'D:\temp\teste.xml';

  LStream := TFileStream.Create(FileName, fmOpenRead);
  Res.Send<TStream>(LStream);

end;

procedure GetNFSeArquivoPDF(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LStream: TStream;
  FileName : string;
begin
  FileName := 'D:\temp\teste.pdf';

  LStream := TFileStream.Create(FileName, fmOpenRead);
  Res.Send<TStream>(LStream);

end;

end.
