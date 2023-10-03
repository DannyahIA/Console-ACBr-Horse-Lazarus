unit tomador_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  endereco_dto,
  telefone_dto;

type
  { ITomador }
  ITomador = interface
  end;

  { TTomador }
  TTomador = class(TInterfacedPersistent, ITomador)
  private
    FCpfCnpj: string;
    FRazaoSocial: string;
    FEndereco: TEndereco;
    FEmail: string;
    FInscricaoEstadual: string;
    FInscricaoMunicipal: string;
    FInscricaoSuframa: string;
    FNomeFantasia: string;
    FOrgaoPublico: boolean;
    FTelefone: TTelefone;
    FIndicadorInscricaoEstadual: integer; //default 9
    FCodigoEstrangeiro: string;

    procedure SetDefaultValues;
  published
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property Endereco: TEndereco read FEndereco write FEndereco;
    property Email: string read FEmail write FEmail;
    property InscricaoEstadual: string read FInscricaoEstadual write FInscricaoEstadual;
    property InscricaoMunicipal: string read FInscricaoMunicipal
      write FInscricaoMunicipal;
    property InscricaoSuframa: string read FInscricaoSuframa write FInscricaoSuframa;
    property NomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property OrgaoPublico: boolean read FOrgaoPublico write FOrgaoPublico;
    property Telefone: TTelefone read FTelefone write FTelefone;
    property IndicadorInscricaoEstadual: integer
      read FIndicadorInscricaoEstadual write FIndicadorInscricaoEstadual;
    property CodigoEstrangeiro: string read FCodigoEstrangeiro write FCodigoEstrangeiro;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: ITomador;
  end;

implementation

procedure TTomador.SetDefaultValues;
begin
  FIndicadorInscricaoEstadual := 9;
end;

{ TTomador }
constructor TTomador.Create;
begin
  FEndereco := TEndereco.Create;
  FTelefone := TTelefone.Create;

end;

destructor TTomador.Destroy;
begin
  inherited Destroy;
  FEndereco.Free;
  FTelefone.Free;
end;

class function TTomador.New: ITomador;
begin
  Result := self.Create;
end;

end.
