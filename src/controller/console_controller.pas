unit console_controller;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  DotEnv4Delphi, // Esta unit passara para a classe responsável pela leitura do .ENV
  Horse,
  Horse.Logger,
  Horse.Logger.Provider.Console,
  Horse.BasicAuthentication,
  Horse.CORS,
  Horse.Jhonson,
  Horse.Compression;

function DotEnvGet: integer;

implementation

var
  CurrentPath: string;
  { API Info }
  API_Name: string;
  API_Version: string;
  API_Port: integer;
  FileName: string;

  { .env VARS }
  DB_Host: string;
  DB_DataBase: string;
  DB_Port: integer;
  DB_Password: string;
  DB_User: string;
  DB_Driver: string;

  { ClientRequests HORSE }
  ClientRequests: THorseLoggerConsoleConfig;

function DotEnvGet: integer;
begin
  { .Env }
  CurrentPath := ExtractFilePath(ParamStr(0));
  FileName := CurrentPath + '.env';

  if not FileExists(FileName) then
  begin
    WriteLn('Arquivo de configuração não encontrado: ' + FileName);
    exit;
  end;

  DotEnv.Config(FileName, True);

  DB_Host := DotEnv.Env('DB_HOST');
  DB_DataBase := DotEnv.Env('DB_DATABASE');
  DB_Port := StrToInt(DotEnv.Env('DB_PORT'));
  DB_Password := DotEnv.Env('DB_PASSWORD');
  DB_User := DotEnv.Env('DB_USER');
  DB_Driver := DotEnv.Env('DB_DRIVER');

  API_Name := 'nfse_service';
  API_Version := 'v1';
  API_Port := StrToInt(DotEnv.Env('API_PORT'));

  Result:= API_Port;
end;

begin
  DotEnvGet;

  Writeln('----------------INFO-----------------');
  Writeln('Servidor ' + API_Name + ' - ' + API_Version);
  Writeln('Rodando na Porta: ' + IntToStr(API_Port) + sLineBreak);

  Writeln('--------------DATABASE---------------');
  Writeln('DRIVER: ' + DB_Driver);
  Writeln('HOST: ' + DB_Host);
  Writeln('DATABASE: ' + DB_DataBase);
  Writeln('PORT: ' + IntToStr(DB_Port));
  Writeln('USER: ' + DB_User);
  Writeln('PASSWORD: ' + DB_Password + sLineBreak);

  Writeln('---------------EXIT------------------');
  Writeln('Use Ctrl+C para interromper');

  { ClientRequests HORSE }
  ClientRequests := THorseLoggerConsoleConfig.New.SetLogFormat(
    '[${time}] ${request_clientip} ${response_status}');

  THorseLoggerManager.RegisterProvider(THorseLoggerProviderConsole.New());

  THorse
    .Use(CORS)
    .Use(Compression())
    .Use(Jhonson('utf-8'))
    .Use(THorseLoggerManager.HorseCallback);

end.
