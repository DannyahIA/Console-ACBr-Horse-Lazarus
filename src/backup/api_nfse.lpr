program api_nfse;

{$MODE DELPHI}{$H+}

uses
{$IFDEF UNIX}
{$IFDEF UseCThreads}
 cthreads,
{$ENDIF}
{$ENDIF}
 Horse,
 SysUtils,
 fpjson;

 procedure GetFake(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
 begin
   Res.Send('FOII');
   Res.Status(200);
 end;

 procedure Health(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
 begin
   Res.Send('Ok');
   Res.Status(200);
 end;

var

 ApiName: string;
 ApiVersion: string;
 ApiPort: integer;

begin

 ApiName := 'api_nfse';
 ApiVersion := 'v1';
 ApiPort := 9000;

 // It's necessary to add the middleware in the Horse:
 // THorse.Use(HorseBasicAuthentication(DoLogin));

 // The default header for receiving credentials is "Authorization".
 // You can change, if necessary:
 // THorse.Use(HorseBasicAuthentication(MyCallbackValidation, THorseBasicAuthenticationConfig.New.Header('X-My-Header-Authorization')));

 // You can also ignore routes:
 //THorse.Use(HorseBasicAuthentication(MyCallbackValidation, THorseBasicAuthenticationConfig.New.SkipRoutes(['/ping'])));

 THorse
   .Group.Prefix(ApiName + '/' + ApiVersion)
   .Get('certificado', GetFake)
   .Get('empresa', GetFake)
   .Get('nfse', GetFake)
   .Get('relatorios', GetFake)
   .Get('webhook', GetFake)
   .Get('health', Health);

 // Carrega as rotas
 // Registry(THorse, apiInfo);

 // Mostra informações do servidor
 WriteLn('-------------------------------------');
 WriteLn('Servidor ' + ApiName + ' - ' + ApiVersion);
 WriteLn('Rodando na porta: ' + IntToStr(ApiPort));
 Writeln('Use Ctrl+C para interromper');
 WriteLn('-------------------------------------');

 THorse.Listen(9000);

 end.
