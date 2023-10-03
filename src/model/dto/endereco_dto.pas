unit endereco_dto;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils;

type

  { IEndereco }
  IEndereco = interface

  end;

  { TEndereco }
  TEndereco = class(TInterfacedPersistent, IEndereco)
  private
    FBairro: string;
    FCep: string;
    FCodigoCidade: string;
    FUF: string;
    FLogradouro: string;
    FNumero: string;
    FCodigoPais: string; //default "1058"
    FComplemento: string;
    FDescricaoCidade: string;
    FDescricaoPais: string; //default "Brasil"

    procedure defaultValues;
  published
    property Bairro: string read FBairro write FBairro;
    property Cep: string read FCep write FCep;
    property CodigoCidade: string read FCodigoCidade write FCodigoCidade;
    property UF: string read FUF write FUF;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
    property CodigoPais: string read FCodigoPais write FCodigoPais;
    property Complemento: string read FComplemento write FComplemento;
    property DescricaoCidade: string read FDescricaoCidade write FDescricaoCidade;
    property DescricaoPais: string read FDescricaoPais write FDescricaoPais;

  public
    class function New: IEndereco;
  end;

implementation

{ TEndereco }

procedure TEndereco.defaultValues;
begin
  CodigoPais := '1058';
  DescricaoPais := 'Brasil';
end;

class function TEndereco.New: IEndereco;
begin
  Result := self.Create;
end;

end.
