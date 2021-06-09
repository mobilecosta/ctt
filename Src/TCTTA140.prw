#INCLUDE "tctta140.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

Static lAprova  := .F.
STATIC aForms 	:= { { 	"PD3"/* Tabela */, STR0001 /* Descrição */, .F. /* SetOptional */, .T.  /* SetOnlyView */, { } /* Relation */,; //"Aprovação Alteração Alocação"
						"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 50 /* Area do Componente */, ""  /* Unique Line */ },;
               		 { 	"PD7", STR0002,  .T., .F., { { "PD7_FILIAL", "xFilial('PD7')" }, { "PD7_TURMA", "PD3_TURMA" } }, "", "PD7_ITEM", 50, { "PD7_ALUNO" } } } //"Alocação"
STATIC cFunName	:= "TCTTA140"
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina para aprovação de alterações na alocação dos alunos

@author Wagner Mobile Costa
@version P12
@since 14/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA140()

Local cFilter := "PD3_STATUS = 'S'"

U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo do cadastro de Alocação

@author Wagner Mobile Costa
@version P12
@since 14/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0005  	ACTION 'PesqBrw'            OPERATION 1 ACCESS 0 //"Pesquisar"
If lAprova
	ADD OPTION aRotina TITLE STR0006    	ACTION 'U_TCTT140P' 		OPERATION 4 ACCESS 0 //"Aprovar"
Else
	ADD OPTION aRotina TITLE STR0007 	ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0008    ACTION 'U_TCTT140M' 		OPERATION 4 ACCESS 0 //"Aprovação"
EndIf

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo

@author Wagner Mobile Costa
@version P12
@since 14/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ModelDef()

aFormsMVC := AClone(aForms)
SetFunName(cFunName)

Return &("StaticCall(TCTTXMVC,MODELDEF)")

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Tela para seleção dos alunos da turma que irão ter alteração da alocação aprovada

@author Wagner Mobile Costa
@version P12
@since 14/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
User Function TCTT140M()

oMark := FWMarkBrowse():New()
oMark:SetAlias('PD7')
oMark:SetSemaphore(.T.)
oMark:SetDescription('Aprovação de alteração de alocação da turma [' + PD3->PD3_TURMA + "]")
oMark:SetFieldMark( 'PD7_EV' )
oMark:SetAllMark( { || oMark:AllMark() } )
oMark:SetFilterDefault("PD7_FILIAL = '" + xFilial() + "' .AND. PD7_TURMA = '" + PD3->PD3_TURMA + "' .AND. PD7_APROVA <> 'A'")
lAprova := .T.	//-- Ativa variavel para o uso no MenuDef 
oMark:Activate()

lAprova := .F.

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina para atualização dos alunos selecionados para aprovação

@author Wagner Mobile Costa
@version P12
@since 14/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
User Function TCTT140P()

Local aArea    := GetArea()
Local nAprova  := 0

FWMARKBRW->(DbGoTop())
While ! FWMARKBRW->(EOF())
	PD7->(DbGoTo(Val(FWMARKBRW->RECNO)))

	If PD7->PD7_APROVA	<> "A"
		RecLock("PD7" , .F. )
		PD7->PD7_APROVA	:= "A"
		MsUnLock()
		nAprova ++
	EndIf
	
	FWMARKBRW->(DbSkip())
EndDo
MsgAlert(STR0003 + AllTrim(Str(nAprova)) + STR0004 + PD3->PD3_TURMA + "] !") //"Foram aprovados a alteração da alocação de ("###") alunos da turma ["
RestArea(aArea)

Return