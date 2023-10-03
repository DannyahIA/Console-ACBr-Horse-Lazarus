unit prestador_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  endereco_dto,
  telefone_dto;

type
  { IPrestador }
  IPrestador = interface
  end;

  { TPrestador }
  TPrestador = class(TInterfacedObject, IPrestador)
  private
    FCpfCnpj: string;
    FRazaoSocial: string;
    FEndereco: TEndereco;
    FEmail: string;
    FInscricaoEstadual: string;
    FInscricaoMunicipal: string;
    FInscricaoSuframa: string;
    FNomeFantasia: string;
    FTelefone: TTelefone;
    FIncentivadorCultural: boolean;
    FIncentivoFiscal: boolean;
    FCodigoEstrangeiro: string;
    FRegimeTributario: integer;
    FRegimeTributarioEspecial: integer;
    FSimplesNacional: boolean;
    FCodigoDistrito: integer;

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
    property Telefone: TTelefone read FTelefone write FTelefone;
    property CodigoEstrangeiro: string read FCodigoEstrangeiro write FCodigoEstrangeiro;
    property IncentivadorCultural: boolean read FIncentivadorCultural
      write FIncentivadorCultural;
    property IncentivoFiscal: boolean read FIncentivoFiscal write FIncentivoFiscal;
    property RegimeTributario: integer read FRegimeTributario write FRegimeTributario;
    property RegimeTributarioEspecial: integer
      read FRegimeTributarioEspecial write FRegimeTributarioEspecial;
    property SimplesNacional: boolean read FSimplesNacional write FSimplesNacional;
    property CodigoDistrito: integer read FCodigoDistrito write FCodigoDistrito;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IPrestador;
  end;

implementation

{ TPrestador }
constructor TPrestador.Create;
begin
  Endereco := TEndereco.Create;
  Telefone := TTelefone.Create;

end;

destructor TPrestador.Destroy;
begin
  inherited Destroy;
  Endereco.Free;
  Telefone.Free;
end;

class function TPrestador.New: IPrestador;
begin
  Result := self.Create;
end;

end.
