unit retencao_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  ibpt_dto,
  pis_dto,
  confins_dto,
  csll_dto,
  inss_dto,
  irrf_dto,
  cpp_dto;

type
  { IRetencao }
  IRetencao = interface
  end;

  { TRetencao }
  TRetencao = class(TInterfacedObject, IRetencao)
    Pis: TPis;
    Confins: TConfins;
    Csll: TCsll;
    Inss: TInss;
    Irrf: TIrrf;
    OutrasRetencoes: double;
    Cpp: TCpp;
    Tributavel: boolean;
    Ibpt: TIbpt;
    ResponsavelRetencao: string;
  private

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IRetencao;
  end;

implementation

constructor TRetencao.Create;
begin
  Pis:= TPis.Create;
  Confins:= TConfins.Create;
  Csll:= TCsll.Create;
  Inss:= TInss.Create;
  Irrf:= TIrrf.Create;
  Cpp:= TCpp.Create;
  Ibpt:= TIbpt.Create;
end;

destructor TRetencao.Destroy;
begin
  inherited Destroy;
  Pis.Free;
  Confins.Free;
  Csll.Free;
  Inss.Free;
  Irrf.Free;
  Cpp.Free;
  Ibpt.Free;
end;

{ TRetencao }
class function TRetencao.New: IRetencao;
begin
  Result := self.Create;
end;

end.
