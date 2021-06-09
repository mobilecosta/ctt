#INCLUDE "TCTTA240.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { { 	'PD4'/* Tabela */, STR0002 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */,; //"Respostas da Pesquisa Satisfação"
					{ { "PD4_FILIAL", "xFilial('PD4')" }, { "PD4_PESQ", "PD4_PESQ" }, { "PD4_TURMA", "PD4_TURMA" }, { "PD4_PERIO", "PD4_PERIO" },;
					  { "PD4_ALUNO", "PD4_ALUNO" } } /* Relation */,;
						"PD4_PESQ,PD4_TURMA,PD4_PERIO,PD4_ALUNO,PD4_NOME" /* Fields Modelo 1 */, /* AutoIncremento */ "", 30 /* Area do Componente */,;
						""  /* Unique Line */ } }		
STATIC cFunName	:= "TCTTA240"
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção das Respostas da Pesquisa Satisfação

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA240

Local cFilter := ""

U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem do Menu das Respostas da Pesquisa Satisfação

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
ADD OPTION aRotina TITLE STR0005    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 5 ACCESS 0 //"Excluir"

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
Gravação do modelo do Respostas da Pesquisa Satisfação

@author Wagner Mobile Costa
@version P12
@since 20/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function Commit(oModel)

Local oModelPD4, cSQL := ""
Local lRet := .T.

If oModel <> Nil	//-- É realizada chamada com modelo nulo para verificar se a função existe
   nOperation := oModel:GetOperation()
   oModelPD4  := oModel:GetModel("PD4")
   M->PD4_TURMA := oModelPD4:GetValue("PD4_TURMA")
   M->PD4_ALUNO := oModelPD4:GetValue("PD4_ALUNO")

   BEGIN TRANSACTION

   FwFormCommit(oModel)  // Grava o Modelo

   cSQL := "UPDATE " + RetSqlName("PD7") + " SET PD7_PESQRP = PD7_PESQRP + " + If(nOperation = MODEL_OPERATION_DELETE, "-1", "1") + " " +; 
         " WHERE D_E_L_E_T_ = ' ' AND PD7_FILIAL = '" + xFilial("PD7") + "' AND PD7_TURMA = '" + M->PD4_TURMA + "' " +;
            "AND PD7_ALUNO = '" + M->PD4_ALUNO + "'" 

   If (nError := TCSQLExec(cSQL)) <> 0
      Help(,, cFunName - ":PD7_PESQOK",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
      lRet := .F.
      DisarmTran()

      Break
   EndIf

   END TRANSACTION
EndIf


Return lRet
