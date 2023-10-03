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
  TCpp = class(TInterfacedPersistent, ICpp)
  private
    FAliquota: double;
    FValor: double;

  published
    property Aliquota: double read FAliquota write FAliquota;
    property Valor: double read FValor write FValor;

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
