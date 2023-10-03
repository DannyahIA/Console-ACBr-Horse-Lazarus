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
  TIrrf = class(TInterfacedObject, IIrrf)
    Aliquota: double;
    Valor: double;
  private

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
