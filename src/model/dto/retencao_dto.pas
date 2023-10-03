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
  TRetencao = class(TInterfacedPersistent, IRetencao)
  private
    FPis: TPis;
    FConfins: TConfins;
    FCsll: TCsll;
    FInss: TInss;
    FIrrf: TIrrf;
    FOutrasRetencoes: double;
    FCpp: TCpp;
    FTributavel: boolean;
    FIbpt: TIbpt;
    FResponsavelRetencao: string;

  published
    property Pis: TPis read FPis write FPis;
    property Confins: TConfins read FConfins write FConfins;
    property Csll: TCsll read FCsll write FCsll;
    property Inss: TInss read FInss write FInss;
    property Irrf: TIrrf read FIrrf write FIrrf;
    property OutrasRetencoes: double read FOutrasRetencoes write FOutrasRetencoes;
    property Cpp: TCpp read FCpp write FCpp;
    property Tributavel: boolean read FTributavel write FTributavel;
    property Ibpt: TIbpt read FIbpt write FIbpt;
    property ResponsavelRetencao: string read FResponsavelRetencao write FResponsavelRetencao;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IRetencao;
  end;

implementation

constructor TRetencao.Create;
begin
  Pis := TPis.Create;
  Confins := TConfins.Create;
  Csll := TCsll.Create;
  Inss := TInss.Create;
  Irrf := TIrrf.Create;
  Cpp := TCpp.Create;
  Ibpt := TIbpt.Create;
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
