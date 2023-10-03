unit valor_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IValor }
  IValor = interface
  end;

  { TValor }
  TValor = class(TInterfacedObject, IValor)
    Servico: double;
    BaceCalculo: double;
    Deducoes: double;
    DescontoCondicionado: double;
    DescontoIncondicionado: double;
    Liquido: double;
    Unitario: double;
  private

  public
    class function New: IValor;
  end;

implementation

{ TValor }
class function TValor.New: IValor;
begin
  Result := self.Create;
end;

end.
