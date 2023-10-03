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
  TIntermediario = class(TInterfacedObject, IIntermediario)
    CpfCnpj: string;
    RazaoSocial: string;
    InscricaoMunicipal: string;
    Endereco: TEndereco;
  private

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
