#INCLUDE "TCTTA040.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { { 	STR0001/* Tabela */, STR0002 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */, { } /* Relation */,; //"PDO"###"Cadastro de Salas"
					"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 0 /* Area do Componente */, {} /* Unique Line */ } }
STATIC cFunName	:= "TCTTA040"
STATIC cFilter	:= ""
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do cadastro de Salas

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA040

U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Menu do cadastro de Salas

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
	//-- 1. Uso em Turmas
	BeginSQL Alias "PD3QRY"
		SELECT MIN(PD3_TURMA) AS PD3_TURMA
	  	  FROM %table:PD3%
	 	 WHERE %notDel% AND PD3_FILIAL BETWEEN %Exp:Repl(" ", Len(xFilial("PD3")))% AND %Exp:Repl("Z", Len(xFilial("PD3")))%
	 	   AND PD3_SALA = %Exp:PDO->PDO_SALA%
	EndSql

	If ! Empty(PD3QRY->PD3_TURMA)
		Aadd(aError, STR0003 + PD3QRY->PD3_TURMA + STR0004) //"PD3-Sala em uso na turma ["###"]"
	EndIf
	PD3QRY->(DbCloseArea())

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