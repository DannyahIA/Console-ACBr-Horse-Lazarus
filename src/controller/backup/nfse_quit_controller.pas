unit nfse_quit_controller;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  Horse;

procedure Registry;
procedure GetQuit(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure GetQuit(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Server Shutdown');
  Res.Status(200);
end;

procedure Registry;
begin
  THorse
  .Get('quit', GetQuit);
end;

end.
