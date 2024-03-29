#INCLUDE "tctta130.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { { 	"PD3"/* Tabela */, STR0001 /* Descri��o */, .F. /* SetOptional */, .T.  /* SetOnlyView */, { } /* Relation */,; //"Aloca��o"
"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 50 /* Area do Componente */, ""  /* Unique Line */ },;
	{ 	"PD7", STR0002,  .T., .f., { { "PD7_FILIAL", "xFilial('PD7')" }, { "PD7_TURMA", "PD3_TURMA" } }, "",; //"Aloca��o de Alunos"
"PD7_ITEM", 50, { "PD7_ALUNO", "PD7_PROPOS" }  /* Unique Line */  } }
STATIC cFunName	:= "TCTTA130"
STATIC aLegend  := { { 	"PD3_STATUS=='N'","BR_PRETO", STR0003 },; //"Turma n�o Confirmada"
                     { 	"PD3_STATUS=='S' .And. PD3_ALOCAD > 0","BR_AZUL", STR0004 },; //"Turma com aloca��o"
                     { 	"PD3_STATUS=='S'","BR_VERDE", STR0005 },; //"Turma Confirmada"
                     { 	"PD3_STATUS=='C'","BR_VERMELHO", STR0006 } } //"Turma Cancelada"
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manuten��o do cadastro de Aloca��o

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA130

	U_TCTTBrowse(aForms, cFunName, "", aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo do cadastro de Aloca��o

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE STR0025  	ACTION 'PesqBrw'            OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE STR0026 	ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0027	ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 4 ACCESS 0 //"Alocar"
	ADD OPTION aRotina TITLE STR0028 	ACTION 'U_TCTTA131()' 		OPERATION 4 ACCESS 0 //"Certificados"
	ADD OPTION aRotina TITLE STR0029	ACTION 'U_TCTTA133()'  		OPERATION 4 ACCESS 0 //"Envio EMail Inscri��o"
	ADD OPTION aRotina TITLE STR0030 	ACTION 'U_TCTTR120()'		OPERATION 4 ACCESS 0 //"Lista de Presen�a"
	ADD OPTION aRotina TITLE STR0031 	ACTION 'U_TCTTA220()' 		OPERATION 4 ACCESS 0 //"Propostas"
	ADD OPTION aRotina TITLE STR0032 	ACTION 'U_TCTTA132()' 		OPERATION 4 ACCESS 0 //"Envio EMail Confirma��o"
	ADD OPTION aRotina TITLE STR0033 	ACTION 'U_TCTTR050()' 		OPERATION 4 ACCESS 0 //"Relat�rio Aloca��es"
	ADD OPTION aRotina TITLE STR0034 	ACTION 'U_LmsIntegrar()'	OPERATION 4 ACCESS 0 //"Integrar com LMS"

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
Regras de Apresenta��o do Modelo

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
pre Valida��o (TudoOk) do modelo da aloca��o de turmas

@author Fabio Veiga Oliva
@version P12
@since 20/12/2019
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function PreValid(oModel)
Local _dDtFim := PD3->PD3_DTFIM + SuperGetMV("TI_CT050P",.F.,30)
If oModel == Nil .Or.;
	oModel:GetOperation() = MODEL_OPERATION_DELETE .or.;
	oModel:GetOperation() = MODEL_OPERATION_VIEW
	//-- � realizada chamada com modelo nulo para verificar se a fun��o existe
	Return .T.
EndIf

//se a turma foi cancelada n�o permitir aloca��es
If PD3->PD3_STATUS = "C"                      
	Help(,, FunName() + ": PreValid",, "ATEN��O !!. A Turma est� cancelada e n�o pode ter aloca��o.", 1, 0)
	Return .F.
Endif

//se j� passou o prazo de alocacao da turma = PD3_DTFIM + PARAMETRO DE DIAS TI_CT050P n�o permite a aloca��o
If dDatabase > _dDtFim
	Help(,, FunName() + ": PreValid",, "ATEN��O !!. A Turma finalizou em:"+Dtoc(PD3->PD3_DTFIM)+" e s� poderia ter aloca��es at� dia:"+Dtoc(_dDtFim), 1, 0)
	Return .F.
Endif
return .t.


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
P�s Valida��o (TudoOk) do modelo da aloca��o de turmas

@author Wagner Mobile Costa
@version P12
@since 08/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function PosValid(oModel)

	Local oModelPD7
	Local nLine  := 0
	Local nTotal := 0
	Local nPos 	 := 0
	Local aError := {} 
	Local cError := ""
	Local nError := 0
	Local cPD7_CONFIR := cPD7_PROPOS := cMsg  := cPD7_FILPRO := cPD7_ALUNO := ""
	Local aMail 	:= {}, aCtrl := {}
	Local dDiaSem	:= DOW(PD3->PD3_DTINI), dDate := Date()
	Local lChkPrazo	:= .T., lError := lSomHr := .F.
	Local aPD7_CONF := RetSx3Box(POSICIONE("SX3", 2, "PD7_CONFIR", "X3CBOX()"),,, 1)
	Local aAreaPD3  := PD3->(GetArea())
	Local aHrsPD7	:= {}
                                                	
	If oModel == Nil .Or. oModel:GetOperation() = MODEL_OPERATION_DELETE	//-- � realizada chamada com modelo nulo para verificar se a fun��o existe
		Return .T.
	EndIf

	oModelPD7 := oModel:GetModel( 'PD7' )	//-- Aloca��o dos Alunos

	Do Case
	Case dDiaSem == 2 	// "Segunda-Feira"
		If (PD3->PD3_DTINI - dDate) > 5
			lChkPrazo := .F.
		Endif
	Case dDiaSem == 3	// "Terca-Feira"
		If (PD3->PD3_DTINI - dDate) > 6
			lChkPrazo := .F.
		Endif
	Case dDiaSem == 4	// "Quarta-Feira"
		If (PD3->PD3_DTINI - dDate) > 7
			lChkPrazo := .F.
		Endif
	Case dDiaSem == 5	// Quinta-Feira
		If (PD3->PD3_DTINI - dDate) > 8
			lChkPrazo := .F.
		Endif
	Case dDiaSem == 6	// Sexta-Feira
		If (PD3->PD3_DTINI - dDate) > 9
			lChkPrazo := .F.
		Endif
	Case dDiaSem == 7	// Sabado
		If (PD3->PD3_DTINI - dDate) > 10
			lChkPrazo := .F.
		Endif
	Case dDiaSem == 1	// Domingo
		If (PD3->PD3_DTINI - dDate) > 11
			lChkPrazo := .F.
		Endif
	EndCase

//-- Recupera as aloca��es da turma Controller
	If PD3->PD3_CONTRO = "S"
		PD7->(DbSeek(xFilial() + PD3->PD3_CTRCUR))
		While PD7->PD7_FILIAL == xFilial("PD7") .And. PD7->PD7_TURMA == PD3->PD3_CTRCUR .And. ! PD7->(Eof())
			If PD7->PD7_CONFIR = "1"  /* Confirmado */ .OR. PD7->PD7_CONFIR = "5" /* Cortesia */ .OR. PD7->PD7_CONFIR = "6"; /* Realocado */
				Aadd(aCtrl, PD7->PD7_ALUNO)
			EndIf
			PD7->(DbSkip())
		EndDo
	EndIf

	M->PD3_ALOCAD := 0
	M->PD3_ALOCAN := 0

	For nLine := 1 To oModelPD7:Length()
		oModelPD7:GoLine( nLine )

		If ! oModelPD7:IsDeleted()
			cPD7_CONFIR := oModelPD7:GetValue("PD7_CONFIR")
			cPD7_PROPOS := oModelPD7:GetValue("PD7_PROPOS")
			cPD7_FILPRO := oModelPD7:GetValue("PD7_FILPRO")
			If PD7->PD7_CONFIR = "1"  /* Confirmado */ .OR. PD7->PD7_CONFIR = "5" /* Cortesia */ .OR. PD7->PD7_CONFIR = "6"; /* Realocado */
				nTotal ++
			EndIf
			
			If PD7->PD7_CONFIR = "1"  /* Confirmado */ .OR. PD7->PD7_CONFIR = "5" /* Cortesia */ .OR. PD7->PD7_CONFIR = "6"; /* Realocado */
				M->PD3_ALOCAD++
			else
				M->PD3_ALOCAN++
			Endif
		
			If cPD7_CONFIR = "7"  .And. Empty(oModelPD7:GetValue("PD7_TURMAR"))
				Aadd(aError, "PD7_TURMAR-Falta preencher a turma de reposicao!" ) 
			EndIf

			If PD3->PD3_CONTRO = "S" .And. Empty(oModelPD7:GetValue("PD7_SEGMEN"))
				Aadd(aError, STR0007 + AllTrim(oModelPD7:GetValue("PD7_NOME")) + STR0008) //"PD7_SEGMEN-Aluno ["###"] para cursos controller � obrigat�rio o preenchimento do segmento !"
			EndIf

			If oModelPD7:IsInserted() .And. (cPD7_CONFIR = "1"  /* Confirmado */ .OR. cPD7_CONFIR = "3"  /* Cancelado fora do prazo (Perdeu Cridito */ .OR.;
					cPD7_CONFIR = "5" /* Cortesia */ .OR. cPD7_CONFIR = "6" /* Realocado */ .OR. cPD7_CONFIR = "7" /* Reposicao */)
			//-- Verifica se soma as horas para o turma controller (Aloca��o do aluno e/ou se o aluno n�o estiver na turma controller)
				cPD7_ALUNO := oModelPD7:GetValue("PD7_ALUNO")
				If PD3->PD3_CONTRO = "S" .And. Ascan(aCtrl, cPD7_ALUNO) == 0
					BeginSQL Alias "PD3CTL"
						SELECT PD3.PD3_QTDHOR
						FROM %table:PD3% PD3
						WHERE PD3.%notDel% AND PD3.PD3_TURMA = %Exp:PD3->PD3_CTRCUR%
					EndSql
	
					Aadd(aCtrl, cPD7_ALUNO)
					PD3CTL->(DbCloseArea())
				EndIf
			EndIf
			If PD3->PD3_CONTRO = "S"
				nPos := Ascan(aCtrl, oModelPD7:GetValue("PD7_ALUNO"))
				If nPos > 0
					aCtrl[nPos] := ""
				EndIf
			EndIf
		
			If (nPos := Ascan(aHrsPD7, { |x| x[1] == oModelPD7:GetValue("PD7_ALUNO") })) == 0
				Aadd(aHrsPD7, {oModelPD7:GetValue("PD7_ALUNO"), AllTrim(oModelPD7:GetValue("PD7_NOME")), 0})
				nPos := Len(aHrsPD7)
			EndIf
			aHrsPD7[nPos][3] += oModelPD7:GetValue("PD7_HORAS")
		EndIf
	Next

	For nPos := 1 To Len(aHrsPD7)
		If aHrsPD7[nPos][3] > 0 .And. aHrsPD7[nPos][3] <> M->PD3_QTDHOR
			Aadd(aError, "A aloca��o de horas do aluno [" + aHrsPD7[nPos][1] + "-" + aHrsPD7[nPos][2] + "] � inferior a carga horaria do curso !")
		EndIf
	Next

	If nTotal > PD3->PD3_VAGAS
		Aadd(aError, STR0012+ cValToChar(PD3->PD3_VAGAS) +STR0013) //"PD3_VAGAS-Poder� ser alocado no m�ximo "###" alunos para essa turma."
	Endif

	If PD3->PD3_CONTRO = "S"
		PD3->(DbSeek(xFilial() + PD3->PD3_CTRCUR))
		nTotal := 0
		For nPos := 1 To Len(aCtrl)
			If ! Empty(aCtrl[nPos])
				nTotal ++
			EndIf
		Next
		If nTotal > PD3->PD3_VAGAS
			Aadd(aError, STR0012+ cValToChar(PD3->PD3_VAGAS) +STR0014) //"PD3_VAGAS-Poder� ser alocado no m�ximo "###" alunos para turma controller."
		EndIf
		PD3->(RestArea(aAreaPD3))
	EndIf

	If lChkPrazo
		For nLine := 1 To oModelPD7:Length()
			oModelPD7:GoLine( nLine )

			If ! oModelPD7:IsInserted() .And. oModelPD7:IsDeleted()
			//-- 48 horas Precisa de aprova��o
				If (PD3->PD3_DTINI - DATE()) <= 2 .And. Empty(oModelPD7:GetValue("PD7_APROVA"))
					Aadd(aError, STR0015 + AllTrim(oModelPD7:GetValue("PD7_NOME")) + STR0019) //"PD7_APROVA-Para exclus�o da aloca��o do Aluno [" //"] � necess�rio aprova��o. Procure o respons�vel !"
				Else
					Aadd(aMail, { oModelPD7:GetValue(STR0016), oModelPD7:GetValue("PD7_NOMEC"), "", PD7->PD7_CONFIR }) //"PD7_NOME"

					If ! Empty(cMsg)
						cMsg += Chr(13) + Chr(10)
					EndIf
					cMsg += "Aluno [" + AllTrim(oModelPD7:GetValue("PD7_NOME")) + STR0017 //"]-Exclus�o da aloca��o"
				EndIf
			ElseIf ! oModelPD7:IsInserted() .And. oModelPD7:IsUpdated() .And. oModelPD7:GetValue("PD7_CONFIR") <> "3"	//-- 3. Cancelamento fora do prazo
			//-- 48 horas Precisa de aprova��o
				PD7->(DbSeek(xFilial() + PD3->PD3_TURMA + oModelPD7:GetValue("PD7_ALUNO") + oModelPD7:GetValue("PD7_PROPOS")))
				If ! PD7->(Eof()) .And. oModelPD7:GetValue("PD7_CONFIR") <> PD7->PD7_CONFIR
					If (PD3->PD3_DTINI - DATE()) <= 2 .And. Empty(oModelPD7:GetValue("PD7_APROVA"))
						Aadd(aError, STR0018 + AllTrim(oModelPD7:GetValue("PD7_NOME")) + STR0019) //"PD7_APROVA-Para altera��o da confirma��o da aloca��o do Aluno ["###"] � necess�rio aprova��o. Procure o respons�vel !"
					Else
						Aadd(aMail, { oModelPD7:GetValue("PD7_NOME"), oModelPD7:GetValue("PD7_NOMEC"), oModelPD7:GetValue("PD7_CONFIR"), PD7->PD7_CONFIR })

						If ! Empty(cMsg)
							cMsg += Chr(13) + Chr(10)
						EndIf
						cMsg += "Aluno [" + AllTrim(oModelPD7:GetValue("PD7_NOME")) + STR0020 +; //"]-Altera��o da confirma��o de ["
						Alltrim(aPD7_CONF[Ascan(aPD7_CONF,{ |x| x[2] = PD7->PD7_CONFIR })][3]) + "] para [" +;
							Alltrim(aPD7_CONF[Ascan(aPD7_CONF,{ |x| x[2] = oModelPD7:GetValue("PD7_CONFIR") })][3] + "]")
					EndIf
				EndIf
			EndIf
		Next

		If Len(aError) == 0 .And. ! Empty(cMsg)
			If MsgYesNo(STR0021 + Chr(13) + Chr(10) + cMsg + Chr(13) + Chr(10) +; //"Confirma as altera��es abaixo ?"
				STR0022) //"Ser� enviado e-mail informando os respons�veis."
				For nPos := 1 To Len(aMail)
					SendMail(aMail[nPos][1] /* cPD7_NOME */, aMail[nPos][2] /* cA1_NOME */,;
						aMail[nPos][3] /* cPD7_CONFIR */, aMail[nPos][4] /* cPD7_CONF_O */)
				Next
			Else
				lError := .T.
			EndIf
		EndIf
	EndIf

	If Len(aError) > 0
		For nError := 1 To Len(aError)
			If ! Empty(cError)
				cError += Chr(13) + Chr(10)
			EndIf
			cError += aError[nError]
		Next
		Help(,, FunName() + ": PosValid",, cError, Len(aError), 0)
	EndIf

Return Len(aError) == 0 .And. ! lError

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Grava��o do modelo da aloca��o das turmas

@author Wagner Mobile Costa
@version P12
@since 08/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function Commit(oModel)

	Local nOperation  := 0
	Local nLine 	  := 0
	Local nPos 		  := 0
	Local cPD6_PROPOS := cPD7_ITEM := ""
	Local oStruct, aFields
	Local nPd7bkpLin	:= 1
	Local cRetVLab	:= ""
	Local lRet			:= .T.
	Local aAreaSA1	:= {}
	Local aAreaSUS	:= {}
	Local aAreaPDL	:= {}


	If oModel == Nil	//-- I realizada chamada com modelo nulo para verificar se a fungco existe
		Return .T.
	EndIf																							
	If oModel <> Nil	//-- � realizada chamada com modelo nulo para verificar se a fun��o existe
		nOperation := oModel:GetOperation()

		oModelPD7  := oModel:GetModel( 'PD7' )	//-- Aloca��o dos Alunos
		oStruct    := oModelPD7:GetStruct()
		aFields	   := oStruct:GetFields()

		For nLine := 1 To oModelPD7:Length()
			oModelPD7:GoLine( nLine )
			M->PD6_PROPOS := "(PD6_FILIAL = '" + oModelPD7:GetValue("PD7_FILPRO") + "' AND PD6_PROPOS = '" + oModelPD7:GetValue("PD7_PROPOS") + "')"
			If At(M->PD6_PROPOS, cPD6_PROPOS) == 0
				If ! Empty(cPD6_PROPOS)
					cPD6_PROPOS += " OR "
				EndIf
				cPD6_PROPOS += M->PD6_PROPOS
			EndIf
		Next nI

		cPD6_PROPOS := "(" + cPD6_PROPOS + ")"

		BEGIN TRANSACTION

			DbSelectArea("PD3")
			DbSetOrder(1)
			If DbSeek(xFilial("PD3")+M->PD3_TURMA)
				Reclock("PD3",.F.)
				PD3->PD3_ALOCAD := M->PD3_ALOCAD
				PD3->PD3_ALOCAN := M->PD3_ALOCAN
				MsUnlock()
			EndIf

			FwFormCommit(oModel)  // Grava o Modelo

			//-- Grava a aloca��o da turma controller
			If PD3->PD3_CONTRO = "S"
				For nLine := 1 To oModelPD7:Length()
					oModelPD7:GoLine( nLine )
					If ! oModelPD7:IsDeleted()
						PD7->(RecLock("PD7", ! (lFound := PD7->(DbSeek(xFilial() + PD3->PD3_CTRCUR + oModelPD7:GetValue("PD7_ALUNO"))))))
						For nPos := 1 To Len(aFields)
							If ! aFields[nPos][MODEL_FIELD_VIRTUAL] .And. aFields[nPos][3] <> "PD7_ITEM"
								&("PD7->" + aFields[nPos][3]) := oModelPD7:GetValue(aFields[nPos][3])
							EndIf
						Next
						PD7->PD7_FILIAL := xFilial("PD7")
						PD7->PD7_TURMA := PD3->PD3_CTRCUR
						If ! lFound	// Caso n�o encontre inclui com o pr�ximo item
							BeginSQL Alias "PD7PRX"
								SELECT MAX(PD7_ITEM) AS PD7_ITEM
								FROM %table:PD7%
								WHERE PD7_FILIAL = %Exp:xFilial("PD7")% AND PD7_TURMA = %Exp:PD3->PD3_CTRCUR%
								AND %notDel%
							EndSql
							PD7->PD7_ITEM := Soma1(PD7PRX->PD7_ITEM)
							PD7PRX->(DbCloseArea())
						EndIf
				
						PD7->(MsUnLock())
					ElseIf PD7->(DbSeek(xFilial() + PD3->PD3_CTRCUR + oModelPD7:GetValue("PD7_ALUNO")))
						PD7->(RecLock("PD7", .F.))
						PD7->(DbDelete())
						PD7->(MsUnLock())
					EndIf
				Next
			EndIf

			_oModel 	:= oModel
			_OPC		:= MODEL_OPERATION_DELETE
			_PD6_PROPOS := cPD6_PROPOS

			If ! &("StaticCall(TCTTA220, T220HrsPD6, _OPC, _PD6_PROPOS)")
				lRet := .F.
				Break
			EndIf

			_OPC := MODEL_OPERATION_INSERT
			If ! &("StaticCall(TCTTA220, T220HrsPD6, _OPC, _PD6_PROPOS)")
				lRet := .F.
				Break
			EndIf

			cPD6_PROPOS := "%" + cPD6_PROPOS + "%"

			BeginSQL Alias "PD6SLD"
				SELECT PD6_PROPOS
				FROM %table:PD6%
				WHERE %Exp:cPD6_PROPOS% AND PD6_SLDHS < 0 AND %notDel%
			EndSQL

			If ! Empty(PD6SLD->PD6_PROPOS)
				Help(,, "T220HRSPD6",, "O saldo de horas da proposta [" + PD6SLD->PD6_PROPOS + "] ficar� negativo com essa aloca��o, favor verificar !", 1, 0)
				DisarmTran()
				PD6SLD->(DbCloseArea())
				lRet := .F.
				Break
			EndIf
			PD6SLD->(DbCloseArea())

		END TRANSACTION

		If lRet
			aAreaSA1	:= SA1->(GetArea())
			aAreaSUS	:= SUS->(GetArea())
			aAreaPDL	:= PDL->(GetArea())
			
			//nPd7bkpLin := 
			If nOperation == MODEL_OPERATION_INSERT
				For nLine := 1 To oModelPD7:Length()
					oModelPD7:GoLine(nLine)
					If !oModelPD7:isDeleted()
						If PDL->(DbSeek(FwXFilial("PDL") + oModelPD7:GetValue('PD7_ALUNO',nLine )))
							If SA1->(DbSeek(fwXFilial("SA1") + oModelPD7:GetValue('PD7_CLIENT', nLine )+oModelPD7:GetValue('PD7_LOJA',nLine)))
								If !oModelPD7:isDeleted()
									cRetVLab := u_WsAloca(nOperation,oModelPD7 ,nLine )
								EndIf
							EndIf
						EndIf		
					EndIf
				Next	
			Else
				For nLine:=1 to Len(oModelPD7:aLinesChanged)
					oModelPD7:GoLine( oModelPD7:aLinesChanged[nLine] )	
					
					If PDL->(DbSeek(FwXFilial("PDL") + oModelPD7:GetValue('PD7_ALUNO', oModelPD7:aLinesChanged[nLine] )))
						If Empty(oModelPD7:GetValue('PD7_CLIENT', oModelPD7:aLinesChanged[nLine] ))
							If SUS->(DbSeek(fwXFilial("SUS") + oModelPD7:GetValue('PD7_PROSPE', oModelPD7:aLinesChanged[nLine] )+oModelPD7:GetValue('PD7_LOJPRO', oModelPD7:aLinesChanged[nLine] )))
								
							EndIf
						Else
							If SA1->(DbSeek(fwXFilial("SA1") + oModelPD7:GetValue('PD7_CLIENT', oModelPD7:aLinesChanged[nLine] )+oModelPD7:GetValue('PD7_LOJA', oModelPD7:aLinesChanged[nLine] )))
								
							EndIf
						EndIf
						If nOperation == MODEL_OPERATION_UPDATE
							If oModelPD7:isDeleted()
								cRetVLab := u_WsAloca(MODEL_OPERATION_DELETE,oModelPD7 , oModelPD7:aLinesChanged[nLine])
							Else
								cRetVLab := u_WsAloca(nOperation,oModelPD7 , oModelPD7:aLinesChanged[nLine] )
							EndIf
						Else
							cRetVLab := u_WsAloca(nOperation, oModelPD7 , oModelPD7:aLinesChanged[nLine])
						EndIf
					EndIf
				Next
			EndIf
			SA1->(RestArea(aAreaSA1))
			SUS->(RestArea(aAreaSUS))
			PDL->(RestArea(aAreaPDL))

			lRet := Empty(cRetVLab)
		EndIf
	EndIf

	
Return lRet

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Envio de EMail de altera��o da aloca��o

@author Wagner Mobile Costa
@version P12
@since 08/04/2015
@param cPD7_NOME - Nome do Aluno, cA1_NOME - Nome do Cliente, 
       cPD7_CONFIR = Nova Situa��o e cPD7_CONF_O - Situa��o Anterior
/*/
//-----------------------------------------------------------------------------
Static Function SendMail(cPD7_NOME, cA1_NOME, cPD7_CONFIR, cPD7_CONF_O)

	Local cEMail 	:= AllTrim(SuperGetMV("TI_CT130P",,""))
	Local cAssunto	:= STR0023 + ALLTRIM(SM0->M0_FILIAL) //"Confirma��o de Altera��o de Aloca��o da Agenda da Filial - "
	Local cEOL 		:= CHR(10)+CHR(13)
	Local aPD7_CONF  := RetSx3Box(POSICIONE("SX3", 2, "PD7_CONFIR", "X3CBOX()"),,, 1)

	If Empty(cEMail)
		Return .F.
	EndIf

	If Empty(cPD7_CONFIR)
		cAssunto := STR0024 + ALLTRIM(SM0->M0_FILIAL) //"Confirma��o de exclus�o de Aloca��o da Agenda da Filial - "
	Endif

	cMSG := 'Segue os dados da altera��o para conhecimento: '+cEOL+cEOL
	cMSG += 'Turma:       '     + PD3->PD3_TURMA + cEOL+cEOL
	cMSG += 'Curso:       '     + ALLTRIM(POSICIONE("PDM",1,xFilial("PDM") + PD3->PD3_CURSO,"PDM_NOME")) +cEOL+cEOL
	cMSG += 'Aluno:       '     + cPD7_NOME + cEOL+cEOL
	cMSG += 'Empresa:     '     + cA1_NOME + cEOL+cEOL
	cMSG += 'Data Inicio: '     + DTOC(M->PD3_DTINI)  + cEOL+cEOL
	cMSG += 'Data Fim:    '     + DTOC(M->PD3_DTFIM)  + cEOL+cEOL
	cMSG += '' + cEOL+cEOL
	If ! Empty(CPD7_CONFIR)
		cMSG += 'Confirma��o de: '  + Alltrim(aPD7_CONF[Ascan(aPD7_CONF,{ |x| x[2] = cPD7_CONF_O })][3])  + cEOL+cEOL
		cMSG += 'Confirma��o para: '+ Alltrim(aPD7_CONF[Ascan(aPD7_CONF,{ |x| x[2] = cPD7_CONFIR })][3])  + cEOL+cEOL
	EndIf
	cMSG += '' + cEOL
	cMSG += 'Usu�rio Manuten��o: '  + USRRETNAME(RetCodUsr()) + cEOL

	cMensagem := "<html><head><title>"+cAssunto+"</title></head><body><table><tr bgcolor='##FFCC00'><td align='center'><Font face='Trebuchet ms'>"+cAssunto+"</font></td></tr><tr><td><Font face='Trebuchet ms'>"+cEOL+cEOL+' '+cEOL+cEOL+ cMSG

	U_xSendMail(cEMail,cAssunto,cMensagem,, IsBlind(),,,.T.)

Return

/*/{Protheus.doc} WsAloca
Fun��o para consumir Ws Vlabs
@type function
@author queizy.nascimento
@since 21/03/2017
@version 1.0
@param nOperation, num�rico, (Descri��o do par�metro)
@return ${return}, ${return_description}
/*/
User Function WsAloca(nOperation, oModelPD7, nPD7)

	Local lOk, cResp, aElem, nPos, aInput := {}, aSimple := {}, nA, nPos, cMsg,xRet
	Local cRet			:= ''
	Local xRet			:= .T.
	Local cURL			:= getMv('TI_URLVLAB',,'https://apis_dev.totvstreinamentos.com/webservices/CTTWService.asmx?WSDL')
	Local cMetodo		:= ''
	Local cResult		:= ''
	Local oWsdl 		:= tWSDLManager():New()
	Local cConst := "AddRegistration#1.Registration#1"
	Local cCustomer:="AddRegistration#1.Registration#1.Student#1.Customer#1"
	Local cStudent:= "AddRegistration#1.Registration#1.Student#1"
	Local cRemove :="RemoveRegistration#1.RegistrationInfo#1"
	Local cFilPD7		:= fWXfILIAL("PD7")
	Local cTurPD7		:= PD3->PD3_TURMA
	Local cAluPd7		:= oModelPD7:GetValue('PD7_ALUNO',nPD7)
	Local cConPd7		:= oModelPD7:GetValue('PD7_CONFIR',nPD7)
	Local cCodCli		:= oModelPD7:GetValue('PD7_CLIENT', nPD7)
	
	// 3=INCLUSAO;4=ALTERACAO;5=EXCLUCAO;

	// Caso parametro esteja em branco n�o tenta integrar
	If Empty(cURL)
		Return ""
	EndIf

	oWsdl:lSSLInsecure 	:= .T.	// Define se far� a conex�o SSL com o servidor de forma an�nima, ou seja, sem verIfica��o de certIficados ou chaves.
	
	If nOperation == MODEL_OPERATION_DELETE
		cMetodo := 'DeleteCTTRegistration'
		cResult := 'RemoveRegistration'
		
	ElseIf nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE
	
		cMetodo := 'CreateCTTRegistration'
		cResult := 'AddRegistration'

	EndIf

/// Primeiro faz o parser do WSDL a partir da URL
	lOk := oWsdl:ParseURL( cURL )
	If !lOk
		cRet := oWsdl:cError
		//Return cRet
	EndIf
	
	If lOk
		// Seta a opera��o a ser utilizada
		lOk := oWsdl:SetOperation( cMetodo )
		If !lOk
			cRet := oWsdl:cError
			//Return cRet
		EndIf
		
		
		If lOk
			aComplex := oWsdl:NextComplex()
			while ValType( aComplex ) == "A"
				xRet := oWsdl:SetComplexOccurs( aComplex[1], 1 )
				if xRet == .F.
					// conout( "Erro ao definir elemento " + aComplex[2] + ", ID " + cValToChar( aComplex[1] ) + ", com 1 ocorr�ncia" )
			      	lok := .F.
			      	//return
					
				endif
				aComplex := oWsdl:NextComplex()
			End
		
			aSimple := oWsdl:SimpleInput()//
			//aSimple := oWsdl:ComplexInput()
	
		EndIf
	EndIf
	If lok
		If	nOperation == 5
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cRemove } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cFilPD7+cTurPD7+cAluPd7)
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DELETEDON" .AND. aVet[5] == cRemove } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], FWTimeStamp(3,date())  )
		
	
		
	
		ElseIf nOperation == 4
		
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken())
			
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],  cFilPD7+cTurPD7+cAluPd7)
			
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "CLASSID" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cFilPD7 + cTurPD7 )
			
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DATEENROLL" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],FWTimeStamp(3,date()) )
			
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "STATUS" .AND. aVet[5] == cConst } )
				
			
			If cConPd7 == '2'
				xRet := oWsdl:SetValue( aSimple[nPos][1],'CanceladoNoPrazo' )
			ElseIf cConPd7 == '3'
				xRet := oWsdl:SetValue( aSimple[nPos][1],'CanceladoForaPrazoPerdeuCredito' )
				
			ElseIf cConPd7 == '4'
				xRet := oWsdl:SetValue( aSimple[nPos][1],'CanceCanceladoForaPrazoRealocar' )
			
			ElseIf cConPd7 == '5'
				xRet := oWsdl:SetValue( aSimple[nPos][1],'Cortesia' )
			
			ElseIf cConPd7 == '6'
				xRet := oWsdl:SetValue( aSimple[nPos][1],'Realocado' )
			Else
				xRet := oWsdl:SetValue( aSimple[nPos][1],LTRIM('Confirmado' ))
			EndIf
	
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "STUDENTID" .AND. aVet[5] == cStudent } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],PDL->PDL_ALUNO )
	
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "EMAIL" .AND. aVet[5] == cStudent } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],PDL->PDL_EMAIL )
		
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "FIRSTNAME" .AND. aVet[5] == cStudent } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(PDL->PDL_NOME, 1,AT(' ',PDL->PDL_NOME )) )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "LASTNAME" .AND. aVet[5] == cStudent } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(PDL->PDL_NOME,AT(' ',PDL->PDL_NOME )) )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTNUMBER" .AND. aVet[5] == cStudent } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], PDL->PDL_CPF )
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PHONENUMBER" .AND. aVet[5] == cStudent } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], PDL->PDL_TEL )
	  
			
			//CUSTOMER
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOTVSID" .AND. aVet[5] == cCustomer } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],Iif(Empty(cCodCli), SUS->US_COD,SA1->A1_COD))
					                                 
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTID" .AND. aVet[5] == cCustomer } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],Iif(Empty(cCodCli),SUS->US_CGC,SA1->A1_CGC))
	
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cCustomer } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],Iif(Empty(cCodCli),SUS->US_NOME,SA1->A1_NOME))
			
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "COUNTRYID" .AND. aVet[5] == cCustomer } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], Iif(Empty(cCodCli),SUS->US_PAIS,SA1->A1_PAIS))
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TYPE" .AND. aVet[5] == cCustomer } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], Iif(Empty(cCodCli),SUS->US_TIPO,SA1->A1_PESSOA))
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ENTITY" .AND. aVet[5] == cCustomer } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], Iif(Empty(cCodCli),'SUS','SA1') )
		
		EndIf
		
	//Pega a mensagem que sera enviada para Web Service
		cMsg := oWsdl:GetSoapMsg()
	
	// Faz a requisi��o ao WebService 
		lOk := oWsdl:SendSoapMsg(cMsg)
		If !lOk
			cRet := oWsdl:cError
			//Return cRet
		EndIf
	EndIf

	//CRET:=oWSDL:GetSoapResponse()
	If !lOk
		MsgAlert(CRET)
	EndIf
Return cRet

/*/{Protheus.doc} TCTT130
Fun��o para validar turma realocada
@type function
@author fabio veiga oliva
@since 13/12/2019
@version 1.0
@param nOperation, num�rico, (Descri��o do par�metro)
@return ${return}, ${return_description}
/*/
User Function TCTT130()
Local lRet     := .T.
Local aArea    := GetArea()
Local aAreaPD3 := {}
Local nRegpD3  := 0
dbSelectArea("PD3")
nRegSD3 := Recno()
dbSetOrder(1)
If !Empty(M->PD7_TURMAR) .And. !dbSeek(xFilial("SD3")+M->PD7_TURMAR)
   MsgStop("Turma n�o encontrada!")
   lRet := .F.
EndIf   
RestArea(aAreaPD3)
RestArea(aArea)
Return(lRet)

