unit nfse_health_controller;

{$IF DEFINED(FPC)}
   {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Classes,
  SysUtils,
  Horse;

procedure Registry;
procedure GetHealth(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure GetHealth(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Ok');
  Res.Status(200);
end;

procedure Registry;
begin
  THorse
  .Get('health', GetHealth);
end;

end.
