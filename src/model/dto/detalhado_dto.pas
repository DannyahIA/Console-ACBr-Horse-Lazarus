unit detalhado_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IDetalhado }
  IDetalhado = interface
  end;

  { TDetalhado }
  TDetalhado = class(TInterfacedPersistent, IDetalhado)
  private
    FAliquota: double;

  published
    property Aliquota: double read FAliquota write FAliquota;

  public
    class function New: IDetalhado;
  end;

implementation

{ TDetalhado }
class function TDetalhado.New: IDetalhado;
begin
  Result := self.Create;
end;

end.
