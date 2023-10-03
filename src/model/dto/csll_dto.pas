unit csll_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { ICsll }
  ICsll = interface
  end;

  { TCsll }
  TCsll = class(TInterfacedPersistent, ICsll)
  private
    FAliquota: double;
    FValor: double;

  published
    property Aliquota: double read FAliquota write FAliquota;
    property Valor: double read FValor write FValor;

  public
    class function New: ICsll;
  end;

implementation

{ TCsll }
class function TCsll.New: ICsll;
begin
  Result := self.Create;
end;

end.
