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
  TValor = class(TInterfacedPersistent, IValor)
  private
    FServico: double;
    FBaseCalculo: double;
    FDeducoes: double;
    FDescontoCondicionado: double;
    FDescontoIncondicionado: double;
    FLiquido: double;
    FUnitario: double;

  published
    property Servico: double read FServico write FServico;
    property BaseCalculo: double read FBaseCalculo write FBaseCalculo;
    property Deducoes: double read FDeducoes write FDeducoes;
    property DescontoCondicionado: double read FDescontoCondicionado write FDescontoCondicionado;
    property DescontoIncondicionado: double read FDescontoIncondicionado write FDescontoIncondicionado;
    property Liquido: double read FLiquido write FLiquido;
    property Unitario: double read FUnitario write FUnitario;

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
