unit cpp_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { ICpp }
  ICpp = interface
  end;

  { TCpp }
  TCpp = class(TInterfacedObject, ICpp)
    Aliquota: double;
    Valor: double;
  private

  public
    class function New: ICpp;
  end;

implementation

{ TCpp }
class function TCpp.New: ICpp;
begin
  Result := self.Create;
end;

end.
