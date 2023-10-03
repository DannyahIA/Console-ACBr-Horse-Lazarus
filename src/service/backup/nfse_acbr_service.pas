unit nfse_acbr_service;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  Math,

  { ACBr }
  ACBrBase,
  ACBrDFe,
  ACBrDFeUtil,
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.FilesIO,
  ACBrDFeReport,
  ACBrMail,
  ACBrNFSeX,
  ACBrNFSeXConversao,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXDANFSeClass,
  ACBrDFeSSL,
  inifiles,
  pcnConversao,

  { DTO }
  nfse_dto;

type
  { INfseAcbrService }
  INfseAcbrService = interface
  end;

  { TNfseAcbrService }
  TNfseAcbrService = class(TInterfacedObject, INfseAcbrService)
  private
    FACBrNFSeX: TACBrNFSeX;

    FNumLote: string;
    FNumDfe: string;

    procedure GravarConfiguracao;
    procedure LerConfiguracao;
    procedure ConfigurarComponente;

    procedure AtribuirConfiguracao(notaFiscal: TNotaFiscal);
    procedure AtribuirPrestador(notaFiscal: TNotaFiscal);
    procedure AtribuirTomador(notaFiscal: TNotaFiscal);
    procedure AtribuirServico(notaFiscal: TNotaFiscal);

    function RoundTo5(Valor: double; Casas: integer): double;


  public
    class function New: INfseAcbrService;
    constructor Create;
    destructor Destroy; override;
    procedure Emitir();
  end;

implementation

{ TNfseAcbrService }
class function TNfseAcbrService.New: INfseAcbrService;
begin
  Result := self.Create;
end;

constructor TNfseAcbrService.Create;
begin
  inherited Create;
  FACBrNFSeX := TACBrNFSeX.Create(nil);
end;

destructor TNfseAcbrService.Destroy;
begin
  FACBrNFSeX.Free;
end;

//-------------------------------
// Emitir()
// Emite uma nova Nota de Serviço
//-------------------------------

procedure TNfseAcbrService.Emitir;
var
  notaFiscal: TNotaFiscal;
begin
  FNumLote := '';
  FNumDfe := '';

  // Configura Ambiente: taHomologacao taProducao
  FACBrNFSeX.Configuracoes.WebServices.Ambiente := taHomologacao;

  FACBrNFSeX.NotasFiscais.Clear;
  // Como será controlado o número de lote
  FACBrNFSeX.NotasFiscais.NumeroLote := FNumLote;
  FACBrNFSeX.NotasFiscais.Transacao := True;

  // Abaixo deverá varrer o objeto e incluir quantas notas vieram na requisição
  notaFiscal := TNotaFiscal.Create(FACBrNFSeX);
  AtribuirConfiguracao(notaFiscal);
  AtribuirServico(notaFiscal);
  AtribuirPrestador(notaFiscal);
  AtribuirTomador(notaFiscal);
  FAcbrNFSEX.NotasFiscais.Add(notaFiscal);

  FACBrNFSeX.Emitir(FNumLote);
end;

//-----------------------------------------------------------
// AtribuirConfiguracao()
// Preenche o objeto de Nota com as configurações necessárias
//-----------------------------------------------------------

procedure TNfseAcbrService.AtribuirConfiguracao(notaFiscal: TNotaFiscal);
begin
  with notaFiscal.Nfse do
  begin
    // Provedor CTAConsult
    TipoRecolhimento := '1';

    // Provedor PadraoNacional
    verAplic := 'ACBrNFSeX-1.00';

    // Provedor SigISS
      {
        Situação pode ser:
        tp – Tributada no prestador = tsTributadaNoPrestador;
        tt – Tributada no tomador = tsTibutadaNoTomador;
        is – Isenta = tsIsenta;
        im – Imune = tsImune;
        nt – Não tributada = tsNaoTributada.
      }
    SituacaoTrib := tsTributadaNoPrestador;

    // Usado pelo provedor AssessorPublico
      {
        A tag SITUACAO refere-se ao código da situação da NFS-e e aceita números
        inteiros de até 4 caracteres, sendo que devem estar previamente
        cadastradas no sistema.
      }
    Situacao := 1;

    //      refNF := '123456789012345678901234567890123456789';
    Numero := FNumDFe;
    // Provedor Infisc - Layout Proprio
    cNFSe := GerarCodigoDFe(StrToIntDef(Numero, 0));

    if FACBrNFSeX.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
      SeriePrestacao := '99'
    else
      SeriePrestacao := '1';

    NumeroLote := FNumLote;

    IdentificacaoRps.Numero := FormatFloat('#########0', StrToInt(FNumDFe));

    case FACBrNFSeX.Configuracoes.Geral.Provedor of
      proNFSeBrasil,
      proEquiplano:
        IdentificacaoRps.Serie := '1';

      proSudoeste:
        IdentificacaoRps.Serie := 'E';

      proBetha,
      proISSDSF,
      proSiat:
        IdentificacaoRps.Serie := 'NF';

      proISSNet:
        if FACBrNFSeX.Configuracoes.WebServices.Ambiente = taProducao then
          IdentificacaoRps.Serie := '1'
        else
          IdentificacaoRps.Serie := '8';

      proSystemPro:
        IdentificacaoRps.Serie := 'RPP';

      proPadraoNacional:
        IdentificacaoRps.Serie := '900';
      else
        IdentificacaoRps.Serie := '85';
    end;

    // TnfseTipoRPS = ( trRPS, trNFConjugada, trCupom );
    IdentificacaoRps.Tipo := trRPS;

    DataEmissao := Now;
    Competencia := Now;
    DataEmissaoRPS := Now;

    (*
        TnfseNaturezaOperacao = ( no1, no2, no3, no4, no5, no6, no7,
        no50, no51, no52, no53, no54, no55, no56, no57, no58, no59,
        no60, no61, no62, no63, no64, no65, no66, no67, no68, no69,
        no70, no71, no72, no78, no79,
        no101, no111, no121, no201, no301,
        no501, no511, no541, no551, no601, no701 );
      *)

    case FACBrNFSeX.Configuracoes.Geral.Provedor of
      // Provedor Thema:
      // 50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|78|79
      proThema:
        NaturezaOperacao := no51;
      else
        NaturezaOperacao := no1;
    end;

    case FACBrNFSeX.Configuracoes.Geral.Provedor of
      proPadraoNacional:
        RegimeEspecialTributacao := retCooperativa;
      else
        RegimeEspecialTributacao := retMicroempresaMunicipal;
    end;

    // TnfseSimNao = ( snSim, snNao );
    OptanteSimplesNacional := snSim;

    // Provedor PadraoNacional
    OptanteSN := osnNaoOptante;

    // TnfseSimNao = ( snSim, snNao );
    IncentivadorCultural := snNao;
    // Provedor Tecnos
    PercentualCargaTributaria := 0;
    ValorCargaTributaria := 0;
    PercentualCargaTributariaMunicipal := 0;
    ValorCargaTributariaMunicipal := 0;
    PercentualCargaTributariaEstadual := 0;
    ValorCargaTributariaEstadual := 0;

    // TnfseSimNao = ( snSim, snNao );
    // snSim = Ambiente de Produção
    // snNao = Ambiente de Homologação
    if FACBrNFSeX.Configuracoes.WebServices.Ambiente = taProducao then
      Producao := snSim
    else
      Producao := snNao;

    // TnfseStatusRPS = ( srNormal, srCancelado );
    StatusRps := srNormal;

    // Somente Os provedores Betha, FISSLex e SimplISS permitem incluir no RPS
    // a TAG: OutrasInformacoes os demais essa TAG é gerada e preenchida pelo
    // WebService do provedor.
    OutrasInformacoes := 'Pagamento a Vista';

    {=========================================================================
        Numero, Série e Tipo do Rps que esta sendo substituido por este
     =========================================================================}

      {
       RpsSubstituido.Numero := FormatFloat('#########0', i);
       RpsSubstituido.Serie  := 'UNICA';
       // TnfseTipoRPS = ( trRPS, trNFConjugada, trCupom );
       RpsSubstituido.Tipo   := trRPS;
      }

  end; // end do width
end;


//----------
// AtribuirPrestador()
// Preenche o objeto de Nota com os dados do Prestador
//----------

procedure TNfseAcbrService.AtribuirPrestador(notaFiscal: TNotaFiscal);
begin
  with notaFiscal.Nfse.Prestador do
  begin
    IdentificacaoPrestador.CpfCnpj := '';
    IdentificacaoPrestador.CpfCnpj := '';
    IdentificacaoPrestador.InscricaoMunicipal := '';

    RazaoSocial := '';
    NomeFantasia := '';

    // Para o provedor ISSDigital deve-se informar também:
    cUF := UFtoCUF('');

    Endereco.Endereco := '';
    Endereco.Numero := '';
    Endereco.Bairro := '';
    Endereco.CodigoMunicipio := '';

    Endereco.xMunicipio := '';
    Endereco.UF := '';
    Endereco.CodigoPais := 1058;
    Endereco.xPais := 'BRASIL';
    Endereco.CEP := '';

    Contato.DDD := '16';

    case FACBrNFSeX.Configuracoes.Geral.Provedor of
      proSigep, proCTAConsult:
        Contato.Telefone := '';
      else
        Contato.Telefone := '';
    end;

    Contato.Email := 'nome@provedor.com.br';
  end;
end;

//----------
// AtribuirTomador()
// Preenche o objeto de Nota com os dados do Tomador
//----------

procedure TNfseAcbrService.AtribuirTomador(notaFiscal: TNotaFiscal);
begin
  with notaFiscal.Nfse.Tomador do
  begin
    AtualizaTomador := snNao;
    TomadorExterior := snNao;

    // Para o provedor IPM usar os valores:
    // tpPFNaoIdentificada ou tpPF para pessoa Fisica
    // tpPJdoMunicipio ou tpPJforaMunicipio ou tpPJforaPais para pessoa Juridica

    // Para o provedor SigISS usar os valores acima de forma adquada
    IdentificacaoTomador.Tipo := tpPF;
    IdentificacaoTomador.CpfCnpj := '12345678901';
    IdentificacaoTomador.InscricaoMunicipal := '';
    IdentificacaoTomador.InscricaoEstadual := '';

    RazaoSocial := 'INSCRICAO DE TESTE & TESTE';

    // O campo EnderecoInformado é utilizado pelo provedor IPM
    // A tag <endereco_informado> é opcional, caso não deseje que ela seja
    // gerada devemos informar uma string vazia, ou S = Sim ou N = Não
    Endereco.EnderecoInformado := 'S';
    Endereco.TipoLogradouro := 'RUA';
    Endereco.Endereco := 'RUA PRINCIPAL';
    Endereco.Numero := '100';
    Endereco.Complemento := 'APTO 11';
    Endereco.TipoBairro := 'BAIRRO';
    Endereco.Bairro := 'CENTRO';
    Endereco.CodigoMunicipio := '';

    Endereco.xMunicipio := '';
    Endereco.UF := '';
    Endereco.CodigoPais := 1058; // Brasil
    Endereco.CEP := '14800000';
    Endereco.xPais := 'BRASIL';

    Contato.DDD := '16';

    case FACBrNFSeX.Configuracoes.Geral.Provedor of
      proSigep, proCTAConsult:
        Contato.Telefone := '22223333';
      else
        Contato.Telefone := '1622223333';
    end;

    Contato.Email := 'nome@provedor.com.br';
  end;

end;


//----------
// AtribuirServico()
// Preenche o objeto de Nota com os dados do Serviço
//----------

procedure TNfseAcbrService.AtribuirServico(notaFiscal: TNotaFiscal);
var
  vValorISS: double;
begin
  with notaFiscal.Nfse.Servico do
  begin
    // Provedores que permitem informar mais de 1 serviço:
    if (FACBrNFSeX.Configuracoes.Geral.Provedor in [proAgili,
      proAssessorPublico, proCTA, proCTAConsult, proEloTech, proEquiplano,
      proFacundo, proFGMaiss, profintelISS, proGoverna, proInfisc,
      proIPM, proPriMax, proISSDSF, proRLZ, proSimple, proSimplISS,
      proSmarAPD, proWebFisco, proBauhaus, proSoftPlan]) or
      ((FACBrNFSeX.Configuracoes.Geral.Provedor in [proEL]) and
      (FACBrNFSeX.Configuracoes.Geral.Versao = ve100)) then
    begin
      // Provedor Elotech
      Valores.RetidoPis := snNao;
      Valores.RetidoCofins := snNao;
      Valores.AliquotaInss := 0;
      Valores.RetidoInss := snNao;
      Valores.AliquotaIr := 0;
      Valores.RetidoIr := snNao;
      Valores.AliquotaCsll := 0;
      Valores.RetidoCsll := snNao;

      with ItemServico.New do
      begin
        Descricao := 'Desc. do Serv. 1';
        ItemListaServico := '09.01';

        // infisc, EL
        CodServ := '12345';
        // Infisc, EL
        codLCServ := '123';

        ValorDeducoes := 0;
        xJustDeducao := '';

        AliqReducao := 0;
        ValorReducao := 0;

        DescontoIncondicionado := 0;
        DescontoCondicionado := 0;

        // TUnidade = (tuHora, tuQtde);
        TipoUnidade := tuQtde;
        Unidade := 'UN';
        Quantidade := 10;
        ValorUnitario := 0.01;

        QtdeDiaria := 0;
        ValorTaxaTurismo := 0;

        ValorTotal := Quantidade * ValorUnitario;

        BaseCalculo := ValorTotal - ValorDeducoes - DescontoIncondicionado;

        Aliquota := 0.10;

        ValorISS := BaseCalculo * Aliquota / 100;

        ValorISSRetido := 0;

        AliqISSST := 0;
        ValorISSST := 0;

        ValorBCCSLL := 0;
        AliqRetCSLL := 0;
        ValorCSLL := 0;

        ValorBCPIS := 0;
        AliqRetPIS := 0;
        ValorPIS := 0;

        ValorBCCOFINS := 0;
        AliqRetCOFINS := 0;
        ValorCOFINS := 0;

        ValorBCINSS := 0;
        AliqRetINSS := 0;
        ValorINSS := 0;

        ValorBCRetIRRF := 0;
        AliqRetIRRF := 0;
        ValorIRRF := 0;

        // Provedor EloTech
        Tributavel := snNao;

        case FACBrNFSeX.Configuracoes.Geral.Provedor of
          proAgili:
            // código com 9 digitos
            CodigoCnae := '452000200';
          else
            // código com 7 digitos
            CodigoCnae := '6203100';
        end;

        // Provedor IPM
        { define se o tributo é no municipio do prestador ou não }
        TribMunPrestador := snNao;
        { codigo do municipio que ocorreu a prestação de serviço }
        CodMunPrestacao := '';
        { codigo da situação tributária: 0 até 15 }
        SituacaoTributaria := 0;
      end;
    end
    else
    begin
      Valores.ValorServicos := 100.35;
      Valores.ValorDeducoes := 0.00;
      Valores.AliquotaPis := 0.00;
      Valores.ValorPis := 0.00;
      Valores.AliquotaCofins := 2.00;
      Valores.ValorCofins := 2.00;
      Valores.ValorInss := 0.00;
      Valores.ValorIr := 0.00;
      Valores.ValorCsll := 0.00;
      // Usado pelo provedor SystemPro
      Valores.ValorTaxaTurismo := 0.00;
      Valores.QtdeDiaria := 0.00;

      // TnfseSituacaoTributaria = ( stRetencao, stNormal, stSubstituicao );
      // stRetencao = snSim
      // stNormal   = snNao

      // Neste exemplo não temos ISS Retido ( stNormal = Não )
      // Logo o valor do ISS Retido é igual a zero.
      Valores.IssRetido := stNormal;
      Valores.ValorIssRetido := 0.00;

      Valores.OutrasRetencoes := 0.00;
      Valores.DescontoIncondicionado := 0.00;
      Valores.DescontoCondicionado := 0.00;

      Valores.BaseCalculo :=
        Valores.ValorServicos - Valores.ValorDeducoes -
        Valores.DescontoIncondicionado;

      Valores.Aliquota := 2;

      // Provedor PadraoNacional
      Valores.tribMun.tribISSQN := tiOperacaoTributavel;
      Valores.tribMun.cPaisResult := 0;

      Valores.tribFed.CST := cst01;
      Valores.tribFed.vBCPisCofins := Valores.BaseCalculo;
      Valores.tribFed.pAliqPis := 1.65;
      Valores.tribFed.pAliqCofins := 7.60;
      Valores.tribFed.vPis :=
        Valores.tribFed.vBCPisCofins * Valores.tribFed.pAliqPis / 100;
      Valores.tribFed.vCofins :=
        Valores.tribFed.vBCPisCofins * Valores.tribFed.pAliqCofins / 100;
      Valores.tribFed.tpRetPisCofins := trpcNaoRetido;

      Valores.totTrib.vTotTribFed := Valores.tribFed.vPis;
      Valores.totTrib.vTotTribEst := 0;
      Valores.totTrib.vTotTribMun := Valores.tribFed.vCofins;


      vValorISS := Valores.BaseCalculo * Valores.Aliquota / 100;

      // A função RoundTo5 é usada para arredondar valores, sendo que o segundo
      // parametro se refere ao numero de casas decimais.
      // exemplos: RoundTo5(50.532, -2) ==> 50.53
      // exemplos: RoundTo5(50.535, -2) ==> 50.54
      // exemplos: RoundTo5(50.536, -2) ==> 50.54

      Valores.ValorISS := RoundTo5(vValorISS, -2);

      Valores.ValorLiquidoNfse :=
        Valores.ValorServicos - Valores.ValorPis - Valores.ValorCofins -
        Valores.ValorInss - Valores.ValorIr - Valores.ValorCsll -
        Valores.OutrasRetencoes - Valores.ValorIssRetido -
        Valores.DescontoIncondicionado - Valores.DescontoCondicionado;
    end;


      {=========================================================================
        Dados do Serviço
      =========================================================================}

    if FACBrNFSeX.Configuracoes.Geral.Provedor = proInfisc then
    begin
      Valores.ValorServicos := 100.35;
      Valores.DescontoIncondicionado := 0.00;
      Valores.OutrosDescontos := 0.00;

      Valores.ValorLiquidoNfse :=
        Valores.ValorServicos - Valores.ValorPis - Valores.ValorCofins -
        Valores.ValorInss - Valores.ValorIr - Valores.ValorCsll -
        Valores.OutrasRetencoes - Valores.ValorIssRetido -
        Valores.DescontoIncondicionado - Valores.DescontoCondicionado;
    end;

    //--> aqui deu erro por causa do nivel -> DeducaoMateriais := snSim;

    with Deducao.New do
    begin
      TipoDeducao := tdMateriais;
      ValorDeduzir := 10.00;
    end;

    case FACBrNFSeX.Configuracoes.Geral.Provedor of
      proSiapSistemas:
        // código padrão ABRASF acrescido de um sub-item
        ItemListaServico := '01.05.00';

      proPadraoNacional:
        ItemListaServico := '010201';

      proCTAConsult:
        ItemListaServico := '01050';
      else
        // código padrão da ABRASF
        ItemListaServico := '09.01';
    end;

    CodigoNBS := '123456789';
    Discriminacao := 'discriminacao I; discriminacao II';

    // TnfseResponsavelRetencao = ( rtTomador, rtPrestador, rtIntermediario, rtNenhum )
    //                              '1',       '',          '2',             ''
    ResponsavelRetencao := rtTomador;

    case FACBrNFSeX.Configuracoes.Geral.Provedor of
      proISSSJP:
        CodigoTributacaoMunicipio := '631940000';

      proCenti:
        CodigoTributacaoMunicipio := '0901';

      proISSSalvador:
        CodigoTributacaoMunicipio := '0901001';

      proIPM, proSystemPro:
        CodigoTributacaoMunicipio := '';

      proPadraoNacional:
        CodigoTributacaoMunicipio := '';
      else
        CodigoTributacaoMunicipio := '63194';
    end;

    case FACBrNFSeX.Configuracoes.Geral.Provedor of
      proSiat, proISSDSF, proCTAConsult:
        // código com 9 digitos
        CodigoCnae := '452000200';

      proSystemPro:
        CodigoCnae := '';
      else
        // código com 7 digitos
        CodigoCnae := '6203100';
    end;

    // Para o provedor ISSNet em ambiente de Homologação
    // o Codigo do Municipio tem que ser '999'
    CodigoMunicipio := '';
    UFPrestacao := 'SP';

    // Informar A Exigibilidade ISS para fintelISS [1/2/3/4/5/6/7]
    ExigibilidadeISS := exiExigivel;

    CodigoPais := 1058; // Brasil
    MunicipioIncidencia := StrToIntDef('', 0);

    // Provedor GeisWeb
    // tlDevidoNoMunicPrestador, tlDevidoNoMunicTomador, tlSimplesNacional, tlIsentoImune
    TipoLancamento := tlSimplesNacional;
  end;
end;


function TNfseAcbrService.RoundTo5(Valor: double; Casas: integer): double;
var
  xValor, xDecimais: string;
  p, nCasas: integer;
  nValor: double;
  OldRM: TFPURoundingMode;
begin
  nValor := Valor;
  xValor := Trim(FloatToStr(Valor));
  p := pos(',', xValor);

  if Casas < 0 then
    nCasas := -Casas
  else
    nCasas := Casas;

  if p > 0 then
  begin
    xDecimais := Copy(xValor, p + 1, Length(xValor));

    OldRM := GetRoundMode;
    try
      if Length(xDecimais) > nCasas then
      begin
        if xDecimais[nCasas + 1] >= '5' then
          SetRoundMode(rmUP)
        else
          SetRoundMode(rmNearest);
      end;

      nValor := RoundTo(Valor, Casas);

    finally
      SetRoundMode(OldRM);
    end;
  end;

  Result := nValor;
end;

procedure TNfseAcbrService.GravarConfiguracao;
var
  IniFile: string;
  Ini: TIniFile;
  StreamMemo: TMemoryStream;
begin
  //IniFile := ChangeFileExt(Application.ExeName, '.ini');

  Ini := TIniFile.Create(IniFile);
  try
    //Ini.WriteInteger('Certificado', 'SSLLib', cbSSLLib.ItemIndex);
    //Ini.WriteInteger('Certificado', 'CryptLib', cbCryptLib.ItemIndex);
    //Ini.WriteInteger('Certificado', 'HttpLib', cbHttpLib.ItemIndex);
    //Ini.WriteInteger('Certificado', 'XmlSignLib', cbXmlSignLib.ItemIndex);
    Ini.WriteString('Certificado', 'Caminho', 'edtCaminho.Text');
    Ini.WriteString('Certificado', 'Senha', 'edtSenha.Text');
    Ini.WriteString('Certificado', 'NumSerie', 'edtNumSerie.Text');

    //Ini.WriteBool('Geral', 'AtualizarXML', cbxAtualizarXML.Checked);
    //Ini.WriteBool('Geral', 'ExibirErroSchema', cbxExibirErroSchema.Checked);
    Ini.WriteString('Geral', 'FormatoAlerta', 'edtFormatoAlerta.Text');
    //Ini.WriteInteger('Geral', 'FormaEmissao', cbFormaEmissao.ItemIndex);
    //Ini.WriteBool('Geral', 'RetirarAcentos', cbxRetirarAcentos.Checked);
    //Ini.WriteBool('Geral', 'Salvar', chkSalvarGer.Checked);
    Ini.WriteString('Geral', 'PathSalvar', 'edtPathLogs.Text');
    Ini.WriteString('Geral', 'PathSchemas', 'edtPathSchemas.Text');
    Ini.WriteString('Geral', 'LogoMarca', 'edtLogoMarca.Text');
    Ini.WriteString('Geral', 'PrestLogo', 'edtPrestLogo.Text');
    Ini.WriteString('Geral', 'Prefeitura', 'edtPrefeitura.Text');

    //Ini.WriteBool('Geral', 'ConsultaAposEnvio', chkConsultaLoteAposEnvio.Checked);
    //Ini.WriteBool('Geral', 'ConsultaAposCancelar', chkConsultaAposCancelar.Checked);
    //Ini.WriteBool('Geral', 'MontarPathSchemas', chkMontarPathSchemas.Checked);

    //Ini.WriteInteger('Geral', 'LayoutNFSe', cbLayoutNFSe.ItemIndex);

    //Ini.WriteInteger('WebService', 'Ambiente', rgTipoAmb.ItemIndex);
    //Ini.WriteBool('WebService', 'Visualizar', cbxVisualizar.Checked);
    //Ini.WriteBool('WebService', 'SalvarSOAP', chkSalvarSOAP.Checked);
    //Ini.WriteBool('WebService', 'AjustarAut', cbxAjustarAut.Checked);
    Ini.WriteString('WebService', 'Aguardar', 'edtAguardar.Text');
    Ini.WriteString('WebService', 'Tentativas', 'edtTentativas.Text');
    Ini.WriteString('WebService', 'Intervalo', 'edtIntervalo.Text');
    //Ini.WriteInteger('WebService', 'TimeOut', seTimeOut.Value);
    //Ini.WriteInteger('WebService', 'SSLType', cbSSLType.ItemIndex);
    Ini.WriteString('WebService', 'SenhaWeb', 'edtSenhaWeb.Text');
    Ini.WriteString('WebService', 'UserWeb', 'edtUserWeb.Text');
    Ini.WriteString('WebService', 'FraseSecWeb', 'edtFraseSecWeb.Text');
    Ini.WriteString('WebService', 'ChAcessoWeb', 'edtChaveAcessoWeb.Text');
    Ini.WriteString('WebService', 'ChAutorizWeb', 'edtChaveAutorizWeb.Text');

    Ini.WriteString('Proxy', 'Host', 'edtProxyHost.Text');
    Ini.WriteString('Proxy', 'Porta', 'edtProxyPorta.Text');
    Ini.WriteString('Proxy', 'User', 'edtProxyUser.Text');
    Ini.WriteString('Proxy', 'Pass', 'edtProxySenha.Text');

    //Ini.WriteBool('Arquivos', 'Salvar', chkSalvarArq.Checked);
    //Ini.WriteBool('Arquivos', 'PastaMensal', cbxPastaMensal.Checked);
    //Ini.WriteBool('Arquivos', 'AddLiteral', cbxAdicionaLiteral.Checked);
    //Ini.WriteBool('Arquivos', 'EmissaoPathNFSe', cbxEmissaoPathNFSe.Checked);
    //Ini.WriteBool('Arquivos', 'SepararPorCNPJ', cbxSepararPorCNPJ.Checked);
    Ini.WriteString('Arquivos', 'PathNFSe', 'edtPathNFSe.Text');

    Ini.WriteString('Emitente', 'CNPJ', 'edtEmitCNPJ.Text');
    Ini.WriteString('Emitente', 'IM', 'edtEmitIM.Text');
    Ini.WriteString('Emitente', 'RazaoSocial', 'edtEmitRazao.Text');
    Ini.WriteString('Emitente', 'Fantasia', 'edtEmitFantasia.Text');
    Ini.WriteString('Emitente', 'Fone', 'edtEmitFone.Text');
    Ini.WriteString('Emitente', 'CEP', 'edtEmitCEP.Text');
    Ini.WriteString('Emitente', 'Logradouro', 'edtEmitLogradouro.Text');
    Ini.WriteString('Emitente', 'Numero', 'edtEmitNumero.Text');
    Ini.WriteString('Emitente', 'Complemento', 'edtEmitComp.Text');
    Ini.WriteString('Emitente', 'Bairro', 'edtEmitBairro.Text');
    Ini.WriteString('Emitente', 'CodCidade', 'edtCodCidade.Text');
    Ini.WriteString('Emitente', 'Cidade', 'edtEmitCidade.Text');
    Ini.WriteString('Emitente', 'UF', 'edtEmitUF.Text');
    Ini.WriteString('Emitente', 'CNPJPref', 'edtCNPJPrefeitura.Text');

    Ini.WriteString('Email', 'Host', 'edtSmtpHost.Text');
    Ini.WriteString('Email', 'Port', 'edtSmtpPort.Text');
    Ini.WriteString('Email', 'User', 'edtSmtpUser.Text');
    Ini.WriteString('Email', 'Pass', 'edtSmtpPass.Text');
    Ini.WriteString('Email', 'Assunto', 'edtEmailAssunto.Text');
    //Ini.WriteBool('Email', 'SSL', cbEmailSSL.Checked);

    StreamMemo := TMemoryStream.Create;
    //mmEmailMsg.Lines.SaveToStream(StreamMemo);
    StreamMemo.Seek(0, soFromBeginning);

    Ini.WriteBinaryStream('Email', 'Mensagem', StreamMemo);

    StreamMemo.Free;

    if 'edtPathPDF.Text' = '' then
      //edtPathPDF.Text := edtPathNFSe.Text;

      //Ini.WriteInteger('DANFSE', 'Tipo', rgTipoDANFSE.ItemIndex);
      //Ini.WriteString('DANFSE', 'LogoMarca', 'edtLogoMarca.Text');
      Ini.WriteString('DANFSE', 'PathPDF', 'edtPathPDF.Text');

    ConfigurarComponente;
  finally
    Ini.Free;
  end;
end;

procedure TNfseAcbrService.LerConfiguracao;
var
  IniFile: string;
  Ini: TIniFile;
  StreamMemo: TMemoryStream;
begin
  //IniFile := ChangeFileExt(Application.ExeName, '.ini');

  Ini := TIniFile.Create(IniFile);
  try
    (*
    cbSSLLib.ItemIndex := Ini.ReadInteger('Certificado', 'SSLLib', 4);
    cbCryptLib.ItemIndex := Ini.ReadInteger('Certificado', 'CryptLib', 0);
    cbHttpLib.ItemIndex := Ini.ReadInteger('Certificado', 'HttpLib', 0);
    cbXmlSignLib.ItemIndex := Ini.ReadInteger('Certificado', 'XmlSignLib', 0);
    if cbSSLLib.ItemIndex <> 5 then
      cbSSLLibChange(cbSSLLib);
    edtCaminho.Text := Ini.ReadString('Certificado', 'Caminho', '');
    edtSenha.Text := Ini.ReadString('Certificado', 'Senha', '');
    edtNumSerie.Text := Ini.ReadString('Certificado', 'NumSerie', '');

    cbxAtualizarXML.Checked := Ini.ReadBool('Geral', 'AtualizarXML', True);
    cbxExibirErroSchema.Checked := Ini.ReadBool('Geral', 'ExibirErroSchema', True);
    edtFormatoAlerta.Text :=
      Ini.ReadString('Geral', 'FormatoAlerta',
      'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.');
    cbFormaEmissao.ItemIndex := Ini.ReadInteger('Geral', 'FormaEmissao', 0);

    chkSalvarGer.Checked := Ini.ReadBool('Geral', 'Salvar', True);
    cbxRetirarAcentos.Checked := Ini.ReadBool('Geral', 'RetirarAcentos', True);
    edtPathLogs.Text :=
      Ini.ReadString('Geral', 'PathSalvar',
      PathWithDelim(ExtractFilePath(Application.ExeName)) + 'Logs');
    edtPathSchemas.Text := Ini.ReadString('Geral', 'PathSchemas', '');
    edtLogoMarca.Text := Ini.ReadString('Geral', 'LogoMarca', '');
    edtPrestLogo.Text := Ini.ReadString('Geral', 'PrestLogo', '');
    edtPrefeitura.Text := Ini.ReadString('Geral', 'Prefeitura', '');

    chkConsultaLoteAposEnvio.Checked :=
      Ini.ReadBool('Geral', 'ConsultaAposEnvio', False);
    chkConsultaAposCancelar.Checked :=
      Ini.ReadBool('Geral', 'ConsultaAposCancelar', False);
    chkMontarPathSchemas.Checked :=
      Ini.ReadBool('Geral', 'MontarPathSchemas', True);

    cbLayoutNFSe.ItemIndex := Ini.ReadInteger('Geral', 'LayoutNFSe', 0);

    rgTipoAmb.ItemIndex := Ini.ReadInteger('WebService', 'Ambiente', 0);
    cbxVisualizar.Checked := Ini.ReadBool('WebService', 'Visualizar', False);
    chkSalvarSOAP.Checked := Ini.ReadBool('WebService', 'SalvarSOAP', False);
    cbxAjustarAut.Checked := Ini.ReadBool('WebService', 'AjustarAut', False);
    edtAguardar.Text := Ini.ReadString('WebService', 'Aguardar', '0');
    edtTentativas.Text := Ini.ReadString('WebService', 'Tentativas', '5');
    edtIntervalo.Text := Ini.ReadString('WebService', 'Intervalo', '0');
    seTimeOut.Value := Ini.ReadInteger('WebService', 'TimeOut', 5000);
    cbSSLType.ItemIndex := Ini.ReadInteger('WebService', 'SSLType', 5);
    edtSenhaWeb.Text := Ini.ReadString('WebService', 'SenhaWeb', '');
    edtUserWeb.Text := Ini.ReadString('WebService', 'UserWeb', '');
    edtFraseSecWeb.Text := Ini.ReadString('WebService', 'FraseSecWeb', '');
    edtChaveAcessoWeb.Text := Ini.ReadString('WebService', 'ChAcessoWeb', '');
    edtChaveAutorizWeb.Text := Ini.ReadString('WebService', 'ChAutorizWeb', '');

    edtProxyHost.Text := Ini.ReadString('Proxy', 'Host', '');
    edtProxyPorta.Text := Ini.ReadString('Proxy', 'Porta', '');
    edtProxyUser.Text := Ini.ReadString('Proxy', 'User', '');
    edtProxySenha.Text := Ini.ReadString('Proxy', 'Pass', '');

    chkSalvarArq.Checked := Ini.ReadBool('Arquivos', 'Salvar', False);
    cbxPastaMensal.Checked := Ini.ReadBool('Arquivos', 'PastaMensal', False);
    cbxAdicionaLiteral.Checked := Ini.ReadBool('Arquivos', 'AddLiteral', False);
    cbxEmissaoPathNFSe.Checked := Ini.ReadBool('Arquivos', 'EmissaoPathNFSe', False);
    cbxSepararPorCNPJ.Checked := Ini.ReadBool('Arquivos', 'SepararPorCNPJ', False);
    edtPathNFSe.Text := Ini.ReadString('Arquivos', 'PathNFSe', '');

    edtEmitCNPJ.Text := Ini.ReadString('Emitente', 'CNPJ', '');
    edtEmitIM.Text := Ini.ReadString('Emitente', 'IM', '');
    edtEmitRazao.Text := Ini.ReadString('Emitente', 'RazaoSocial', '');
    edtEmitFantasia.Text := Ini.ReadString('Emitente', 'Fantasia', '');
    edtEmitFone.Text := Ini.ReadString('Emitente', 'Fone', '');
    edtEmitCEP.Text := Ini.ReadString('Emitente', 'CEP', '');
    edtEmitLogradouro.Text := Ini.ReadString('Emitente', 'Logradouro', '');
    edtEmitNumero.Text := Ini.ReadString('Emitente', 'Numero', '');
    edtEmitComp.Text := Ini.ReadString('Emitente', 'Complemento', '');
    edtEmitBairro.Text := Ini.ReadString('Emitente', 'Bairro', '');
    edtCodCidade.Text := Ini.ReadString('Emitente', 'CodCidade', '');
    edtEmitCidade.Text := Ini.ReadString('Emitente', 'Cidade', '');
    edtEmitUF.Text := Ini.ReadString('Emitente', 'UF', '');
    edtCNPJPrefeitura.Text := Ini.ReadString('Emitente', 'CNPJPref', '');

    edtSmtpHost.Text := Ini.ReadString('Email', 'Host', '');
    edtSmtpPort.Text := Ini.ReadString('Email', 'Port', '');
    edtSmtpUser.Text := Ini.ReadString('Email', 'User', '');
    edtSmtpPass.Text := Ini.ReadString('Email', 'Pass', '');
    edtEmailAssunto.Text := Ini.ReadString('Email', 'Assunto', '');
    cbEmailSSL.Checked := Ini.ReadBool('Email', 'SSL', False);

    StreamMemo := TMemoryStream.Create;
    Ini.ReadBinaryStream('Email', 'Mensagem', StreamMemo);
    mmEmailMsg.Lines.LoadFromStream(StreamMemo);
    StreamMemo.Free;

    rgTipoDANFSe.ItemIndex := Ini.ReadInteger('DANFSE', 'Tipo', 0);
    edtLogoMarca.Text := Ini.ReadString('DANFSE', 'LogoMarca', '');
    edtPathPDF.Text := Ini.ReadString('DANFSE', 'PathPDF', '');

    ConfigurarComponente;

    AtualizarCidades;

    cbCidades.ItemIndex := cbCidades.Items.IndexOf(edtEmitCidade.Text +
      '/' + edtCodCidade.Text + '/' + edtEmitUF.Text);
      *)
  finally
    Ini.Free;
  end;
end;

procedure TNfseAcbrService.ConfigurarComponente;
var
  Ok: boolean;
  PathMensal: string;
begin
  FACBrNFSeX.Configuracoes.Certificados.ArquivoPFX := '';
  FACBrNFSeX.Configuracoes.Certificados.Senha := '';
  FACBrNFSeX.Configuracoes.Certificados.NumeroSerie := '';
  FACBrNFSeX.SSL.DescarregarCertificado;

  with FACBrNFSeX.Configuracoes.Geral do
  begin
    SSLLib := TSSLLib.libOpenSSL;
    SSLCryptLib := TSSLCryptLib.cryOpenSSL;
    SSLHttplib := TSSLHttpLib.httpOpenSSL;
    SSLXmlSignLib := xsLibXml2;

    Salvar := False;
    ExibirErroSchema := False;
    RetirarAcentos := True;
    FormatoAlerta := '';
    //FormaEmissao := TpcnTipoEmissao(cbFormaEmissao.ItemIndex);

    //ConsultaLoteAposEnvio := chkConsultaLoteAposEnvio.Checked;
    //ConsultaAposCancelar := chkConsultaAposCancelar.Checked;
    //MontarPathSchema := chkMontarPathSchemas.Checked;

    CNPJPrefeitura := 'edtCNPJPrefeitura.Text';

    Emitente.CNPJ := '';
    Emitente.InscMun := '';
    Emitente.RazSocial := '';
    Emitente.WSUser := '';
    Emitente.WSSenha := '';
    Emitente.WSFraseSecr := '';
    Emitente.WSChaveAcesso := '';
    Emitente.WSChaveAutoriz := '';

    //Exemplos de valores para WSChaveAcesso para alguns provedores. //NO CÓDIGO ORIGINAL ESTÁ COMENTADO
    {
    if Provedor in [proAgili, proElotech] then
      Emitente.WSChaveAcesso := '0aA1bB2cC3dD4eE5fF6aA7bB8cC9dDEF';

    if Provedor = proISSNet then
      Emitente.WSChaveAcesso := 'A001.B0001.C0001-1';

    if Provedor = proSigep then
      Emitente.WSChaveAcesso := 'A001.B0001.C0001';

    if Provedor = proiiBrasil then
      Emitente.WSChaveAcesso := 'TLXX4JN38KXTRNSEAJYYEA==';
    }

    {
      Para o provedor ADM, utilizar as seguintes propriedades de configurações:
      WSChaveAcesso  para o Key
      WSChaveAutoriz para o Auth
      WSUser         para o RequestId

      O Key, Auth e RequestId são gerados pelo provedor quando o emitente se cadastra.
    }
  end;

  with FACBrNFSeX.Configuracoes.WebServices do
  begin
    //Ambiente   := StrToTpAmb(Ok,IntToStr(rgTipoAmb.ItemIndex+1));
    //Visualizar := cbxVisualizar.Checked;
    //Salvar     := chkSalvarSOAP.Checked;
    UF := 'edtEmitUF.Text';

    //AjustaAguardaConsultaRet := cbxAjustarAut.Checked;

    if NaoEstaVazio('edtAguardar.Text') then
      AguardarConsultaRet := ifThen(StrToInt('edtAguardar.Text') <
        1000, StrToInt('edtAguardar.Text') * 1000, StrToInt('edtAguardar.Text'))
    else
    //'edtAguardar.Text' := IntToStr(AguardarConsultaRet);

    if NaoEstaVazio('edtTentativas.Text') then
      Tentativas := StrToInt('edtTentativas.Text')
    else
    //'edtTentativas.Text' := IntToStr(Tentativas);

    if NaoEstaVazio('edtIntervalo.Text') then
      IntervaloTentativas := ifThen(StrToInt('edtIntervalo.Text') <
        1000, StrToInt('edtIntervalo.Text') * 1000, StrToInt('edtIntervalo.Text'))
    else
      //'edtIntervalo.Text' := IntToStr(FACBrNFSeX.Configuracoes.WebServices.IntervaloTentativas);

      //TimeOut   := seTimeOut.Value;
      ProxyHost := 'edtProxyHost.Text';
    ProxyPort := 'edtProxyPorta.Text';
    ProxyUser := 'edtProxyUser.Text';
    ProxyPass := 'edtProxySenha.Text';
  end;

  //FACBrNFSeX.SSL.SSLType := TSSLType(cbSSLType.ItemIndex);

  with FACBrNFSeX.Configuracoes.Arquivos do
  begin
    NomeLongoNFSe := True;
    //Salvar           := chkSalvarArq.Checked;
    //SepararPorMes    := cbxPastaMensal.Checked;
    //AdicionarLiteral := cbxAdicionaLiteral.Checked;
    //EmissaoPathNFSe  := cbxEmissaoPathNFSe.Checked;
    //SepararPorCNPJ   := cbxSepararPorCNPJ.Checked;
    PathSchemas := 'edtPathSchemas.Text';
    PathGer := 'edtPathLogs.Text';
    PathMensal := GetPathGer(0);
    PathSalvar := PathMensal;
  end;

  if FACBrNFSeX.DANFSe <> nil then
  begin
    // TTipoDANFSE = ( tpPadrao, tpIssDSF, tpFiorilli ); //NO CÓDIGO ORIGINAL ESTÁ COMENTADO
    FACBrNFSeX.DANFSe.TipoDANFSE := tpPadrao;
    FACBrNFSeX.DANFSe.Logo := 'edtLogoMarca.Text';
    FACBrNFSeX.DANFSe.Prefeitura := 'edtPrefeitura.Text';
    FACBrNFSeX.DANFSe.PathPDF := 'edtPathPDF.Text';

    FACBrNFSeX.DANFSe.Prestador.Logo := 'edtPrestLogo.Text';

    FACBrNFSeX.DANFSe.MargemDireita := 5;
    FACBrNFSeX.DANFSe.MargemEsquerda := 5;
    FACBrNFSeX.DANFSe.MargemSuperior := 5;
    FACBrNFSeX.DANFSe.MargemInferior := 5;
  end;

  with FACBrNFSeX.MAIL do
  begin
    Host := 'edtSmtpHost.Text';
    Port := 'edtSmtpPort.Text';
    Username := 'edtSmtpUser.Text';
    Password := 'edtSmtpPass.Text';
    From := 'edtEmailRemetente.Text';
    FromName := 'edtEmitRazao.Text';
    //SetTLS    := cbEmailTLS.Checked;
    //SetSSL    := cbEmailSSL.Checked;
    UseThread := False;

    ReadingConfirmation := False;
  end;

  // A propriedade CodigoMunicipio tem que ser a ultima a receber o seu valor
  // Pois ela se utiliza das demais configurações
  with FACBrNFSeX.Configuracoes.Geral do
  begin
    //LayoutNFSe := TLayoutNFSe(cbLayoutNFSe.ItemIndex);
    CodigoMunicipio := StrToIntDef('edtCodCidade.Text', -1);
  end;

  //lblSchemas.Caption := FACBrNFSeX.Configuracoes.Geral.xProvedor;

  if FACBrNFSeX.Configuracoes.Geral.Layout = loABRASF then
  //lblLayout.Caption := 'ABRASF'
  else
  //lblLayout.Caption := 'Próprio';

  //lblVersaoSchemas.Caption := VersaoNFSeToStr(FACBrNFSeX.Configuracoes.Geral.Versao);

  if FACBrNFSeX.Configuracoes.Geral.Provedor = proPadraoNacional then
  begin
    //pgcProvedores.Pages[0].TabVisible := False;
    //pgcProvedores.Pages[1].TabVisible := True;
  end
  else
  begin
    //pgcProvedores.Pages[0].TabVisible := True;
    //pgcProvedores.Pages[1].TabVisible := False;
  end;
end;

end.
