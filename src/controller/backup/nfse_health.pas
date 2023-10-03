unit nfse_health;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  Horse,
  Horse.Commons;

  procedure Health(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

              procedure Health(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
  begin
    Res.Send('Ok');
    Res.Status(200);
  end;

end.

