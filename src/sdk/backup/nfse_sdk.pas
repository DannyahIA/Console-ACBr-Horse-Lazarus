unit nfse_sdk;

{$mode delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  Dialogs,

  { HTTP Status Code }
  nt.http.status.code,

  { Rest4Delphi }
  RESTRequest4D,

  { json }
  Jsons,

  { dto's }
  certificado_info_dto;

const
  URL_BASE: string = 'http://176.0.0.159';
  PORT: string = '57007';

type
  { INFSeSDK }
  INFSeSDK = interface
    procedure GetNFSePDF;
    procedure GetNFSeXML;

    function GetCertificadoInfo(Cnpj: string): TCertificadoInfo;
    function GetUrl(Field: string): string;
    function GetStatusCode: integer;
    function GetResponseError: string;
  end;

  { TNFSeSDK }
  TNFSeSDK = class(TInterfacedObject, INFSeSDK)
  private
    FResponseError: string;
    FStatusCode: integer;
    //Métodos
    function GetUrl(Field: string): string;

  public
    //Métodos
    procedure GetNFSePDF;
    procedure GetNFSeXML;

    function GetCertificadoInfo(Cnpj: string): TCertificadoInfo;
    function GetStatusCode: integer;
    function GetResponseError: string;

    class function New: INFSeSDK;
  end;

implementation

{ TNFseSDK }
class function TNFSeSDK.New: INFSeSDK;
begin
  Result := self.Create;
end;

function TNFSeSDK.GetCertificadoInfo(Cnpj: string): TCertificadoInfo;
var
  Response: IResponse;
  Json: Jsons.TJson;

  CertificadoInfo: TCertificadoInfo;
begin
  try
    Json := Jsons.TJson.Create;
    Json.Put('cnpj', Cnpj);
    try
      Response := TRequest.New.BaseURL(GetUrl('geral/certificado')).ContentType('application/json').AddBody(Json.Stringify).Post;
      //Response := TRequest.New.BaseURL(GetUrl('geral/certificado')).ContentType('application/json').AddBody('{"cnpj":"1234152"').Post;
      //Response := TRequest.New.BaseURL(GetUrl('geral/certificado')).AddHeader('x-authorization', '02618868000185').Post;

      Json.Clear;

      if (Response.StatusCode <> TNTHttpStatusCode.StatusOK) then
      begin
        if Response.Content.Contains('Invalid JSON') or
          Response.Content.Contains('Invalid Json') then
        begin
          raise Exception.Create('Json inválido.');
        end
        else if Response.Content.Contains('Certificado não encontrado') then
        begin
          raise Exception.Create('Certificado não encontrado.');
        end;
      end;

      FStatusCode := TNTHttpStatusCode.StatusOK;
      FResponseError := '';

      CertificadoInfo := TCertificadoInfo.Create;

      Json.Parse(Response.Content);

      with CertificadoInfo do
      begin
        Cnpj := Json.Values['cnpj'].AsString;
        DataVencimento := StrToDate(Json.Values['data_vencimento'].AsString);
        DiasVencimento := Json.Values['dias_vencimento'].AsInteger;
        NumeroSerie := Json.Values['numero_serie'].AsString;
        RazaoSocial := Json.Values['razao_social'].AsString;
        Tipo := Json.Values['tipo'].AsString;
      end;

    except
      on E: Exception do
      begin
        FStatusCode := Response.StatusCode;

        if FStatusCode = 0 then
        begin
          if E.Message.Contains('timed out') then
          begin
            FStatusCode := TNTHttpStatusCode.StatusRequestTimeout;
          end;

        end;
        FResponseError := E.Message;
        Result := nil;
      end;
    end;

    Result := CertificadoInfo;
  finally
    Json.Free;
  end;

end;

function TNFSeSDK.GetStatusCode: integer;
begin
  Result := FStatusCode;
end;

function TNFSeSDK.GetResponseError: string;
begin
  Result := FResponseError;
end;

function TNFSeSDK.GetUrl(Field: string): string;
begin
  Result := URL_BASE + ':' + PORT + '/' + Field;
end;

(**
* GetNFSeXML()
* Recebe um arquivo XML
**)

procedure TNFSeSDK.GetNFSeXML;
var
  Response: IResponse;
  Stream: TMemoryStream;
  FileName: string;
begin
  FileName := 'd:\temp\meu_teste.xml';

  deleteFile(FileName);

  Response := TRequest.New.BaseURL(GetUrl('nfse/arquivo/xml')).Get;

  if Response.StatusCode <> 200 then
  begin
    ShowMessage('Erro ao baixar o arquivo: ' + Response.Content);
    exit;
  end;

  Stream := TMemoryStream.create;

  try
    Stream.CopyFrom(Response.ContentStream, Response.ContentStream.Size);
    Stream.SaveToFile(FileName);
  finally
    Stream.Free;
  end;
end;

(**
* GetNFSePDF()
* Recebe um arquivo PDF
**)
procedure TNFSeSDK.GetNFSePDF;
var
  Response: IResponse;
  Stream: TMemoryStream;
  FileName: string;
begin
  FileName := 'd:\temp\meu_teste.pdf';

  deleteFile(FileName);

  Response := TRequest.New.BaseURL(GetUrl('nfse/arquivo/pdf')).Get;

  if Response.StatusCode <> 200 then
  begin
    ShowMessage('Erro ao baixar o arquivo: ' + Response.Content);
    exit;
  end;

  Stream := TMemoryStream.create;

  try
    Stream.CopyFrom(Response.ContentStream, Response.ContentStream.Size);
    Stream.SaveToFile(FileName);
  finally
    Stream.Free;
  end;
end;

end.
