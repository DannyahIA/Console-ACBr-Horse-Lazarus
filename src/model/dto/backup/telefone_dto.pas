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
  TTelefone = class(TInterfacedObject, ITelefone)
    DDD: string;
    Numero: string;
  private

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
