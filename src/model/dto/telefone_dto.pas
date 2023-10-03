unit telefone_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { ITelefone }
  ITelefone = interface
  end;

  { TTelefone }
  TTelefone = class(TInterfacedPersistent, ITelefone)
  private
    FDDD: string;
    FNumero: string;

  published
    property DDD: string read FDDD write FDDD;
    property Numero: string read FNumero write FNumero;

  public
    class function New: ITelefone;
  end;

implementation

{ TTelefone }
class function TTelefone.New: ITelefone;
begin
  Result := self.Create;
end;

end.
