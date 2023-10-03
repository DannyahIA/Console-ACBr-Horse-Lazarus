unit certificado_info_dto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils;

type
  { ICertificadoInfo }
  ICertificadoInfo = interface

  end;

  { TCertificadoInfo }
  TCertificadoInfo = class(TInterfacedObject, ICertificadoInfo)
  private
    FNumeroSerie: string;
    FRazaoSocial: string;
    FCnpj: string;
    FDataVencimento: TDate;
    FDiasVencimento: integer;
    FTipo: string;

  public
    property NumeroSerie: string read FNumeroSerie write FNumeroSerie;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property Cnpj: string read FCnpj write FCnpj;
    property DataVencimento: TDate read FDataVencimento write FDataVencimento;
    property DiasVencimento: integer read FDiasVencimento write FDiasVencimento;
    property Tipo: string read FTipo write FTipo;

    class function New: ICertificadoInfo;
  end;

implementation

{ TCertificadoInfo }
class function TCertificadoInfo.New: ICertificadoInfo;
begin
  Result := self.Create;
end;

end.
