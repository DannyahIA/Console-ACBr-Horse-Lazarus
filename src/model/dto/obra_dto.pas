unit obra_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type
  { IObra }
  IObra = interface
  end;

  { TObra }
  TObra = class(TInterfacedPersistent, IObra)
  private
    FArt: string;
    FCodigo: string;
    FCei: string;

  published
    property Art: string read FArt write FArt;
    property Codigo: string read FCodigo write FCodigo;
    property Cei: string read FCei write FCei;

  public
    class function New: IObra;
  end;

implementation

{ TObra }
class function TObra.New: IObra;
begin
  Result := self.Create;
end;

end.
