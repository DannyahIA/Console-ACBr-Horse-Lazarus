unit pis_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IPis }
  IPis = interface
  end;

  { TPis }
  TPis = class(TInterfacedPersistent, IPis)
  private
    FBaseCalculo: double;
    FAliquota: double;
    FValor: double;

  published
    property BaseCalculo: double read FBaseCalculo write FBaseCalculo;
    property Aliquota: double read FAliquota write FAliquota;
    property Valor: double read FValor write FValor;

  public
    class function New: IPis;
  end;

implementation

{ TPis }
class function TPis.New: IPis;
begin
  Result := self.Create;
end;

end.
