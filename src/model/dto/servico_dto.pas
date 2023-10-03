unit servico_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  valor_dto,
  retencao_dto,
  ibpt_dto,
  deducao_dto,
  iss_dto,
  obra_dto;

type
  { IServico }
  IServico = interface
  end;

  { TServico }
  TServico = class(TInterfacedObject, IServico)
  private
    FCodigo: string;
    FIntegracaoId: string;
    FDiscriminacao: string;
    FCodigoTributacao: string;
    FCnae: string;
    FCodigoCidadeIncidencia: string;
    FDescricaoCidadeIncidencia: string;
    FUnidade: string;
    FQuantidade: double;
    FIss: TIss;
    FObra: TObra;
    FValor: TValor;
    FDeducao: TDeducao;
    FRetencao: TRetencao;
    FTributavel: boolean;
    FIbpt: TIbpt;
    FResponsavelRetencao: string;

  published
    property Codigo: string read FCodigo write FCodigo;
    property IntegracaoId: string read FIntegracaoId write FIntegracaoId;
    property Discriminacao: string read FDiscriminacao write FDiscriminacao;
    property CodigoTributacao: string read FCodigoTributacao write FCodigoTributacao;
    property Cnae: string read FCnae write FCnae;
    property CodigoCidadeIncidencia: string
      read FCodigoCidadeIncidencia write FCodigoCidadeIncidencia;
    property DescricaoCidadeIncidencia: string
      read FDescricaoCidadeIncidencia write FDescricaoCidadeIncidencia;
    property Unidade: string read FUnidade write FUnidade;
    property Quantidade: double read FQuantidade write FQuantidade;
    property Iss: TIss read FIss write FIss;
    property Obra: TObra read FObra write FObra;
    property Valor: TValor read FValor write FValor;
    property Deducao: TDeducao read FDeducao write FDeducao;
    property Retencao: TRetencao read FRetencao write FRetencao;
    property Tributavel: boolean read FTributavel write FTributavel;
    property Ibpt: TIbpt read FIbpt write FIbpt;
    property ResponsavelRetencao: string read FResponsavelRetencao
      write FResponsavelRetencao;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IServico;

  end;


implementation

{ TServico }
constructor TServico.Create;
begin
  Valor := TValor.Create;
  Ibpt := TIbpt.Create;
  Retencao := TRetencao.Create;
  Deducao := TDeducao.Create;
  Iss := TIss.Create;
  Obra := TObra.Create;

end;

destructor TServico.Destroy;
begin
  inherited Destroy;
  Valor.Free;
  Ibpt.Free;
  Retencao.Free;
  Deducao.Free;
  Iss.Free;
  Obra.Free;

end;

class function TServico.New: IServico;
begin
  Result := self.Create;
end;

end.
