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
  TEndereco = class(TInterfacedObject, IEndereco)
    Bairro: string;
    Cep: string;
    CodigoCidade: string;
    UF: string;
    Logradouro: string;
    Numero: string;
    CodigoPais: string; //default "1058"
    Complemento: string;
    DescricaoCidade: string;
    DescricaoPais: string; //default "Brasil"
  private
    procedure defaultValues;
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
