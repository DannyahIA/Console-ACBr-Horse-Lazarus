unit irrf_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IIrrf }
  IIrrf = interface
  end;

  { TIrrf }
  TIrrf = class(TInterfacedPersistent, IIrrf)
  private
    FAliquota: double;
    FValor: double;

    published
      property Aliquota: double read FAliquota write FAliquota;
      property Valor: double read FValor write FValor;

  public
    class function New: IIrrf;
  end;

implementation

{ TIrrf }
class function TIrrf.New: IIrrf;
begin
  Result := self.Create;
end;

end.
