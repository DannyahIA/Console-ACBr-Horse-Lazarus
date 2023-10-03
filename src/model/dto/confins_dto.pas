unit confins_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IConfins }
  IConfins = interface
  end;

  { TConfins }
  TConfins = class(TInterfacedPersistent, IConfins)
  private
    FBaseCalculo: double;
    FAliquota: double;
    FValor: double;

  published
    property BaseCalculo: double read FBaseCalculo write FBaseCalculo;
    property Aliquota: double read FAliquota write FAliquota;
    property Valor: double read FValor write FValor;

  public
    class function New: IConfins;
  end;

implementation

{ TConfins }
class function TConfins.New: IConfins;
begin
  Result := self.Create;
end;

end.
