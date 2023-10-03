unit certificado_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  DateUtils,

  { ACBr }
  blcksock,
  ACBrDFe,
  ACBrDFeSSL,
  ACBrDFeUtil,
  ACBrNFSeX,
  ACBrNFSeXConversao,
  pcnConversao;

type
  { ICertificadoDto }
  ICertificadoDto = interface
  end;

  { TCertificadoDto }
  TCertificadoDto = class(TInterfacedObject, ICertificadoDto)
  private
    FCnpj: string;
    FRazaoSocial: string;
    FNumeroSerie: string;
    FDataVencimento: TDate;
    FDiasVencimento: integer;
    FTipo: string;

  public
    property Cnpj: string read FCnpj write FCnpj;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property NumeroSerie: string read FNumeroSerie write FNumeroSerie;
    property DataVencimento: TDate read FDataVencimento write FDataVencimento;
    property DiasVencimento: integer read FDiasVencimento write FDiasVencimento;
    property Tipo: string read FTipo write FTipo;

    class function New: ICertificadoDto;
  end;

implementation

uses acbr_nfse_service;

{ TCertificadoDto }

class function TCertificadoDto.New: ICertificadoDto;
begin
  Result := self.Create;
end;

end.
