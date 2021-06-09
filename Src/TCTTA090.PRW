#INCLUDE "TCTTA090.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { { 	'PD8'/* Tabela */, STR0002 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */, { } /* Relation */,; //"Template de EMail"
						"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 0 /* Area do Componente */, {} /* Unique Line */ } }
STATIC cFunName	:= "TCTTA090"
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do cadastro de Template de EMail

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA090

Local cFilter := ""

U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Menu do cadastro de Template de EMail

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0005  ACTION 'PesqBrw'             	OPERATION 1 ACCESS 0 //"Pesquisar"
ADD OPTION aRotina TITLE STR0006 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
ADD OPTION aRotina TITLE STR0007    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 3 ACCESS 0 //"Incluir"
ADD OPTION aRotina TITLE STR0008    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 4 ACCESS 0 //"Alterar"
ADD OPTION aRotina TITLE STR0009    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 5 ACCESS 0 //"Excluir"

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

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Ativação do modelo do cadastro de Salas

@author Wagner Mobile Costa
@version P12
@since 07/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function Activate(oModel)

Local nOperation := 0
Local aError	 := {}, cError := "", nError := 0
Local aArea		 := GetArea()

If oModel == Nil	//-- É realizada chamada com modelo nulo para verificar se a função existe
	Return .F.
EndIf

nOperation := oModel:GetOperation()

If nOperation == MODEL_OPERATION_DELETE
	//-- 1. Uso em EMail de Pesquisas
	BeginSQL Alias "PDHQRY"
		SELECT MIN(PDH_CODIGO) AS PDH_CODIGO
	  	  FROM %table:PDH%
	 	 WHERE %notDel% AND PDH_FILIAL = %Exp:xFilial("PDH")% AND PDH_TEMPLA = %Exp:PD8->PD8_CODIGO%
	EndSql

	If ! Empty(PDHQRY->PDH_CODIGO)
		Aadd(aError, STR0003 + PDHQRY->PDH_CODIGO + STR0004) //"PDH-Template de EMail em uso no assunto da pesquisa código ["###"]"
	EndIf
	PDHQRY->(DbCloseArea())

	If Len(aError) > 0
		For nError := 1 To Len(aError)
			If ! Empty(cError)
				cError += Chr(13) + Chr(10)
			EndIf
			cError += aError[nError]
		Next
		Help(,, "EMUSO",, cError, Len(aError), 0)
	EndIf
EndIf

RestArea(aArea)

Return Len(aError) == 0