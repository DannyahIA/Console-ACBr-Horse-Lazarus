unit nfse_webhook_controller;

{$IF DEFINED(FPC)}
   {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Classes,
  SysUtils,
  Horse;

procedure Registry;
procedure GetWebhook(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure GetWebhook(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Webhook Ok');
  Res.Status(200);
end;

procedure Registry;
begin
  THorse
    .Get('geral/webhook', GetWebhook);
end;

end.
