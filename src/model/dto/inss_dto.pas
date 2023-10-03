unit inss_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IInss }
  IInss = interface
  end;

  { TInss }
  TInss = class(TInterfacedPersistent, IInss)
  private
    FAliquota: double;
    FValor: double;

  published
    property Aliquota: double read FAliquota write FAliquota;
    property Valor: double read FValor write FValor;

  public
    class function New: IInss;
  end;

implementation

{ TInss }
class function TInss.New: IInss;
begin
  Result := self.Create;
end;

end.
