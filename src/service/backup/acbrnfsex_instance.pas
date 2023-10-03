unit acbrnfsex_instance;

{$mode Delphi}

interface

uses
  Classes, SysUtils;

type

  { TAcbrNfseXInstance }

  TAcbrNfseXInstance = class
  private
    FACBrNFSeX: TACBrNFSeX;
  public
    function GetInstance(cnpj: string): TACBRNFSEX;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TAcbrNfseXInstance }

constructor TAcbrNfseXInstance.Create;
begin
  inherited Create;
  FACBrNFSeX := TACBrNFSeX.Create(nil);
end;

destructor TAcbrNfseXInstance.Destroy;
begin
  FAcbrNFSEx.Free;
  inherited Destroy;
end;

function TAcbrNfseXInstance.GetInstance(cnpj: string): TACBRNFSEX;
begin
  try
    FACBrNFSeX.Configuracoes.Geral.SSLLib := TSSLLib.libWinCrypt;
    FACBrNFSeX.SSL.SSLType := TSSLType.LT_TLSv1_2;

    // Configura o Certificado
    FACBrNFSeX.Configuracoes.Certificados.ArquivoPFX :=
      ExtractFilePath(ParamStr(0)) + 'certificados\' + cnpj + '.pfx';

    FACBrNFSeX.Configuracoes.Certificados.Senha := 'ED120971';
  except
    on E: Exception do
    begin
      Result := 'Error' + E.Message;
    end;
  end;

end;



end.
