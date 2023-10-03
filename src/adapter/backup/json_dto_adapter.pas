unit json_dto_adapter;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,

  //JSONS
  Jsons,
  fpjson,
  fpjsonrtti,

  //Data Transfer Object
  nfseDTO_dto;

type
  IJsonDtoAdapter = interface
    { OBJECT TO JSON }
    function ObjectToJson: string;

    { JSON TO OBJECT }
    function JsonToObject(jsonStr: string): TnfseDTO;

    { JSON IS VALID }
    function IsValidJson(JsonStr: string): TJson;
  end;

  TJsonDtoAdapter = class(TInterfacedObject, IJsonDtoAdapter)
  private

  public
    { OBJECT TO JSON }
    function ObjectToJson: string;

    { JSON TO OBJECT }
    function JsonToObject(jsonStr: string): TnfseDTO;

    { JSON IS VALID }
    function IsValidJson(JsonStr: string): TJson;

  end;


implementation

{ OBJECT TO JSON }
function TJsonDtoAdapter.ObjectToJson: string;
var
  Streamer: TJSONStreamer;
  nfseDTODTO: TnfseDTO;
  JSONString: string;
begin
  Streamer := TJSONStreamer.Create(nil);
  nfseDTODTO := TnfseDTO.Create;

  try
    Streamer.Options := Streamer.Options + [jsoLowerPropertyNames];
    //Deixa as propriedades no JSON como lower
    Streamer.Options := Streamer.Options + [jsoTStringsAsArray];
    // Salva as strings como JSON array

    // Converte o Json e mostra o resultado num ShowMessage
    JSONString := Streamer.ObjectToJSONString(nfseDTODTO);
    Result := JSONString; //RETORNA VAZIO {}

    //Limpa
  finally
    nfseDTODTO.Free;
    Streamer.Destroy;
  end;
end;

{ JSON TO OBJECT }
function TJsonDtoAdapter.JsonToObject(jsonStr: string): TnfseDTO;
var
  //Jsons
  Json: TJson;
  JsonObj: Jsons.TJsonObject;
  JsonObjEndereco: Jsons.TJsonObject;
  JsonObjTelefone: Jsons.TJsonObject;

  //Object
  nfseDTO: TnfseDTO;

begin
  nfseDTO := TnfseDTO.Create;

  if (Trim(jsonStr) = '') then
  begin
    exit;
  end;

  // Tenta converter o Json
  Json := TJson.Create;

  // Verifica se o Json é válido
  Json := IsValidJson(jsonStr);
  if (Json = nil) then
  begin
    Json.Free;
    exit;
  end;

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
          BaceCalculo := JsonObj.Values['baseCalculo'].AsNumber;
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
    Result:= nfseDTO;
  finally
    Json.Free;
  end;
end;

{ JSON IS VALID }
function TJsonDtoAdapter.IsValidJson(JsonStr: string): TJson;
var
  Json: TJson;
begin
  Json := TJson.Create;

  try
    Json.Parse(JsonStr);
    Result := Json;
  except
    Result := nil
  end;
end;

end.
