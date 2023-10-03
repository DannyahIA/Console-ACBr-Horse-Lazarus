program nfse_service;

{$IF DEFINED(FPC)}
   {$MODE DELPHI}{$H+}
{$ENDIF}

uses
 {$IFDEF UNIX}
     {$IFDEF UseCThreads}
         cthreads,
            {$ENDIF}
        {$ENDIF}
  fpjson,
  SysUtils,
  Classes,

  // Horse and Middlewares
  Horse,
  Horse.BasicAuthentication,
  Horse.CORS,
  Horse.Jhonson,
  Horse.Compression,
  Horse.OctetStream,

  // Controllers
  nfse_controller,
  nfse_certificado_controller,
  nfse_health_controller,
  nfse_quit_controller,
  nfse_getfake_controller,
  nfse_empresa_controller,
  nfse_relatorios_controller,
  nfse_webhook_controller,
  console_controller,

  // Services
  nfse_acbr_service,
  endereco_dto,
  telefone_dto,
  tomador_dto,
  prestador_dto,
  valor_dto,
  servico_dto,
  iss_dto,
  obra_dto,
  deducao_dto,
  retencao_dto,
  ibpt_dto,
  detalhado_dto,
  simplificado_dto,
  pis_dto,
  confins_dto,
  csll_dto,
  inss_dto,
  irrf_dto,
  cpp_dto,

  //SDK
  json_nfsedto_adapter,
  nfsedto_acbrnfse_adapter,
  nfse_valid_json,
  certificado_dto,
  nfse_cancelamento_dto, acbrnfsex_instance;

var
  CurrentPath: string;

  procedure ShowStatus();
  begin

  end;

begin
  { Memory Leak Dump }
  CurrentPath := ExtractFilePath(ParamStr(0));
  //SetHeapTraceOutput(CurrentPath + 'MemoryLeak.log');

  THorse
    .Use(CORS)
    .Use(Compression())
    .Use(Jhonson('utf-8'))
    .Use(OctetStream);

  // Route Registers
  nfse_controller.Registry;
  nfse_certificado_controller.Registry;
  nfse_health_controller.Registry;
  nfse_getfake_controller.Registry;
  nfse_empresa_controller.Registry;
  nfse_relatorios_controller.Registry;
  nfse_webhook_controller.Registry;
  nfse_quit_controller.Registry;

  THorse.Listen(DotEnvGet, ShowStatus);
  begin

  end;

  //DumpHeap;
end.
