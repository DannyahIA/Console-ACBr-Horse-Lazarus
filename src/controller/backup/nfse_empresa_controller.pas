unit nfse_empresa_controller;

{$IF DEFINED(FPC)}
   {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Classes,
  SysUtils,
  Horse; //Verificar se Horse.Commons é necessario

procedure Registry;
procedure GetEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure GetEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Empresa Ok');
  Res.Status(200);
end;

procedure Registry;
begin
  THorse
    .Get('geral/empresa', GetEmpresa);
end;

end.
