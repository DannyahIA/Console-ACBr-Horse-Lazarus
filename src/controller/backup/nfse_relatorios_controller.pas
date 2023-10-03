unit nfse_relatorios_controller;

{$IF DEFINED(FPC)}
   {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Classes,
  SysUtils,
  Horse;

procedure Registry;
procedure GetRelatorios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure GetRelatorios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Relatorios OK');
  Res.Status(200);
end;

procedure Registry;
begin
  THorse
    .Get('geral/relatorios', GetRelatorios);
end;

end.
