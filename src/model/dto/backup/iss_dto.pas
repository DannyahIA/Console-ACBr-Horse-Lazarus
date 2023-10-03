unit iss_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IIss }
  IIss = interface
  end;

  { TIss }
  TIss = class(TInterfacedPersistent, IIss)
  private
    FTipoTributacao: integer;
    FExigibilidade: integer;
    FRetido: boolean;
    FAliquota: double;
    FValor: double;
    FValorRetido: double;
    FProcessoSuspensao: string;

    published
      property TipoTibutacao: integer read FTipoTributacao write FTipoTributacao;
      property Exigibilidade: integer read FExigibilidade write FExigibilidade;
      property Retido: boolean read FRetido write FRetido;
      property Aliquota: double read FAliquota write FAliquota;
      property Valor: double read FValor write FValor;
      property ValorRetido: double read FValorRetido write FValorRetido;
      property ProcessoSuspensao: string read FProcessoSuspensao write FProcessoSuspensao;

  public
    class function New: IIss;
  end;

implementation

{ TIss }
class function TIss.New: IIss;
begin
  Result := self.Create;
end;

end.
