unit ibpt_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  simplificado_dto,
  detalhado_dto;

type
  { IIbpt }
  IIbpt = interface
  end;

  { TIbpt }
  TIbpt = class(TInterfacedObject, IIbpt)
    Simplificado: TSimplificado;
    Detalhado: TDetalhado;
  private

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IIbpt;
  end;

implementation

constructor TIbpt.Create;
begin
  Simplificado:= TSimplificado.Create;
  Detalhado:= TDetalhado.Create;
end;

destructor TIbpt.Destroy;
begin
  inherited Destroy;
  Simplificado.Free;
  Detalhado.Free;
end;

{ TIbpt }
class function TIbpt.New: IIbpt;
begin
  Result := self.Create;
end;

end.
