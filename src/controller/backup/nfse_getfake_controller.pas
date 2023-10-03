unit nfse_getfake_controller;

{$IF DEFINED(FPC)}
   {$MODE DELPHI}{$H+}
{$ENDIF}


interface

uses
  Classes,
  SysUtils,
  Horse;

procedure Registry;
procedure GetFake(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure GetFake(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('GetFake');
  Res.Status(200);
end;

procedure Registry;
begin
  THorse
    .Get('getfake', GetFake);
end;

end.
