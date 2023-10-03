unit simplificado_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { ISimplificado }
  ISimplificado = interface
  end;

  { TSimplificado }
  TSimplificado = class(TInterfacedPersistent, ISimplificado)
  private
    FAliquotta: double;

  published
    property Aliquota: double read FAliquota write FAliquota;

  public
    class function New: ISimplificado;
  end;

implementation

{ TSimplificado }
class function TSimplificado.New: ISimplificado;
begin
  Result := self.Create;
end;

end.
