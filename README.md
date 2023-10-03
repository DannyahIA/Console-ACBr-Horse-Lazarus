#  Como criar uma Aplicação Console com ACBr e Horse no Lazarus:

- Seguindo os passos no fórum:
  
  https://www.projetoacbr.com.br/forum/topic/57850-como-criar-aplica%C3%A7oes-console-com-acbr-e-lazarusfpc/

  Para acessar as Variáveis Ambientes do Windows:
  - Clique com o botão direito em "Este Computador" no Explorador de Arquivos e selecione "Propriedades";
  - Abrirá a aba "Sobre" nela há "Configurações relacionadas" onde deve clicar em "Configurações avançadas do sistema";
  - Agora dentro de "Propriedades do Sistema" clique no botão "Variáveis de Ambiente...";
  - Agora clique em "Novo..." abaixo do quadro das "Variáveis de usuário para 'MeuNome'".
  - Defina o "Nome da variável:" como "ACBR_HOME" e clique em "Procurar Diretório" e selecione o diretório da pasta "...\ACBr\Fontes".
 
  - Agora é só colar o caminho a seguir na área "Path" do Lazarus:

        modules\.dcp;modules\.dcu;modules;modules\dotenv4delphi\src;modules\horse\src;modules\horse-basic-auth\src;modules\horse-compression\src;modules\horse-cors\src;modules\horse-logger\src;modules\horse-logger-provider-console\src;modules\horse-utils-clientip\src;modules\jhonson\src;modules\json4laz\src;$(ACBrDir)\ACBrDFe\ACBrNFSeX;$(ACBrDir)\Terceiros\synalist;$(ACBrDir)\ACBrComum;$(ACBrDir)\ACBrDFe;$(ACBrDir)\PCNComum;$(ACBrDir)\Terceiros\FastStringReplace;$(ACBrDir)\Terceiros\GZIPUtils;$(ACBrDir)\ACBrDiversos;$(ACBrDir)\ACBrTCP;$(ACBrDir)\ACBrIntegrador;$(ACBrDir)\ACBrIntegrador\pcnVFPe;$(ACBrDir)\Terceiros\CodeGear;$(ACBrDir)\ACBrOpenSSL;$(ACBrDir)\Terceiros\Ole;$(ACBrDir)\ACBrDFe\ACBrNFSeX\Base;$(ACBrDir)\ACBrDFe\ACBrNFSeX\Base\WebServices;$(ACBrDir)\ACBrDFe\ACBrNFSeX\DANFSE;$(ACBrDir)\ACBrDFe\ACBrNFSeX\Base\Provedores;$(ACBrDir)\ACBrDFe\ACBrNFSeX\Provedores;C:\fpcupdeluxe\lazarus\components\lazutils\;C:\fpcupdeluxe\lazarus\lcl\;C:\fpcupdeluxe\lazarus\lcl\widgetset\;model\dto;controller;service