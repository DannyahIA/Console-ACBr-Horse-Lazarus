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
  TPis = class(TInterfacedObject, IPis)
    BaseCalculo: double;
    Aliquota: double;
    Valor: double;
  private

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
