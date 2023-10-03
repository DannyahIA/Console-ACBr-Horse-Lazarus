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
  TDeducao = class(TInterfacedPersistent, IDeducao)
  private
    FTipo: integer;
    FDescricao: string;

  published
    property Tipo: integer read FTipo write FTipo;
    property Descricao: string read FDescricao write FDescricao;

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
