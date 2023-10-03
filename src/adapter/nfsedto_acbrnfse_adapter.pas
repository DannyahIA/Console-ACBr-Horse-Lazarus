unit nfsedto_acbrnfse_adapter;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  nfse_dto,
  ACBrNFSeX,
  ACBrNFSeXConversao,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXDANFSeClass;

type
  INfseDtoAcbrNfseAdapter = interface
    { DTO TO ACBR }
    procedure NFSeDtoToAcbrNFSe(nfseDTO: TNFSeDTO; acbrNfse: TACBRNFSeX);

  end;

  TNfseDtoAcbrNfseAdapter = class(TInterfacedObject, INfseDtoAcbrNfseAdapter)
  private

  public
    { DTO TO ACBR }
    procedure NFSeDtoToAcbrNFSe(nfseDTO: TNFSeDTO; acbrNfse: TACBRNFSeX);

  end;

implementation

{ DTO TO ACBR }
procedure TNfseDtoAcbrNfseAdapter.NFSeDtoToAcbrNFSe(nfseDTO: TNFSeDTO;
  acbrNfse: TACBRNFSeX);
begin
  with acbrNFSe.NotasFiscais[0].Nfse.Tomador do
  begin
    Contato.DDD := nfseDTO.Tomador.Telefone.DDD;
    Contato.Telefone := nfseDTO.Tomador.Telefone.Numero;
    Contato.Email := nfseDTO.Tomador.Email;
    Endereco.Bairro := nfseDTO.Tomador.Endereco.Bairro;
    Endereco.CEP := nfseDTO.Tomador.Endereco.Cep;
    Endereco.Endereco := nfseDTO.Tomador.Endereco.Logradouro;
    Endereco.CodigoMunicipio := nfseDTO.Tomador.Endereco.CodigoCidade;
    Endereco.CodigoPais := StrToInt(nfseDTO.Tomador.Endereco.CodigoPais);
    Endereco.Complemento := nfseDTO.Tomador.Endereco.Complemento;
    Endereco.Numero := nfseDTO.Tomador.Endereco.Numero;
    Endereco.UF := nfseDTO.Tomador.Endereco.UF;
    Endereco.xMunicipio := nfseDTO.Tomador.Endereco.DescricaoCidade;
    Endereco.xPais := nfseDTO.Tomador.Endereco.DescricaoPais;
    NomeFantasia := nfseDTO.Tomador.NomeFantasia;
    RazaoSocial := nfseDTO.Tomador.RazaoSocial;
    IdentificacaoTomador.CpfCnpj := nfseDTO.Tomador.CpfCnpj;
    IdentificacaoTomador.InscricaoEstadual := nfseDTO.Tomador.InscricaoEstadual;
    IdentificacaoTomador.InscricaoMunicipal := nfseDTO.Tomador.InscricaoMunicipal;
    IdentificacaoTomador.DocEstrangeiro := nfseDTO.Tomador.CodigoEstrangeiro;
  end;

  with acbrNFSe.NotasFiscais[0].Nfse.Prestador do
  begin
    Contato.DDD := nfseDTO.Prestador.Telefone.DDD;
    Contato.Telefone := nfseDTO.Prestador.Telefone.Numero;
    Contato.Email := nfseDTO.Prestador.Email;
    Endereco.Bairro := nfseDTO.Prestador.Endereco.Bairro;
    Endereco.CEP := nfseDTO.Prestador.Endereco.Cep;
    Endereco.Endereco := nfseDTO.Prestador.Endereco.Logradouro;
    Endereco.CodigoMunicipio := nfseDTO.Prestador.Endereco.CodigoCidade;
    Endereco.CodigoPais := StrToInt(nfseDTO.Prestador.Endereco.CodigoPais);
    Endereco.Complemento := nfseDTO.Prestador.Endereco.Complemento;
    Endereco.Numero := nfseDTO.Prestador.Endereco.Numero;
    Endereco.UF := nfseDTO.Prestador.Endereco.UF;
    Endereco.xMunicipio := nfseDTO.Prestador.Endereco.DescricaoCidade;
    Endereco.xPais := nfseDTO.Prestador.Endereco.DescricaoPais;
    NomeFantasia := nfseDTO.Prestador.NomeFantasia;
    RazaoSocial := nfseDTO.Prestador.RazaoSocial;
    IdentificacaoPrestador.CpfCnpj := nfseDTO.Prestador.CpfCnpj;
    IdentificacaoPrestador.Cnpj := nfseDTO.Prestador.CpfCnpj;
    IdentificacaoPrestador.InscricaoEstadual := nfseDTO.Prestador.InscricaoEstadual;
    IdentificacaoPrestador.InscricaoMunicipal := nfseDTO.Prestador.InscricaoMunicipal;
    IdentificacaoPrestador.DocEstrangeiro := nfseDTO.Prestador.CodigoEstrangeiro;
  end;

  with acbrNFSe.NotasFiscais[0].Nfse.Servico.Valores do
  begin
    BaseCalculo := nfseDTO.Servico.Valor.BaseCalculo;
    DescontoCondicionado := nfseDTO.Servico.Valor.DescontoCondicionado;
    DescontoIncondicionado := nfseDTO.Servico.Valor.DescontoIncondicionado;
    ValorDeducoes := nfseDTO.Servico.Valor.Deducoes;
    ValorLiquidoNfse := nfseDTO.Servico.Valor.Liquido;
  end;
end;

end.
