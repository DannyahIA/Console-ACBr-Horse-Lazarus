unit json_nfsedto_adapter;

{$mode Delphi}{$H+}

interface

uses
  Classes,
  SysUtils,

  //JSONS
  Jsons,
  nfse_valid_json,
  fpjson,
  fpjsonrtti,

  //Data Transfer Object
  nfse_dto,
  tomador_dto,
  prestador_dto,
  servico_dto;

type
  { INFSeDtoJsonAdapter }
  INFSeDtoJsonAdapter = interface
    function ObjectToJson: string;
  end;

  { TNFSeDtoJsonAdapter }

  TNFSeDtoJsonAdapter = class(TInterfacedObject, INFSeDtoJsonAdapter)
  private

  public
    function ObjectToJson: string;

    class function New: INFSeDtoJsonAdapter;
  end;

type

  { IJsonNFSeDtoAdapter }

  IJsonNFSeDtoAdapter = interface

    { JSON TO OBJECT }
    function JsonToObject(jsonStr: string): TNFSeDTO;




    function ObjectToJson(nfseDTO: TNFSeDTO): string;




  end;

  { TJsonNFSeDtoAdapter }

  TJsonNFSeDtoAdapter = class(TInterfacedObject, IJsonNFSeDtoAdapter)
  private

  public

    { JSON TO OBJECT }
    function JsonToObject(jsonStr: string): TNFSeDTO;




    function ObjectToJson(nfseDTO: TNFSeDTO): string;




    class function New: IJsonNFSeDtoAdapter;
  end;


implementation

{ TNFSeDtoJsonAdapter }

{ OBJECT TO JSON }
function TNFSeDtoJsonAdapter.ObjectToJson: string;
var
   Json: TJSONObject;
   nfseDTO: TNFSeDTO;
begin
   Json := TJSONObject.Create;

   Json.Add('Prestador', TJSONArray.Create([nfseDTO.Prestador.CpfCnpj]));

end;

class function TNFSeDtoJsonAdapter.New: INFSeDtoJsonAdapter;
begin
  Result := self.Create;
end;

{ JSON TO OBJECT }
function TJsonNFSeDtoAdapter.JsonToObject(jsonStr: string): TNFSeDTO;
var
  //Jsons
  Json: TJson;
  JsonObj: Jsons.TJsonObject;
  JsonObjEndereco: Jsons.TJsonObject;
  JsonObjTelefone: Jsons.TJsonObject;

  //Object
  nfseDTO: TNFSeDTO;

begin
  Result := nil;

  if (Trim(jsonStr) = '') then
  begin
    exit;
  end;

  // Tenta converter o Json
  Json := TJson.Create;

  // Verifica se o Json é válido
  Json := TValidJson.New.IsValidJson(jsonStr);

  if (Json = nil) then
  begin
    Json.Free;
    exit;
  end;

  nfseDTO := TNFSeDTO.Create;

  //Pega o conteúdo do Json
  try
    Json.Parse(jsonStr);

    JsonObj := Json.JsonObject.Values['tomador'].AsObject;

    if JsonObj <> nil then
    begin
      { TOMADOR }
      with nfseDTO.Tomador do
      begin
        CpfCnpj := JsonObj.Values['cpfCnpj'].AsString;
        RazaoSocial := JsonObj.Values['razaoSocial'].AsString;
        Email := JsonObj.Values['email'].AsString;
        InscricaoEstadual := JsonObj.Values['inscricaoEstadual'].AsString;
        InscricaoMunicipal := JsonObj.Values['inscricaoMunicipal'].AsString;
        InscricaoSuframa := JsonObj.Values['inscricaoSuframa'].AsString;
        NomeFantasia := JsonObj.Values['nomeFantasia'].AsString;
        OrgaoPublico := JsonObj.Values['orgaoPublico'].AsBoolean;
        IndicadorInscricaoEstadual :=
          JsonObj.Values['indicadorInscricaoEstadual'].AsInteger;
        CodigoEstrangeiro := JsonObj.Values['codigoEstrangeiro'].AsString;

      end;

      JsonObjEndereco := JsonObj.Values['endereco'].AsObject;

      if JsonObjEndereco <> nil then
      begin
        with nfseDTO.Tomador.Endereco do
        begin
          Bairro := JsonObjEndereco.Values['bairro'].AsString;
          Cep := JsonObjEndereco.Values['cep'].AsString;
          CodigoCidade := JsonObjEndereco.Values['codigoCidade'].AsString;
          UF := JsonObjEndereco.Values['UF'].AsString;
          Logradouro := JsonObjEndereco.Values['logradouro'].AsString;
          Numero := JsonObjEndereco.Values['numero'].AsString;
          CodigoPais := JsonObjEndereco.Values['codigoPais'].AsString;
          Complemento := JsonObjEndereco.Values['complemento'].AsString;
          DescricaoCidade := JsonObjEndereco.Values['descricaoCidade'].AsString;
          DescricaoPais := JsonObjEndereco.Values['descricaoPais'].AsString;
        end;
      end;

      JsonObjTelefone := JsonObj.Values['telefone'].AsObject;

      if JsonObjTelefone <> nil then
      begin
        with nfseDTO.Tomador.Telefone do
        begin
          DDD := JsonObjTelefone.Values['DDD'].AsString;
          Numero := JsonObjTelefone.Values['numero'].AsString;
        end;
      end;

      { PRESTADOR }
      JsonObj := Json.JsonObject.Values['portador'].AsObject;

      with nfseDTO.Prestador do
      begin
        CpfCnpj := JsonObj.Values['cpfCnpj'].AsString;
        RazaoSocial := JsonObj.Values['razaoSocial'].AsString;
        Email := JsonObj.Values['email'].AsString;
        InscricaoEstadual := JsonObj.Values['inscricaoEstadual'].AsString;
        InscricaoMunicipal := JsonObj.Values['inscricaoMunicipal'].AsString;
        InscricaoSuframa := JsonObj.Values['inscricaoSuframa'].AsString;
        NomeFantasia := JsonObj.Values['NomeFantasia'].AsString;
        RegimeTributario := JsonObj.Values['regimeTributaria'].AsInteger;
        RegimeTributarioEspecial := JsonObj.Values['regimeTributarioEspecial'].AsInteger;
        SimplesNacional := JsonObj.Values['simplesNacional'].AsBoolean;
        CodigoDistrito := JsonObj.Values['codigoDistrito'].AsInteger;
        IncentivadorCultural := JsonObj.Values['incentivadorCultural'].AsBoolean;
        IncentivoFiscal := JsonObj.Values['incentivoFiscal'].AsBoolean;
        CodigoEstrangeiro := JsonObj.Values['codigoEstrangeiro'].AsString;

      end;

      JsonObjEndereco := JsonObj.Values['endereco'].AsObject;

      if JsonObjEndereco <> nil then
      begin
        with nfseDTO.Prestador.Endereco do
        begin
          Bairro := JsonObjEndereco.Values['bairro'].AsString;
          Cep := JsonObjEndereco.Values['cep'].AsString;
          CodigoCidade := JsonObjEndereco.Values['codigoCidade'].AsString;
          UF := JsonObjEndereco.Values['UF'].AsString;
          Logradouro := JsonObjEndereco.Values['logradouro'].AsString;
          Numero := JsonObjEndereco.Values['numero'].AsString;
          CodigoPais := JsonObjEndereco.Values['codigoPais'].AsString;
          Complemento := JsonObjEndereco.Values['complemento'].AsString;
          DescricaoCidade := JsonObjEndereco.Values['descricaoCidade'].AsString;
          DescricaoPais := JsonObjEndereco.Values['descricaoPais'].AsString;
        end;
      end;

      JsonObjTelefone := JsonObj.Values['telefone'].AsObject;

      if JsonObjTelefone <> nil then
      begin
        with nfseDTO.Prestador.Telefone do
        begin
          DDD := JsonObjTelefone.Values['DDD'].AsString;
          Numero := JsonObjTelefone.Values['numero'].AsString;
        end;
      end;

      { VALOR }
      JsonObj := Json.JsonObject.Values['valor'].AsObject;

      if JsonObj <> nil then
      begin
        with nfseDTO.Servico.Valor do
        begin
          Servico := JsonObj.Values['servico'].AsNumber;
          BaseCalculo := JsonObj.Values['baseCalculo'].AsNumber;
          Deducoes := JsonObj.Values['deducoes'].AsNumber;
          DescontoCondicionado :=
            JsonObj.Values['descontoCondicionado'].AsNumber;
          DescontoIncondicionado :=
            JsonObj.Values['descontoIncondicionado'].AsNumber;
          Liquido := JsonObj.Values['liquido'].AsNumber;
          Unitario := JsonObj.Values['unitario'].AsNumber;
        end;//fim with
      end;//fim if

    end; //teste principal

    Result := nfseDTO;

  finally
    Json.Free;
  end;
end;


{ OBJECT TO JSON }
function TJsonNFSeDtoAdapter.ObjectToJson(nfseDTO: TNFSeDTO): string;
var
  Streamer: TJSONStreamer;
  JSONString: string;
begin
  Streamer := TJSONStreamer.Create(nil);

  nfseDTO.Descricao:= 'TESTE';
  try
    // Converte o Json e mostra o resultado num ShowMessage
    Result := Streamer.ObjectToJSONString(nfseDTO);
    //Limpa
  finally
    Streamer.Destroy;
  end;
end;

class function TJsonNFSeDtoAdapter.New: IJsonNFSeDtoAdapter;
begin
  Result := self.Create;
end;

end.
