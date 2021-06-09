#INCLUDE "TCTTA080.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { 	{ 	'PDH'/* Tabela */, STR0002 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */,; //"Assunto E-mails - Pesquisa Satisfação"
						{ { "PDH_FILIAL", "xFilial('PDH')" }, { "PDH_CODIGO", "PDH_CODIGO" }  } /* Relation */,;
						"PDH_CODIGO,PDH_DESCRI,PDH_DTGRV,PDH_MSBLQL" /* Fields Modelo 1 */, /* AutoIncremento */ "PDH_ITEM", 20 /* Area do Componente */,;
						{} /* Unique Line */ } }
STATIC cFunName	:= "TCTTA080"
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do Cadastro de Assunto E-mails - Pesquisa Satisfação

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA080

Local cFilter := ""

U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem do Menu do cadastro de Assunto E-mails - Pesquisa Satisfação

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0003  ACTION 'PesqBrw'             	OPERATION 1 ACCESS 0 //"Pesquisar"
ADD OPTION aRotina TITLE STR0004 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
ADD OPTION aRotina TITLE STR0005    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 3 ACCESS 0 //"Incluir"
ADD OPTION aRotina TITLE STR0006    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 4 ACCESS 0 //"Alterar"
ADD OPTION aRotina TITLE STR0007    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 5 ACCESS 0 //"Excluir"

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ModelDef()

aFormsMVC := AClone(aForms)
SetFunName(cFunName)

Return &("StaticCall(TCTTXMVC,MODELDEF)")

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Apresentação do Modelo

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ViewDef()

Return &("StaticCall(TCTTXMVC,VIEWDEF)")