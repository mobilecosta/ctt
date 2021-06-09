#INCLUDE "TCTTA060.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { {	'PD5'/* Tabela */, STR0002 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */,; // "Perguntas de Pesquisas"
						{ { "PD5_FILIAL", "xFilial('PD5')" }, { "PD5_PESQ", "PD5_PESQ" }  } /* Relation */,;
						"PD5_PESQ,PD5_DESCRI,PD5_DTGRV" /* Fields Modelo 1 */, /* AutoIncremento */ "PD5_ITEM", 20 /* Area do Componente */,;
						{}  /* Unique Line */ } } 
STATIC cFunName	:= "TCTTA060"
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do Cadastro de Perguntas de Pesquisas

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA060

Local cFilter := ""

U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo do cadastro de Cursos

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0004  ACTION 'PesqBrw'             	OPERATION 1 ACCESS 0 //"Pesquisar"
ADD OPTION aRotina TITLE STR0005 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
ADD OPTION aRotina TITLE STR0006    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 3 ACCESS 0 //"Incluir"
ADD OPTION aRotina TITLE STR0007    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 4 ACCESS 0 //"Alterar"
ADD OPTION aRotina TITLE STR0008    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 5 ACCESS 0 //"Excluir"

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
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
@since 05/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ViewDef()

Return &("StaticCall(TCTTXMVC,VIEWDEF)")


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Ativação do modelo do cadastro de perguntas das pesquisas

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
	//-- 1. Uso em Pesquisa de Satisfação
	BeginSQL Alias "PD4QRY"
		SELECT MIN(PD4_PESQ) AS PD4_PESQ, MIN(PD4_TURMA) AS PD4_TURMA, MIN(PD4_ALUNO) AS PD4_ALUNO
	  	  FROM %table:PD4%
	 	 WHERE %notDel% AND PD4_FILIAL = %Exp:xFilial("PD4")% AND PD4_PESQ = %Exp:PD5->PD5_PESQ%
	EndSql

	If ! Empty(PD4QRY->PD4_PESQ)
		Aadd(aError, STR0003 +; //"PD4-Perguntas das pesquisas em uso na pesquisa de satisfação/turma/aluno ["
                    PD4QRY->PD4_PESQ + "/" + PD4QRY->PD4_TURMA + "/" + PD4QRY->PD4_ALUNO + "]")
	EndIf
	PD4QRY->(DbCloseArea())

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