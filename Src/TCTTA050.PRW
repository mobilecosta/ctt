#INCLUDE "TCTTA050.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { { 	'PD3'/* Tabela */, STR0002 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */, { } /* Relation */,; //"Turmas"
"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 50 /* Area do Componente */, {} /* Unique Line */ },;
{ 	"PDI", STR0042,  .F., .F., { { "PDI_FILIAL", "xFilial('PDI')" }, { "PDI_TURMA", "PD3_TURMA" } }, "", "PDI_ITEM", 50, {} },; //"Datas"
{ 	"PDF", STR0003,  .T., .F., { { "PDF_FILIAL", "xFilial('PDF')" }, { "PDF_TURMA", "PD3_TURMA" } }, "", "PDF_PERIO", 50, {} } } //"Periodos"
STATIC cFunName	:= "TCTTA050"
STATIC aLegend  := { { 	"PD3_STATUS=='N'","BR_PRETO", STR0041 },; //"Turma em criação"
{ 	"PD3_STATUS=='S' .And. PD3_ALOCAD > 0","BR_AZUL", STR0007 },; //"Turma com alocação"
{ 	"PD3_STATUS=='S'","BR_VERDE", STR0010 },; //Turma Confirmada"
{ 	"PD3_STATUS=='C'","BR_VERMELHO", STR0013 } } //Turma Cancelada"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do cadastro de Turmas

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA050

	Local cFilter := If(FunName() = "TCTTA030", "PD3_PROF = '" + PD2->PD2_PROF + "'", "")

	Private aRotina := &("StaticCall(" + cFunName + ", MENUDEF)")

	U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo do cadastro de Turmas

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
@Return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE STR0036 ACTION 'PesqBrw'          	OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE STR0037 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0038 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE STR0039 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE STR0040 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "EMail Confirmação/Cancelamento"       ACTION 'U_TCTA50CF()' 	        OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Conhecimento" ACTION 'MsDocument' OPERATION 3 ACCESS 0

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
@Return oModel
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
@Return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ViewDef()

Return &("StaticCall(TCTTXMVC,VIEWDEF)")

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Ativação do modelo do cadastro de turmas

@author Wagner Mobile Costa
@version P12
@since 07/04/2015
@Return oModel
/*/
//-----------------------------------------------------------------------------
Static Function Activate(oModel)

	Local nOperation := 0
	Local aError	 := {}, cError := "", nError := 0, cRetVLab := ''
	Local aArea		 := GetArea()

	If oModel == Nil	//-- É realizada chamada com modelo nulo para verIficar se a função existe
		Return .F.
	EndIf

	nOperation := oModel:GetOperation()

	If nOperation == MODEL_OPERATION_DELETE
		//-- 1. Uso em Alocações
		BeginSQL Alias "PD7QRY"
			SELECT MIN(PD7_ALUNO) AS PD7_ALUNO, MIN(PDL.PDL_NOME) AS PDL_NOME
			FROM %table:PD7% PD7
			LEFT JOIN %table:PDL% PDL ON PDL.%notDel% AND PDL.PDL_FILIAL = %Exp:Repl(" ", Len(xFilial("PDL")))% AND PDL.PDL_ALUNO = PD7.PD7_ALUNO
			WHERE PD7.%notDel% AND PD7.PD7_FILIAL = %Exp:PD3->PD3_FILIAL% AND PD7.PD7_TURMA = %Exp:PD3->PD3_TURMA%
		EndSql

		If ! Empty(PD7QRY->PD7_ALUNO)
			AAdd(aError, STR0014 + PD7QRY->PD7_ALUNO + STR0015 + PD7QRY->PDL_NOME + STR0016) //"PD7-Turma em uso na alocação do aluno ["###"/"###"]"
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
		Else

		EndIf
	EndIf

Return Len(aError) == 0

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Pós Validação (TudoOk) do modelo do cadastro de turmas

@author Wagner Mobile Costa
@version P12
@since 07/04/2015
@Return oModel
/*/
//-----------------------------------------------------------------------------
Static Function PosValid(oModel)

	Local oModelPDI, oModelPDF
	Local nLine 	  := 0
	Local nPos 		  := 0
	Local nPosPDI 	  := 0
	Local nError 	  := 0
	Local nOperation  :=  0
	Local aError	  := {}
	Local dData 	  := Ctod("")
	Local cError  	  := ""
	Local aPeriodos   := {}
	Local aPD2_PROF	  := {}
	Local cPD2_PROF   := cHRINI := cHRFIM := cInter := ""
	Local nPDI_QTDHOR := 0
	Local nPDF_QTDHOR := 0
	Local nRegPDF 	  := 0
	Local nRegPDI     := 0
	Local nHora 	  := 0
	Local nHorInt 	  := 0
	Local oView    	  := FWViewActive()
	Local aSaveLines  := FWSaveRows(), lHorasP := .F.
	Local cRetVLab	  := ''
	Local aArea       := {}
	Local _nDtFim     := SuperGetMV("TI_CT050P",.F.,30)

	If oModel == Nil //-- É realizada chamada com modelo nulo para verIficar se a função existe
		Return .T.
	EndIf

	oModelPDI := oModel:GetModel( 'PDI' )	//-- Datas da Turma
	oModelPDF := oModel:GetModel( 'PDF' )	//-- Periodos da Turmas

	If M->PD3_DTFIM < M->PD3_DTINI
		AAdd(aError, STR0017) //"PD3_DTFIM-A data final do curso deve ser superior a data inicial."
		lRet := .F.
	EndIf

	If M->PD3_CONTRO = "S" .AND. Empty(M->PD3_CTRCUR)
		AAdd(aError, STR0018) //"PD3_CTRCUR-O campo 'Ctrl Curso' não foi preenchido. Favor escolher o curso 'Controller'."
		lRet := .F.
	EndIf

	//-- Datas do Curso
	nRegPDI := oModelPDI:Length()
	For nLine := 1 To nRegPDI
		oModelPDI:GoLine( nLine )

		If ! oModelPDI:IsDeleted()
			cPD2_PROF := oModelPDI:GetValue("PDI_PROF")
			dData 	  := oModelPDI:GetValue("PDI_DATA")
			cHrIni 	  := oModelPDI:GetValue("PDI_HRINI")
			cHrFim 	  := oModelPDI:GetValue("PDI_HRFIM")
			cInter 	  := oModelPDI:GetValue("PDI_INTER")
			nPos 	  := Ascan(aPD2_PROF, { |x| x[1] == cPD2_PROF })
			If nPos == 0
				AAdd(aPD2_PROF, { cPD2_PROF, 0, 0, Ctod(""), Ctod("") })
				nPos := Len(aPD2_PROF)
			EndIf
			//-- Existe carga horária para o professor principal do curso
			If M->PD3_PROF == cPD2_PROF
				lHorasP := .T.
			EndIf

			If dData < aPD2_PROF[nPos][4] .Or. Empty(aPD2_PROF[nPos][4])
				aPD2_PROF[nPos][4] := dData
			EndIf
			If aPD2_PROF[nPos][5] < dData .Or. Empty(aPD2_PROF[nPos][5])
				aPD2_PROF[nPos][5] := dData
			EndIf

			nHora := Val(Left(cHrFIM, 2)) - Val(Left(cHrINI, 2))
			nHora += ((Val(Right(cHrFIM, 2)) - Val(Right(cHrINI, 2))) / 60)
			aPD2_PROF[nPos][2] += nHora

			nHorInt := Val(Left(cInter, 2))
			nHorInt += ((Val(Right(cInter, 2))) / 60)
			aPD2_PROF[nPos][2] -= nHorInt

			AAdd(aPeriodos, { dData, cHRINI, cHRFIM, cInter })
			If dData < M->PD3_DTINI .OR. dData > M->PD3_DTFIM
				AAdd(aError, STR0019) //"PDI_DATA-Data da alocação esta maior ou menor que data inicial ou data final do curso !"
				lRet := .F.
			EndIf
			If (Dow(dData) = 7 .OR. Dow(dData) = 1) .AND. oModelPDI:GetValue("PDI_PERIOD") = "N"
				AAdd(aError, STR0020 + FG_CDOW(dData) + STR0021, 1, 0) //"PDI_PERIODO-Agenda para "###" Não poderá ser no Periodo Noturno."
				lRet	:= .F.
			EndIf

			// Validação da alocação do professor no mesmo dia e horarios em turmas dIferentes
			If M->PD3_STATUS <> "C"
				BeginSQL Alias "PDIQRY"
					SELECT PDI_TURMA, PDI_FILIAL
					FROM %table:PDI% PDI
					JOIN %table:PD3% PD3 ON PD3.PD3_FILIAL = PDI.PDI_FILIAL
					AND PD3.PD3_TURMA = PDI.PDI_TURMA AND PD3.%notDel%
					AND PD3.PD3_STATUS <> %Exp:'C'%
					JOIN %table:PD2% PD2 ON PD2.PD2_FILIAL = %Exp:xFilial("PD2")% AND PD2.PD2_PROF = %Exp:cPD2_PROF%
					AND PD2.PD2_PLAN <> %Exp:'1'% AND PD2.%notDel%
					WHERE PDI_FILIAL BETWEEN %Exp:Repl(' ', Len(PDI->PDI_FILIAL))% AND %Exp:Repl('Z', Len(PDI->PDI_FILIAL))%
					AND PDI_TURMA <> %Exp:M->PD3_TURMA% AND PDI_DATA = %Exp:DTOS(dData)%
					AND PDI_PROF = %Exp:cPD2_PROF%
					AND ((PDI_HRINI >= %Exp:cHRINI% AND PDI_HRINI <= %Exp:cHRFIM%) OR
					(PDI_HRFIM >= %Exp:cHRFIM% AND PDI_HRINI < %Exp:cHRFIM%) OR
					(PDI_HRFIM >= %Exp:cHRINI% AND PDI_HRINI <= %Exp:cHRFIM%))
					AND PDI.%notDel%
				EndSql

				If ! EMPTY(PDIQRY->PDI_TURMA)
					AAdd(aError, STR0022 + Dtoc(dData) + STR0023 + STR0024 + TRANS(cHrIni, '@R 99:99') +; //"Atenção este professor já está alocado nesta data ["###" ]"###" e hora [ "###"@R 99:99"
					STR0026 + PDIQRY->PDI_FILIAL + STR0027 + PDIQRY->PDI_TURMA + STR0023) //" ] na Filial / Turma [ "###" / "###" ]"
					lRet = .F.
				EndIf
				PDIQRY->(DbCloseArea())
			EndIf
		EndIf

	Next nI

	If ! lHorasP
		AAdd(aError, STR0028) //"PDI_PROF-É obrigatória a existencia de datas para o professor principal do curso !"
	EndIf

	//-- Periodos do Curso
	nRegPDF := oModelPDF:Length()
	For nLine := 1 To nRegPDF
		oModelPDF:GoLine( nLine )

		cPD2_PROF := oModelPDF:GetValue("PDF_PROF")
		If nRegPDF == 1 .And. Len(aPD2_PROF) > 0
			oModelPDF:SetValue("PDF_DTINI", aPD2_PROF[1][4])
			oModelPDF:SetValue("PDF_DTFIM", aPD2_PROF[1][5])

			cPD2_PROF := M->PD3_PROF
			oModelPDF:SetValue("PDF_PROF", cPD2_PROF)

			U_TCTTV006()

			If oView <> Nil
				oView:Refresh()
			EndIf
		EndIf

		If ! oModelPDF:IsDeleted() .And. ! Empty(oModelPDF:GetValue("PDF_DTINI"))
			nPos := Ascan(aPD2_PROF, { |x| x[1] == cPD2_PROF })
			If nPos == 0
				AAdd(aPD2_PROF, { cPD2_PROF, 0, 0 })
				nPos := Len(aPD2_PROF)
			EndIf

			If oModelPDF:GetValue("PDF_DTINI") < M->PD3_DTINI
				AAdd(aError, STR0029) //"PDF_DTINI-Data inicial da aba periodos é inferior a data inicial do curso !"
				lRet := .F.
			EndIf

			If oModelPDF:GetValue("PDF_DTFIM") > M->PD3_DTFIM
				AAdd(aError, STR0030) //"PDF_DTFIM-Data final da aba periodos é superior a data final do curso !"
				lRet := .F.
			EndIf

			aPD2_PROF[nPos][3] += oModelPDF:GetValue("PDF_QTDHOR")
		EndIf
	Next nI

	For nPos := 1 To Len(aPD2_PROF)
		nPDI_QTDHOR += aPD2_PROF[nPos][2]
		nPDF_QTDHOR += aPD2_PROF[nPos][3]
	Next

	If M->PD3_QTDHOR <> nPDI_QTDHOR
		AAdd(aError, STR0031 + AllTrim(Str(nPDI_QTDHOR)) + STR0032) //"PDI_QTDHOR-A soma de horas da aba [Datas] é de ["###"], dIferente da carga horária do curso !"
	EndIf

	If M->PD3_QTDHOR <> nPDF_QTDHOR
		AAdd(aError, STR0033 + AllTrim(Str(nPDF_QTDHOR)) + STR0032) //"PDF_QTDHOR-O número de horas da aba [Periodos] é de ["###"], dIferente da carga horária do curso !"
	EndIf

	If Len(aError) > 0
		For nError := 1 To Len(aError)
			If ! Empty(cError)
				cError += Chr(13) + Chr(10)
			EndIf
			cError += aError[nError]
		Next
		Help(,, FunName() + ": PosValid",, cError, Len(aError), 0)
	Else

	EndIf

	If Len(aError) == 0
		// Integração COM VLabs
		If oModel:GetOperation() == MODEL_OPERATION_DELETE
			cRetVLab := u_WsTurma(MODEL_OPERATION_DELETE,oModel)
			if valtype(cRetVLab) == 'C'
				if !( alltrim(upper(cRetVLab)) == 'OK' )
					AADD(aError,cRetVLab)
					msgAlert(cRetVLab)
				endif
			endif
			Return .T.
		EndIf

		If  oModel:GetOperation() == MODEL_OPERATION_INSERT
			cRetVLab := u_WsTurma(MODEL_OPERATION_INSERT,oModel)
			if valtype(cRetVLab) == 'C'
				if !( alltrim(upper(cRetVLab)) == 'OK' )
					AADD(aError,cRetVLab)
					msgAlert(cRetVLab)
				endif
			endif
		ElseIf oModel:GetOperation() == MODEL_OPERATION_UPDATE
			cRetVLab := u_WsTurma(MODEL_OPERATION_UPDATE,oModel)
			if valtype(cRetVLab) == 'C'
				if !( alltrim(upper(cRetVLab)) == 'OK' )
					AADD(aError,cRetVLab)
					msgAlert(cRetVLab)
				endif
			endif
		EndIf
	EndIf        
	
	//Cancela a alocação dos alunos quando a turma for cancelada PD3_STATUS = 'C'
	If M->PD3_STATUS = 'C'
	   aArea := GetArea()
	   dbSelectArea('PD7')
	   dbSetOrder(1)
	   If dbSeek(xFilial("PD7")+M->PD3_TURMA)
	      While !Eof() .And. PD7->PD7_FILIAL+PD7->PD7_TURMA == xFilial('PD3')+M->PD3_TURMA

		         RecLock("PD7",.F.)
			         PD7->PD7_CONFIR := '2'
			         //PD7->PD7_HORAS  := 0
		         MsUnlock()

	         dbSkip()
	      EndDo
	   EndIf
	   RestArea(aArea)
	EndIf         
                     
    //se já passou o prazo de alocacao da turma = PD3_DTFIM + PARAMETRO DE DIAS TI_CT050P não permite a alocação
//    If oModel:GetOperation() = MODEL_OPERATION_UPDATE .And. !Empty(M->PD3_DTFIM)
    If !Empty(M->PD3_DTFIM)
      If dDatabase > M->PD3_DTFIM+_nDtFim
	     Help(,, FunName() + ": PreValid",, "ATENÇÃO !!. A Turma finalizou em:"+Dtoc(PD3_DTFIM)+" e só poderia ter alterações até dia:"+Dtoc(M->PD3_DTFIM+_nDtFim), 1, 0)
	     Return .F.
      Endif
    EndIf

	FWRestRows( aSaveLines )

Return Len(aError) == 0

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Envio de EMail de confirmação/cancelamento do curso para o Instrutor

@author Wagner Mobile Costa
@version P12
@since 08/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTA50CF()

	Local aDesCateg := RetSx3Box(POSICIONE("SX3", 2, "PD3_CATEG", "X3CBOX()"),,, 1)
	Local cAssunto  := ""
	Local cMsgMail	:= ""
	Local cMSG      := ""
	Local aArea     := GetArea(), aAreaPD2 := PD2->(GetArea())
	Local cEMail    := ""
	Local cEOL 	:= "</br>"
	Local cUsrMail  := AllTrim(UsrRetMail(__cUserId))
	Local nPeriodo  := 0
	Local lCanc     := PD3->PD3_STATUS == "C"

	Private cMensagem

	If ! Empty(cUsrMail)
		cEMail += cUsrMail
	EndIf

	If lCanc
		cAssunto := STR0034 + ALLTRIM(SM0->M0_FILIAL) //"Confirmação de Cancelamento de curso Filial - "
		cMSG := STR0043+cEOL+cEOL //"Segue a confirmação de cancelamento de treinamento:"
	Else
		cAssunto := STR0035 + ALLTRIM(SM0->M0_FILIAL) //"Confirmação de Curso Filial - "
		cMSG := STR0044+cEOL+cEOL //"Segue a confirmação para o treinamento:"
	EndIf
	cMSG += 'Curso: '+AllTrim(PD3->PD3_NOME)+cEOL
	cMSG += ''+cEOL

	PDI->(DbSetOrder(2)) // PDI_FILIAL+PDI_TURMA+PDI_PROF+DTOS(PDI_DATA)+PDI_HRINI
	PDI->(DbSeek(xFilial() + PD3->PD3_TURMA))

	M->PDI_PROF := ""

	While PDI->PDI_TURMA == PD3->PD3_TURMA .And. ! PDI->(Eof())
		If PDI->PDI_PROF <> M->PDI_PROF
			PD2->(DbSeek(xFilial("PD2") + PDI->PDI_PROF))

			If ! Empty(PD2->PD2_EMAIL)
				If ! Empty(cEMail)
					cEMail += ";"
				EndIf
				cEMail += AllTrim(PD2->PD2_EMAIL)
			EndIf

			cMSG += STR0049+ AllTrim(PD2->PD2_NOME) +cEOL //"Instrutor (a):  "
			M->PDI_PROF := PDI->PDI_PROF
		EndIf

		cMSG += STR0045 + DTOC(PDI->PDI_DATA) + ' (' + FG_CDOW(PDI->PDI_DATA) + ')' + ; //"Datas: "
		STR0046 + TRANSFORM(PDI->PDI_HRINI,"@R 99:99") +; //" - Início: "
		STR0047+ TRANSFORM(PDI->PDI_HRFIM,"@R 99:99")+'h'  //"h - Fim: "
		If ! Empty(PDI->PDI_INTER)
			cMSG += STR0048+ TRANSFORM(PDI->PDI_INTER,"@R 99:99")+'h' //" Intervalo: "
		EndIf

		cMSG += cEOL
		PDI->(DbSkip())
	EndDo

	PDI->(DbSetOrder(1)) // PDI_FILIAL+PDI_TURMA+PDI_ITEM

	cMSG += cEOL+cEOL
	cMSG += STR0050 + Alltrim(aDesCateg[Ascan(aDesCateg,{ |x| x[2] = PD3->PD3_CATEG  })][3]) + ' '+cEOL //"Local/Tipo Curso: "
	cMSG += cEOL+cEOL

	cMSG+="</font><br><br><center><img src='http://www.totvs.com/image/company_logo?img_id=10209&t=1368996682280'></img></center><br><br></td></tr><tr bgcolor='#6CA6CD'><td align='center'><Font face='Trebuchet ms'>CTT - Centro de Treinamento TOTVS - " + SM0->M0_FILIAL + "</font></td></tr></table></body></html>"

	If lCanc
		cMsgMail := "<html><head><title>"+cAssunto+"</title></head><body><table><tr bgcolor='#FF0000'><td align='center'><Font face='Trebuchet ms'>"+cAssunto+"</font></td></tr><tr><td><Font face='Trebuchet ms'>"+cEOL+cEOL+'Olá '+ALLTRIM(PD2->PD2_NOME)+', '+cEOL+cEOL+cMsg
	Else
		cMsgMail := "<html><head><title>"+cAssunto+"</title></head><body><table><tr bgcolor='#6CA6CD'><td align='center'><Font face='Trebuchet ms'>"+cAssunto+"</font></td></tr><tr><td><Font face='Trebuchet ms'>"+cEOL+cEOL+'Olá '+ALLTRIM(PD2->PD2_NOME)+', '+cEOL+cEOL+cMsg
	EndIf

	U_TCTXLOGM(	"PD3", PD3->PD3_TURMA, cAssunto, cEMail, cMsgMail,;
	"\temp\ctt050_cf_" + DTOS(Date())+"_"+StrTran(TIME(), ":", "") + ".htm",;
	U_xSendMail(cEMail,cAssunto,cMsgMail,, IsBlind(),,,.T.))

	//Quando for cancelado Turma será enviado e-mail
	If lCanc
		BeginSQL Alias "PDLQRY"
			SELECT PDL.PDL_EMAIL, PDL.PDL_NOME
			FROM %table:PD7% PD7
			JOIN %table:PDL% PDL ON PDL.PDL_FILIAL = %Exp:xFilial("PDL")%
			AND PD7.PD7_ALUNO = PDL.PDL_ALUNO AND PD7.PD7_CONFIR IN (%Exp:'1'%,%Exp:'3'%,%Exp:'5'%,%Exp:'6'%) AND PDL.%notDel%
			WHERE PD7.PD7_FILIAL = %Exp:PD3->PD3_FILIAL% AND PD7.PD7_TURMA = %Exp:PD3->PD3_TURMA% AND PD7.%notDel%
		EndSql

		WHILE !PDLQRY->(EOF())
			cMsgMail := "<html><head><title>"+cAssunto+"</title></head><body><table><tr bgcolor='#FF0000'><td align='center'><Font face='Trebuchet ms'>"+;
			cAssunto+"</font></td></tr><tr><td><Font face='Trebuchet ms'>"+cEOL+cEOL+'Olá '+ALLTRIM(PDLQRY->PDL_NOME)+', '+cEOL+cEOL+cMsg
			U_TCTXLOGM(	"PD3", PD3->PD3_TURMA, cAssunto, cEMail, cMsgMail,;
			"\temp\ctta050_cfa_" + DTOS(Date())+"_"+StrTran(TIME(), ":", "") + ".htm",;
			U_xSendMail(PDLQRY->PDL_EMAIL,cAssunto,cMsgMail,, IsBlind(),,,.T.))
			PDLQRY->(DBSKIP())
		END
		PDLQRY->(DbCloseArea())
	EndIf

	PD2->(RestArea(aAreaPD2))
	RestArea(aArea)

Return

//--------------------------------------------------------------------------------
/*/{Protheus.doc} WsTurma
Função para consumir WsTurma
@type function
@author queizy.nascimento
@since 21/03/2017
@version 1.0
@param nOperation, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*/

User Function WsTurma(nOperation,oModel)

	Local lOk, cResp, aElem, nPos, aInput := {}, aComplex := {}, nA, nPos, cMsg,xRet
	Local cRet			:= 'OK'
	Local cURL			:= getMv('TI_URLVLAB',,'https://apis_dev.totvstreinamentos.com/webservices/CTTWService.asmx?WSDL')
	Local lLog			:= getMv('TI_LOGVLAB',,.F.)
	
	Local cMetodo		:= ''
	Local cResult		:= ''
	Local oWsdl 		:= tWSDLManager():New()
	Local cConst		:="AddClass#1.Class#1"
	Local cVal 		:= "AddClass#1.Class#1.Training#1"
	Local cProf 		:= "AddClass#1.Class#1.Instructor#1"
	Local cClass		:= "AddClass#1.Class#1.ClassDays#1.ClassDay#1"
	Local cRemove		:= "RemoveClass#1.Class#1"
	Local oMdlA050		:= FwModelActivate()
	Local oMdlPD3 		:= oModel:getModel('PD3')
	Local oMdlPDI 		:= oMdlA050:getModel('PDI')
	Local nI			:= 0
	Local aChild		:= {}
	Local aTmp			:= {}
	Local ni			:= 0
	Local nk			:= 0
	Local nj			:= 0
	Local nOccurs		:= 0
	Local xRet			:= ""

	default nOperation	:= 0	// 3=INCLUSAO;4=ALTERACAO;5=EXCLUCAO;

	oWsdl:lSSLInsecure 	:= .T.	// Define se fará a conexão SSL com o servidor de forma anônima, ou seja, sem verIficação de certIficados ou chaves.

	If nOperation == 5
		cMetodo := 'DeleteCTTClass'
		cResult := 'RemoveClass'
	ElseIf nOperation == 3 .OR. nOperation == 4
		cMetodo := 'CreateCTTClass'
		cResult := 'AddClass'
	EndIf

	// Primeiro faz o parser do WSDL a partir da URL
	lOk := oWsdl:ParseURL( cURL )
	If !lOk
		cRet := oWsdl:cError
		Return cRet
	EndIf

	// Seta a operação a ser utilizada
	lOk := oWsdl:SetOperation( cMetodo )
	If !lOk
		cRet := oWsdl:cError
		Return cRet
	EndIf

	For nI := 1 to oMdlPDI:Length()
		oMdlPDI:GoLine(nI)

		if oMdlPDI:IsDeleted()
			loop
		endif

		cHrIniX := FWTimeStamp(3,oMdlPDI:getValue('PDI_DATA'), left(oMdlPDI:getValue('PDI_HRINI'),2) + ':' + right(oMdlPDI:getValue('PDI_HRINI'),2) + ':00' )

		AADD(aTmp,{"STARTDATETIME",cHrIniX})

		cHrFimX := FWTimeStamp(3,oMdlPDI:getValue('PDI_DATA'), left(oMdlPDI:getValue('PDI_HRFIM'),2) + ':' + right(oMdlPDI:getValue('PDI_HRFIM'),2) + ':00' )

		AADD(aTmp,{"ENDDATETIME",cHrFimX})
		AADD(aChild,aTmp)
	Next ni

	aComplex := oWsdl:NextComplex()
	while ValType( aComplex ) == "A"
		If ( aComplex[2] == "ClassDay" ) .And. ( aComplex[5] == "AddClass#1.Class#1.ClassDays#1" )
			nOccurs := Len(aChild)
		Else
			nOccurs := 1
		EndIf
		xRet := oWsdl:SetComplexOccurs( aComplex[1],nOccurs)

		if xRet == .F.
			cRet := "Erro ao definir elemento " + aComplex[2] + ", ID " + cValToChar( aComplex[1] ) + ", com " + cValToChar( nOccurs ) + " ocorrencias"
			return cRet
		endif

		aComplex := oWsdl:NextComplex()
	enddo

	aSimple := oWsdl:SimpleInput()
	//aSimple := oWsdl:ComplexInput()

	If nOperation == 5

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cRemove } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PD3->PD3_FILIAL + PD3->PD3_TURMA)

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DELETEDON" .AND. aVet[5] == cRemove } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], FWTimeStamp(3,date()) )

	ElseIf nOperation == 3

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], cFilAnt + M->PD3_TURMA )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  M->PD3_NOME )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "VACANCIES" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  cValToChar (PD3->PD3_VAGAS) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "CATEGORY" .AND. aVet[5] == cConst } )
		If M->PD3_CATEG == '1'
			if M->PD3_SELO == '1'
				xRet := oWsdl:SetValue( aSimple[nPos][1],  'RegularSeloVerde' )
			else
				xRet := oWsdl:SetValue( aSimple[nPos][1],  'Regular' )
			EndIf
		ElseIf  M->PD3_CATEG == '2'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Vip' )
		ElseIf  M->PD3_CATEG == '3'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Personalizado' )
		ElseIf  M->PD3_CATEG == '4'
			if M->PD3_SELO == '1'
				xRet := oWsdl:SetValue( aSimple[nPos][1],  'InCompanySeloVerde' )
			Else
				xRet := oWsdl:SetValue( aSimple[nPos][1],  'InCompany' )
			EndIf
		ElseIf  M->PD3_CATEG == '5'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Virtual' )
		ElseIf  M->PD3_CATEG == '6'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Controller' )
		ElseIf  M->PD3_CATEG == '7'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Formacao' )
		ElseIf  M->PD3_CATEG == '8'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'InCompanySeloVerde' )
		ElseIf  M->PD3_CATEG == '9'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Adm' )
		EndIf
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "MODALITY" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  'Modalidade' )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "CREATEDON" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  FWTimeStamp(3,date()) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DATESTART" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  FWTimeStamp(3,M->PD3_DTINI) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DATEEND" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], FWTimeStamp(3,M->PD3_DTFIM) )

		//Training
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cVal } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  PDM->PDM_CURSO )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cVal } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PDM->PDM_NOME )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "COURSELOAD" .AND. aVet[5] == cVal } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], cValToChar(PDM->PDM_QTDHOR) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "MODALITY" .AND. aVet[5] == cVal } )
		IF PDM->PDM_MODAL =='E'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'Elearning')
		ElseIf PDM->PDM_MODAL =='P'
			xRet := oWsdl:SetValue( aSimple[nPos][1], 'Presencial')
		ElseIf PDM->PDM_MODAL =='C'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Controller' )
		EndIf

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PRODUCT" .AND. aVet[5] == cVal } )
		If PDM->PDM_TPOSIS =='P'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'PROTHEUS')
		ElseIf PDM->PDM_TPOSIS =='R'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'RM')
		ElseIf PDM->PDM_TPOSIS =='G'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'FLUIG')
		ElseIf PDM->PDM_TPOSIS =='D'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'DATASUL')
		ElseIf PDM->PDM_TPOSIS =='L'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'LOGIX')
		ElseIf PDM->PDM_TPOSIS =='F'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'FORMACAO')
		ElseIf PDM->PDM_TPOSIS =='E'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'EAD')
		ElseIf PDM->PDM_TPOSIS =='H'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'PCSISTEMAS')
		ElseIf PDM->PDM_TPOSIS =='I'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'VIRTUALAGE')
		EndIF

		//Instructor
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PD2->PD2_PROF )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "FIRSTNAME" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(PD2->PD2_NOME, 1,AT(' ',PD2->PD2_NOME )) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "LASTNAME" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(PD2->PD2_NOME,AT(' ',PD2->PD2_NOME )) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "EMAIL" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], (PD2->PD2_EMAIL) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PHONENUMBER" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PD2->PD2_TEL )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTNUMBER" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PD2->PD2_CPF )

        //Confirmed
  		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "CONFIRMED" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  M->PD3_STATUS )

		ni	:= 1
		nj	:= 1
		nk	:= 1
		For nk:=1 to Len(aChild)
			cComplex := "AddClass#1.Class#1.ClassDays#1.ClassDay#"+AllTrim(Str(nk))
			For nj:=4 to Len(aSimple)
				If aSimple[nj][5] == cComplex
					If ni <= Len(aChild[nk])
						nPos := aScan( aSimple, {|x| Upper(x[2]) == aChild[nk][ni][1] .AND. x[5] == cComplex } )
						If nPos > 0
							If nPos == nj
								If !Empty(aChild[nk][ni][2])
									xRet := oWsdl:SetValue( aSimple[nPos][1], aChild[nk][ni][2] )
									If xRet == .F.
										xRet := STR0029 + oWsdl:cError
										Return(xRet)
									Endif
								EndIf
								ni := ni +1
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		Next

	ElseIF nOperation == 4

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  M->PD3_FILIAL + M->PD3_TURMA )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  M->PD3_NOME )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "VACANCIES" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  cValToChar (M->PD3_VAGAS) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "CATEGORY" .AND. aVet[5] == cConst } )
		If M->PD3_CATEG == '1'
			if M->PD3_SELO == '1'
				xRet := oWsdl:SetValue( aSimple[nPos][1],  'RegularSeloVerde' )
			else
				xRet := oWsdl:SetValue( aSimple[nPos][1],  'Regular' )
			endif
		ElseIf  M->PD3_CATEG == '2'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Vip' )
		ElseIf  M->PD3_CATEG == '3'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Personalizado' )
		ElseIf  M->PD3_CATEG == '4'
			if M->PD3_SELO == '1'
				xRet := oWsdl:SetValue( aSimple[nPos][1],  'InCompanySeloVerde' )
			Else
				xRet := oWsdl:SetValue( aSimple[nPos][1],  'InCompany' )
			EndIf
		ElseIf  M->PD3_CATEG == '5'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Virtual' )
		ElseIf  M->PD3_CATEG == '6'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Controller' )
		ElseIf  M->PD3_CATEG == '7'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Formacao' )
		ElseIf  M->PD3_CATEG == '8'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'InCompanySeloVerde' )
		ElseIf  M->PD3_CATEG == '9'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Adm' )
		EndIf
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "MODALITY" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  'Modalidade' )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DATESTART" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  FWTimeStamp(3,M->PD3_DTINI) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DATEEND" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], FWTimeStamp(3,M->PD3_DTFIM) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "CREATEDON" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],   FWTimeStamp(3,date()))

		//Training
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cVal } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  PDM->PDM_CURSO )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cVal } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PDM->PDM_NOME )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "COURSELOAD" .AND. aVet[5] == cVal } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], cValToChar(PDM->PDM_QTDHOR) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "MODALITY" .AND. aVet[5] == cVal } )
		IF PDM->PDM_MODAL =='E'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'Elearning')
		ElseIf PDM->PDM_MODAL =='P'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'Presencial')
		ElseIf PDM->PDM_MODAL =='C'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'Controller' )
		EndIf

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PRODUCT" .AND. aVet[5] == cVal } )
		If PDM->PDM_TPOSIS =='P'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'PROTHEUS')
		ElseIf PDM->PDM_TPOSIS =='R'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'RM')
		ElseIf PDM->PDM_TPOSIS =='G'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'FLUIG')
		ElseIf PDM->PDM_TPOSIS =='D'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'DATASUL')
		ElseIf PDM->PDM_TPOSIS =='L'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'LOGIX')
		ElseIf PDM->PDM_TPOSIS =='F'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'FORMACAO')
		ElseIf PDM->PDM_TPOSIS =='E'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'EAD')
		ElseIf PDM->PDM_TPOSIS =='H'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'PCSISTEMAS')
		ElseIf PDM->PDM_TPOSIS =='I'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'VIRTUALAGE')
		EndIF

		//Instructor
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PD2->PD2_PROF )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "FIRSTNAME" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(PD2->PD2_NOME, 1,AT(' ',PD2->PD2_NOME )) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "LASTNAME" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(PD2->PD2_NOME,AT(' ',PD2->PD2_NOME )) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "EMAIL" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], (PD2->PD2_EMAIL) )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PHONENUMBER" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PD2->PD2_TEL )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTNUMBER" .AND. aVet[5] == cProf } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PD2->PD2_CPF )

        //Confirmed
  		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "CONFIRMED" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  M->PD3_STATUS )

		ni	:= 1
		nj	:= 1
		nk	:= 1
		For nk:=1 to Len(aChild)
			cComplex := "AddClass#1.Class#1.ClassDays#1.ClassDay#"+AllTrim(Str(nk))
			For nj:=4 to Len(aSimple)
				If aSimple[nj][5] == cComplex
					If ni <= Len(aChild[nk])
						nPos := aScan( aSimple, {|x| Upper(x[2]) == aChild[nk][ni][1] .AND. x[5] == cComplex } )
						If nPos > 0
							If nPos == nj
								If !Empty(aChild[nk][ni][2])
									xRet := oWsdl:SetValue( aSimple[nPos][1], aChild[nk][ni][2] )
									If xRet == .F.
										xRet := STR0029 + oWsdl:cError
										Return(xRet)
									Endif
								EndIf
								ni := ni +1
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		Next

	EndIf
	///Pega a mensagem que sera enviada para Web Service
	cMsg := oWsdl:GetSoapMsg()
	
	// Faz a requisição ao WebService
	lOk := oWsdl:SendSoapMsg(cMsg)
	
		If lLog 
			If AVISO("TI_LOGVLAB", oWSDL:GetSoapResponse(), {"Fechar","Salvar"}, 3) == 2
				MemoWrite( cgetFile(), oWSDL:GetSoapResponse())
			 Endif
					
		Endif
	
	If !lOk
		cRet += GetWSCError()
		cRet += CRLF
		cRet += oWSDL:GetSoapResponse()
		// ConOut('ERROR INTEGRAÇÃO VLABS-> ' + cRet + CRLF + cMsg)
		Return cRet
	EndIf

	//CRET:=oWsdl:GetSoapResponse()
	//ALERT(CRET)
Return


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
pre Validação (TudoOk) do modelo da alocação de turmas

@author Fabio Veiga Oliva
@version P12
@since 20/12/2019
@return oModel
/*/
//------------------------------------------------------------------------------
Static Function PreValid(oModel)
If oModel == Nil .Or.;
	oModel:GetOperation() = MODEL_OPERATION_DELETE .or.;
	oModel:GetOperation() = MODEL_OPERATION_VIEW
	//-- É realizada chamada com modelo nulo para verificar se a função existe
	Return .T.
EndIf

return .t.
//------------------------------------------------------------------------------

