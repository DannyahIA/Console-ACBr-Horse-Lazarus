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
  TDetalhado = class(TInterfacedObject, IDetalhado)
    Aliquota: double;
  private

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

