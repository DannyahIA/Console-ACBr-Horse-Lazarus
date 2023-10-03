unit nfse_dto;

// aqui deverá trocar por Modo Delphi e utilizar Generics no padrão do mesmo
{$mode Delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  Contnrs,
  fgl,
  Generics.Collections,
  endereco_dto,
  telefone_dto,
  valor_dto,
  deducao_dto,
  tomador_dto,
  prestador_dto,
  servico_dto,
  intermediario_dto;

{ Deducao2 }
type
  { IDeducao2 }
  IDeducao2 = interface
  end;

  { TDeducao2 }
  TDeducao2 = class(TInterfacedObject, IDeducao2)
    Forma: integer;
    Tipo: integer;
    NumeroNFReferencia: string;
    DataNFReferencia: string;
    ValorTotalReferencia: double;
    PercentualDeduzir: double;
    ValorDeduzir: double;
    RazoSocialReferencia: string;
    CpfCnpjReferencia: string;
  private

  public
    class function New: IDeducao2;
  end;

{ Item }
type
  { IItem }
  IItem = interface
  end;

  { TItem }
  TItem = class(TInterfacedObject, IItem)
    ItemId: string;
    Descricao: string;
    UnidadeId: string;
    Unidade: string;
    Quantidade: double;
    Valor: double;
  private

  public
    class function New: IItem;
  end;

  { TItemList }
  TItemList = TObjectList<TItem>;

{ CargaTributaria }
type
  { ICargaTributaria }
  ICargaTributaria = interface
  end;

  { TCargaTributaria }
  TCargaTributaria = class(TInterfacedObject, ICargaTributaria)
    fonte: string;
    percentual: double;
    Valor: double;
  private

  public
    class function New: ICargaTributaria;
  end;

{ Rps }
type
  { IRps }
  IRps = interface
  end;

  { TRps }
  TRps = class(TInterfacedObject, IRps)
    Competencia: string;
    DataEmissao: TDateTime;
    //DataVencimento: DTDateTime;
    Serie: string;
    Numero: integer;
  private

  public
    class function New: IRps;
  end;

{ Parcela }
type
  { IParcela }
  IParcela = interface
  end;

  { TParcela }
  TParcela = class(TInterfacedObject, IParcela)
    DataVencimento: TDate;
    Numero: integer;
    TipoPagamento: integer;
    Valor: double;
  private

  public
    class function New: IParcela;
  end;

  { TParcelaList }
  TParcelaList = TObjectList<TParcela>;

{ NFse }
type
  { INFse }
  INFSeDTO = interface
  end;

  { TNFse }
  TNFSeDTO = class(TInterfacedObject, INFSeDTO)
  private
    FIntegracaoID: string;
    FPrestador: TPrestador;
    FTomador: TTomador;
    FServico: TServico;
    FDeducao: TDeducao;
    FItens: TItemList;
    FCargaTributaria: TCargaTributaria;
    FDescricao: string;
    FEnviaEmail: boolean;
    FNotaSubstituidaId: string;
    FInformacoesComplementares: string;
    FIntermediario: TIntermediario;
    FNaturezaTributacao: integer;
    FRps: TRPs;
    FParcelas: TParcelaList;
  public //
    property IntegracaoId: string read FIntegracaoId write FIntegracaoId;
    property Tomador: TTomador read FTomador write FTomador;
    property Prestador: TPrestador read FPrestador write FPrestador;
    property Servico: TServico read FServico write FServico;
    property Deducao: TDeducao read FDeducao write FDeducao;
    property CargaTributaria: TCargaTributaria read FCargaTributaria write FCargaTributaria;
    property Descricao: string read FDescricao write FDescricao;
    property EnviaEmail: boolean read FEnviaEmail write FEnviaEmail;
    property NotaSubstituidaId: string read FNotaSubstituidaId write FNotaSubstituidaId;
    property InformacoesComplementares: string read FInformacoesComplementares write FInformacoesComplementares;
    property Intermediario: TIntermediario read FIntermediario write FIntermediario;
    property NaturezaTributacao: integer read FNaturezaTributacao write FNaturezaTributacao;
    property Rps: TRps read FRps write FRps;
    property Parcelas: TParcelaList read FParcelas write FParcelas;

    constructor Create;
    destructor Destroy; override;
    class function New: INFSeDTO;
  end;

implementation

constructor TNFSeDTO.Create;
begin
  FTomador := TTomador.Create;
  FPrestador := TPrestador.Create;
  FServico := TServico.Create;
end;


destructor TNFSeDTO.Destroy;
begin
  inherited Destroy;
  FTomador.Free;
  FPrestador.Free;
  FServico.Free;
end;

{ TDeducao2 }
class function TDeducao2.New: IDeducao2;
begin
  Result := self.Create;
end;

{ TItem }
class function TItem.New: IItem;
begin
  Result := self.Create;
end;

{ TCargaTributaria }
class function TCargaTributaria.New: ICargaTributaria;
begin
  Result := self.Create;
end;

{ TRps }
class function TRps.New: IRps;
begin
  Result := self.Create;
end;

{ TParcela }
class function TParcela.New: IParcela;
begin
  Result := self.Create;
end;

{ TNfse }
class function TNFSeDTO.New: INFSeDTO;
begin
  Result := self.Create;
end;

end.
