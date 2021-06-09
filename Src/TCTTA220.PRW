#INCLUDE "tctta220.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { { 	"PD6"/* Tabela */, STR0001 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */, { } /* Relation */,; //"Propostas"
"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 50 /* Area do Componente */, {} /* Unique Line */ },;
	{ 	"PD9", STR0002,  .F., .F., { { "PD9_FILIAL", "xFilial('PD9')" }, { "PD9_PROPOS", "PD6_PROPOS" } }, ; //"Itens das Propostas"
"", "PD9_ITEM", 50, {} } }
STATIC cFunName	:= "TCTTA220"
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do cadastro de Propostas

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA220

	Local cFilter := ""

	Private aRotina := &("StaticCall(" + cFunName + ", MENUDEF)")

	U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem do Menu do Cadastro de Propostas

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE STR0006  ACTION 'PesqBrw'             	OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE STR0007 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0008    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE STR0009    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE STR0010 ACTION 'U_TCTTR160()' 	OPERATION 4 ACCESS 0 //"Historico proposta"
	ADD OPTION aRotina TITLE STR0011    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Controle Recorrencia" ACTION 'U_TCTTR200()' 	OPERATION 4 ACCESS 0 //"Historico proposta"
	ADD OPTION aRotina TITLE "Conhecimento" ACTION 'MsDocument' OPERATION 3 ACCESS 0

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
Ativação do modelo do cadastro de Propostas

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
	//-- 1. Uso em Alocações
		BeginSQL Alias "PD7QRY"
			SELECT MIN(PD7.PD7_TURMA) AS PD7_TURMA, MIN(PD7.PD7_ALUNO) AS PD7_ALUNO, MIN(PDL.PDL_NOME) AS PDL_NOME
			FROM %table:PD7% PD7
			LEFT JOIN %table:PDL% PDL ON PDL.%notDel% AND PDL.PDL_FILIAL = %Exp:xFilial("PDL")% AND PDL.PDL_ALUNO = PD7.PD7_ALUNO
			WHERE PD7.%notDel% AND PD7.PD7_FILPRO = %Exp:xFilial("PD6")% AND PD7.PD7_PROPOS = %Exp:PD6->PD6_PROPOS%
		EndSql

		If ! Empty(PD7QRY->PD7_ALUNO)
			Aadd(aError, STR0003 + PD7QRY->PD7_ALUNO + "-" + PD7QRY->PDL_NOME + "/" + PD7QRY->PD7_TURMA + "]") //"PD7-Proposta em uso na alocação do Aluno na turma ["
		EndIf
		PD7QRY->(DbCloseArea())

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

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Pós Validação (TudoOk) do modelo do cadastro de Propostas

@author Wagner Mobile Costa
@version P12
@since 07/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function PosValid(oModel)

Local oModelPD6, oModelPD9, lRet := .T., nLine := 0

If oModel == Nil //-- É realizada chamada com modelo nulo para verificar se a função existe
	Return .T.
EndIf

oModelPD6 := oModel:GetModel( 'PD6' )	//-- Propostas
oModelPD9 := oModel:GetModel( 'PD9' )	//-- Itens das Propostas

If M->PD6_TIPO <> '2' //Proposta que nao e´recorrente
	M->PD6_VALOR := 0
	M->PD6_HORAS := 0
	
	For nLine := 1 To oModelPD9:Length()
		oModelPD9:GoLine( nLine )
		M->PD6_VALOR += oModelPD9:GetValue("PD9_VALTOT")
		M->PD6_HORAS += oModelPD9:GetValue("PD9_QTDHRS")
	Next nI
	
	If oModel:GetOperation() <> MODEL_OPERATION_DELETE
		oModelPD6:SetValue("PD6_VALOR", M->PD6_VALOR-((oModelPD6:GetValue("PD6_DESCON")/100)*M->PD6_VALOR))
		oModelPD6:SetValue("PD6_HORAS", M->PD6_HORAS)
	EndIf
	M->PD6_SLDHS := M->PD6_HORAS
	M->PD7_HORAS := 0
	
	If oModel:GetOperation() <> MODEL_OPERATION_INSERT
		BeginSQL Alias "PD6QRY"
			SELECT SUM(PD7_HORAS) AS PD7_HORAS
			FROM %table:PD7%
			WHERE PD7_FILPRO = %Exp:xFilial('PD6')% AND PD7_PROPOS = %Exp:M->PD6_PROPOS% AND PD7_CONFIR <> '6' AND PD7_CONFIR <> '7' AND %notDel%
		EndSQL
		
		M->PD7_HORAS := PD6QRY->PD7_HORAS
		PD6QRY->(DbCloseArea())
	EndIf
	
	If M->PD6_SLDHS - M->PD7_HORAS < 0
		Help(,, "PD6_SLDHS",, STR0004 + AllTrim(Str(M->PD7_HORAS)) + STR0005, 1, 0) //"Atenção. Já foi(ram) alocada(s) ["###"] hora(s) para esta proposta !"
		lRet := .F.
	ElseIf oModel:GetOperation() <> MODEL_OPERATION_DELETE
		oModelPD6:SetValue("PD6_SLDHS", M->PD6_SLDHS)
	EndIf
Else
	
	M->PD6_SLDHS := M->PD6_HORAS
	M->PD7_HORAS := 0
	
	//Calculo de saldo total
	nDifDt := M->PD6_DATA - M->PD6_VENCTO
	If nDifDt < 0
		nDifDt := nDifDt * (-1)
	EndIf
	nDifDt := nDifDt/30
	nDifDt := Int(nDifDt)
	nSldTOT := nDifDt * PD6->PD6_HORAS
	M->PD6_SLDPRO	:= nSldTOT	
	//Fim do Calculo	 
	If oModel:GetOperation() <> MODEL_OPERATION_INSERT
		//Busca as alocações no periodo atual
		cQuery2 := "SELECT SUM(PD7_HORAS) AS PD7_HORAS"
		cQuery2 += " FROM " + RETSQLNAME("PD7") + " PD7 "
		cQuery2 += " JOIN " + RetSqlName ("PD3") +" PD3 ON PD3_FILIAL = PD7_FILIAL AND PD3_TURMA = PD7_TURMA AND PD3.D_E_L_E_T_ = ' ' "
		cQuery2 += " WHERE PD7.PD7_FILPRO = '" + M->PD6_FILIAL +"' AND PD7.PD7_PROPOS = '" + M->PD6_PROPOS +"' AND PD7.D_E_L_E_T_ = ' ' "
		cQuery2 += " AND PD7.PD7_CONFIR <> '6' AND PD7.PD7_CONFIR <> '7'"
		cQuery2 += " AND PD3.PD3_DTINI >= '"+Dtos(M->PD6_DTINI)+"' AND PD3.PD3_DTFIM <= '"+Dtos(M->PD6_DTFINA)+"'"
		cQuery2 += " AND PD3.D_E_L_E_T_ = ' '"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2), "PD6QRY" )
		TCSetField("PD6QRY","PD3_DTINI" , "D",08,00)
		dbGotop()
		If !Eof()
			M->PD7_HORAS := PD6QRY->PD7_HORAS
			PD6QRY->(DbCloseArea())
		EndIf
	EndIf
	
	If M->PD6_SLDHS - M->PD7_HORAS < 0
		Help(,, "PD6_SLDHS",, STR0004 + AllTrim(Str(M->PD7_HORAS)) + STR0005, 1, 0) //"Atenção. Já foi(ram) alocada(s) ["###"] hora(s) para esta proposta !"
		lRet := .F.
	ElseIf oModel:GetOperation() <> MODEL_OPERATION_DELETE
		oModelPD6:SetValue("PD6_SLDHS", M->PD6_SLDHS)
	EndIf
EndIf

//Proposta Recorrente Valida o preenchimento dos campos na inclusao
If lRet .And. oModel:GetOperation() == MODEL_OPERATION_INSERT .And. M->PD6_TIPO == '2'
	If Empty(M->PD6_DTINI) .Or. Empty(M->PD6_NRODIA) .Or. Empty(M->PD6_HSRECO) .Or. Empty(M->PD6_TOTREC)
		Help(,, "CAMPOS DE RECORRENCIA",, "Existe campos da ABA Recorrencia sem preencher que precisam ser preenchidos para salvar a proposta!", 1, 0)
		lRet := .F.
	Else
		oModelPD6:SetValue("PD6_SLDHS", M->PD6_HSRECO)
	EndIf
EndIf

If lRet .And. oModel:GetOperation() == MODEL_OPERATION_UPDATE .And. M->PD6_TIPO == '2'
	nDif := M->PD6_HSRECO - PD6->PD6_HSRECO
	If nDif <> 0
		oModelPD6:SetValue("PD6_SLDHS", PD6->PD6_HSRECO+nDif)
	EndIf
EndIf

Return lRet

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Gravação do modelo do cadastro de Propostas

@author Wagner Mobile Costa
@version P12
@since 07/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function Commit(oModel)
Local lRet := .T.

	If oModel <> Nil	//-- É realizada chamada com modelo nulo para verificar se a função existe

		nOperation := oModel:GetOperation()

	// Integração COM VLabs
		If oModel:GetOperation() = MODEL_OPERATION_DELETE
		// Integração COM VLabs
			cRetVLab := u_WsAloca(MODEL_OPERATION_DELETE)
		EndIf
		
		BEGIN TRANSACTION

	//-- Na atualização retorna o saldo de horas para proposta
			If nOperation == MODEL_OPERATION_UPDATE
				If ! T220HrsPD6(MODEL_OPERATION_DELETE, "PD6_FILIAL = '" + xFilial("PD6") + "' AND PD6_PROPOS = '" + M->PD6_PROPOS + "'")
					lRet := .F.
					Break
				EndIf
			EndIf

			FwFormCommit(oModel)  // Grava o Modelo

	//-- Inclusão/Alteração
			If nOperation <> MODEL_OPERATION_DELETE
				If ! T220HrsPD6(nOperation, "PD6_FILIAL = '" + xFilial("PD6") + "' AND PD6_PROPOS = '" + M->PD6_PROPOS + "'")
					lRet := .F.
					Break
				EndIf
			EndIf
		END TRANSACTION
	EndIf

Return lRet

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Atualização do campo PD6_SLDHRS a partir da alocação de alunos

@author Wagner Mobile Costa
@version P12
@since 07/04/2015
@param nOperation = MODEL_OPERATION (MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE e MODEL_OPERATION_DELETE)
       cPD6_PROPOS = Lista de propostas a serem atualizadas '000001', '000002', etc ...
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function T220HrsPD6(nOperation, cPD6_PROPOS)

	Local cSQL := "UPDATE " + RetSqlName("PD6") + " SET PD6_SLDHS = ", nError := 0

	If nOperation == MODEL_OPERATION_DELETE
		cSQL += "PD6_HORAS"
	Else
		cSQL += "PD6_SLDHS - COALESCE((SELECT SUM(PD7.PD7_HORAS) " +;
			"FROM " + RetSqlName("PD7") + " PD7 " +;
			"JOIN " + RetSqlName("PD3") + " PD3 ON PD3.D_E_L_E_T_ = ' ' AND PD3.PD3_FILIAL = PD7.PD7_FILIAL " +;
			"AND PD3.PD3_TURMA = PD7.PD7_TURMA " +;
			"WHERE PD7.D_E_L_E_T_ = ' ' AND PD7.PD7_FILPRO =  " + RetSqlName("PD6") + ".PD6_FILIAL " +;
            " AND PD7.PD7_CONFIR <> '6' AND PD7.PD7_CONFIR <> '7' " +;
			"AND PD7.PD7_PROPOS = " + RetSqlName("PD6") + ".PD6_PROPOS), 0)"
	EndIf

	cSQL += " WHERE D_E_L_E_T_ = ' ' AND " + cPD6_PROPOS

	If (nError := TCSQLExec(cSQL)) <> 0
		Help(,, "T220HRSPD6",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
		DisarmTran()
	EndIf

Return nError == 0



