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
  TIbpt = class(TInterfacedPersistent, IIbpt)
  private
    FSimplificado: TSimplificado;
    FDetalhado: TDetalhado;

  published
    property Simplificado: TSimplificado read FSimplificado write FSimplificado;
    property Detalhado: TDetalhado read FDetalhado write FDetalhado;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IIbpt;
  end;

implementation

constructor TIbpt.Create;
begin
  Simplificado := TSimplificado.Create;
  Detalhado := TDetalhado.Create;
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
