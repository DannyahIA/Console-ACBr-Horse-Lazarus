unit intermediario_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  endereco_dto;

type
  { IIntermediario }
  IIntermediario = interface
  end;

  { TIntermediario }
  TIntermediario = class(TInterfacedPersistent, IIntermediario)
  private
    FCpfCnpj: string;
    FRazaoSocial: string;
    FInscricaoMunicipal: string;
    FEndereco: TEndereco;

  published
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property Endereco: TEndereco read FEndereco write FEndereco;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IIntermediario;
  end;

implementation

{ TIntermediario }

constructor TIntermediario.Create;
begin
  Endereco := TEndereco.Create;
end;

destructor TIntermediario.Destroy;
begin
  inherited Destroy;
  Endereco.Free;
end;

class function TIntermediario.New: IIntermediario;
begin
  Result := self.Create;
end;

end.
