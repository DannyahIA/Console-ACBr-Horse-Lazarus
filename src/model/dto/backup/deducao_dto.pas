unit deducao_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IDeducao }
  IDeducao = interface
  end;

  { TDeducao }
  TDeducao = class(TInterfacedObject, IDeducao)
    Tipo: integer;
    Descricao: string;
  private

  public
    class function New: IDeducao;
  end;

implementation

{ TDeducao }
class function TDeducao.New: IDeducao;
begin
  Result := self.Create;
end;

end.
