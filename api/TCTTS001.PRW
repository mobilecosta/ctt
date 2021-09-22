#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} TCTTS001
Serviço REST para retornar informacoes do Portal Pesquisa Satisfação CTT
/*/
//--------------------------------------------------------------
User Function TCTTS001()	
Return

//------------------------------------
// Definição da estrutura do webservice ..
// @type class
//------------------------------------
WSRESTFUL CTT DESCRIPTION "Serviço REST para retornar informacoes do Portal Pesquisa Satisfação CTT"
    WSDATA cpf         AS STRING
	WSDATA turma       AS STRING // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL
	WSDATA periodo     AS STRING // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL	

    WSMETHOD GET Login ;
    DESCRIPTION 'Validação do login pelo cpf' ;
    WSSYNTAX '/api/login/{cpf}' ;
    PATH '/api/login/{cpf}' 

	WSMETHOD GET montagem ;
    DESCRIPTION 'Montagem lista de cursos a partir de um CPF' ;
    WSSYNTAX '/api/montagem/{turma},{periodo}';
    PATH '/api/montagem'	

	WSMETHOD POST grava ;
    DESCRIPTION 'Grava Dados pesquisa de satisfação preenchida pelo Aluno' ;
    WSSYNTAX '/api/grava' ;
    PATH '/api/grava' 
END WSRESTFUL

//------------------------------------
// GET - "Valida Login por Cpf
//------------------------------------
WSMETHOD GET Login PATHPARAM cpf WSRECEIVE cpf WSSERVICE CTT
Local cJSon 	:= "{"
Local cCpf  	:= Alltrim(::aURLParms[3])
Local lCursos 	:= .F.

	PDL->(DbSetOrder(3))	// PDL_FILIAL+PDL_CPF
	PDL->(DbSeek(xFilial() + cCpf))
	M->PDL_ALUNO := PDL->PDL_ALUNO

	PDL->(DbSetOrder(1))

	BeginSQL Alias "PDLQRY"
		Column PDF_DTINI AS DATE 
		Column PDF_DTFIM AS DATE 
		
		SELECT PDL.PDL_ALUNO, PDL.PDL_NOME, PDL.PDL_CPF, PDL.PDL_EMAIL, PD7.PD7_FILIAL, PD7.PD7_TURMA, PDF.PDF_PERIO, 
			   PD3.PD3_NOME, PD3_PROF, PD2.PD2_NOME, PD3.PD3_SALA, PDO.PDO_NOME, PDF.PDF_DTINI, PDF.PDF_DTFIM, 
			   PD3_PESQ,
			   CASE WHEN PD4.PD4_FILIAL IS NULL THEN 0 ELSE 1 END PD7_PESQOK, 
			   CASE WHEN SUS.US_FILIAL IS NULL THEN SA1.A1_CGC ELSE SUS.US_CGC END AS A1_CGC, 
			   CASE WHEN SUS.US_FILIAL IS NULL THEN SA1.A1_NOME ELSE SUS.US_NOME END AS A1_NOME
		  FROM %table:PDL% PDL
		  LEFT JOIN (SELECT PD7_FILIAL, PD7_TURMA, PD7_ALUNO, PD7_CLIENT, PD7_LOJA, PD7_PROSPE, PD7_LOJPRO
		  			   FROM %table:PD7%
					   WHERE PD7_FILIAL BETWEEN %Exp:Repl(" ", Len(PD7->PD7_FILIAL))% 
						AND %Exp:Repl("X", Len(PD7->PD7_FILIAL))%
						AND PD7_ALUNO = %Exp:M->PDL_ALUNO% AND PD7_CONFIR IN ('1', '5', '6')
						AND %notDel% 
				   GROUP BY PD7_FILIAL, PD7_TURMA, PD7_ALUNO, PD7_CLIENT, PD7_LOJA, 
							PD7_PROSPE, PD7_LOJPRO) PD7 ON PD7.PD7_ALUNO = PDL.PDL_ALUNO 
		  LEFT JOIN %table:SA1% SA1 ON SA1.A1_FILIAL = %Exp:xFilial("SA1")% AND SA1.A1_COD = PD7.PD7_CLIENT 
		   AND SA1.A1_LOJA = PD7.PD7_LOJA AND SA1.%notDel% 
		  LEFT JOIN %table:SUS% SUS ON SUS.US_FILIAL = %Exp:xFilial("SUS")% AND SUS.US_COD = PD7.PD7_PROSPE
		   AND SUS.US_LOJA = PD7.PD7_LOJPRO AND SUS.%notDel% 
		  LEFT JOIN %table:PD3% PD3 ON PD3.PD3_FILIAL = PD7.PD7_FILIAL AND PD3.PD3_TURMA = PD7.PD7_TURMA 
		   AND PD3.%notDel%  
		  LEFT JOIN %table:PDF% PDF ON PDF.PDF_FILIAL = PD7.PD7_FILIAL AND PDF.PDF_TURMA = PD7.PD7_TURMA
		   AND PDF.%notDel%    
		  LEFT JOIN (SELECT PD4_FILIAL, PD4_TURMA, PD4_PERIO, PD4_PESQ, PD4_ALUNO
		  			   FROM %table:PD4%
					  WHERE PD4_FILIAL BETWEEN %Exp:Repl(" ", Len(PD4->PD4_FILIAL))% 
						AND %Exp:Repl("X", Len(PD4->PD4_FILIAL))% AND PD4_ALUNO = %Exp:M->PDL_ALUNO%
						AND %notDel%
					  GROUP BY PD4_FILIAL, PD4_TURMA, PD4_PERIO, PD4_PESQ, PD4_ALUNO) PD4 ON PD4.PD4_FILIAL = PD3.PD3_FILIAL 
				        AND PD4.PD4_TURMA = PD3.PD3_TURMA AND PD4.PD4_PERIO = PDF.PDF_PERIO 
				        AND PD4.PD4_PESQ = PD3.PD3_PESQ AND PD4.PD4_ALUNO = PD7.PD7_ALUNO
		  LEFT JOIN %table:PDO% PDO ON PDO.PDO_FILIAL = PD7.PD7_FILIAL AND PDO.PDO_SALA = PD3.PD3_SALA  
		   AND PDO.%notDel% 
		  LEFT JOIN %table:PD2% PD2 ON PD2.PD2_FILIAL = %Exp:xFilial("PD2")% AND PD2.PD2_PROF = PDF.PDF_PROF
		   AND PD2.%notDel%
		 WHERE PDL.PDL_FILIAL = %Exp:xFilial("PDL")% AND PDL.PDL_CPF = %Exp:cCpf% AND PDL.%notDel% 
		 ORDER BY PD7.PD7_FILIAL, PD7.PD7_TURMA, PDF.PDF_PERIO
	EndSql

	// define o tipo de retorno do metodo
	::SetContentType("application/json")

	IF Empty(PDLQRY->PDL_ALUNO)
		cJSon += '"RESULTADO": "0", "DESCRICAO":' + '"' + "Nao existe aluno com cpf informado [" + cCPF + "]" + '"'
	ELSEIF Empty(PDLQRY->PD7_TURMA)
		cJSon += '"RESULTADO": "0", "DESCRICAO":' + '"' + "Aluno do CPF [" + cCPF + "] sem alocacao" + '"'
	//-- Aluno com alocação
	ELSEIF ! Empty(PDLQRY->PD7_TURMA)
		cJSon += '"resultado":"1"'
		cJSon += ',"PDL_CPF":' + '"' + Alltrim(PDLQRY->PDL_CPF) + '"'
		cJSon += ',"PDL_NOME":' + '"' + Alltrim(PDLQRY->PDL_NOME) + '"'
		cJSon += ',"PDL_EMAIL":' + '"' + Alltrim(PDLQRY->PDL_EMAIL) + '"'
		cJSon += ',"A1_CGC":' + '"' + Alltrim(PDLQRY->A1_CGC) + '"'
		cJSon += ',"A1_NOME":' + '"' + Alltrim(PDLQRY->A1_NOME) + '"'
		cJSon += ',	"PDL_ALUNO":' + '"' + Alltrim(PDL_ALUNO) + '"'
		cJSon += ', "aCursos": ['
		
		WHILE PDLQRY->(!EOF())
			If lCursos
				cJSon += ","
			EndIf
			cJSon += '{"PD3_NOME":' 	  + '"'   + Alltrim(EncodeUTF8(PDLQRY->PD3_NOME)) 	+ '"'
			cJSon += ',"PD3_PROF":' 	  + '"'   + Alltrim(PDLQRY->PD3_PROF) 	+ '"'
			cJSon += ',"PD2_NOME":' 	  + '"'   + Alltrim(EncodeUTF8(PDLQRY->PD2_NOME)) 	+ '"'
			cJSon += ',"PD3_SALA":' 	  + '"'   + Alltrim(PDLQRY->PD3_SALA) 	+ '"'
			cJSon += ',"PDO_NOME":' 	  + '"'   + Alltrim(EncodeUTF8(PDLQRY->PDO_NOME)) 	+ '"'
			cJSon += ',"PDF_DTINI":' 	  + '"'   + DTOC(PDLQRY->PDF_DTINI) 	+ '"'
			cJSon += ',"PDF_DTFIM":' 	  + '"'   + DTOC(PDLQRY->PDF_DTFIM) 	+ '"'
			cJSon += ',"PDF_PERIO":' 	  + '"'   + Alltrim(PDLQRY->PDF_PERIO) 	+ '"'
			cJSon += ',"PD7_TURMA":' 	  + '"'   + Alltrim(PDLQRY->PD7_TURMA) 	+ '"'
			cJSon += ',"PD3_PESQ":' 	  + '"'   + Alltrim(PDLQRY->PD3_PESQ) 	+ '"'
			cJSon += ',"PD7_PESQOK":' 	  +AllTrim(Str(PDLQRY->PD7_PESQOK)) 
			cJSon += "}"
			lCursos := .T.
			PDLQRY->(DBSKIP())
		ENDDO
		cJSon += ']'
	ENDIF
	PDLQRY->(DbCloseArea()) 
	cJson += '}'

	Self:SetResponse(cJSon)

Return .T.

//------------------------------------
// GET - Montagem das questões para pagina da pesquisa de satisfaçaõ
//------------------------------------
WSMETHOD GET montagem  WSRECEIVE turma, periodo WSSERVICE CTT

Local cPDF_TURMA  :=  ""
Local cPDF_PERIO  :=  ""
Local cJSon	 	  := "{"
Local aPesq		  := {}
Local aResp		  := {}
Local cResp       := ""
Local nPos        := 1
Local aPD5_FINALI := RetSx3Box( Posicione("SX3", 2, "PD5_FINALI", "X3CBox()" ),,, 1 )

Default self:turma         := ''
Default self:periodo       := ''

	// define o tipo de retorno do método
	::SetContentType("application/json")

	cPDF_TURMA := Alltrim(self:turma)
	cPDF_PERIO := Alltrim(self:periodo)
	
	PD2->(DbSetOrder(1))
	PDF->(DbSetOrder(1))
	IF PDF->(DBSEEK(xFilial() + cPDF_TURMA + cPDF_PERIO)) .And. PD3->(DBSEEK(xFilial() +cPDF_TURMA))
		PD2->(DbSeek(xFilial() + PDF->PDF_PROF))
		
		PD5->(dbsetorder(1))	// Perguntas Pesquisa de Satisfação
		PDG->(DBSETORDER(1))	// Equivalencias
		IF PD5->(Dbseek(xFilial("PD5")+PD3->PD3_PESQ))
			while PD5->(!EOF()) .AND. xFilial("PD5")+PD3->PD3_PESQ == PD5->(PD5_FILIAL+PD5_PESQ)
				IF PD5->PD5_MSBLQL == '2'	//-- Não bloqueado
					cResp := ""
					IF ! Empty(PD5->PD5_PONTUA)
						aResp := {}
						IF PDG->(DBSEEK(xFilial()+PD5->PD5_PONTUA))
							while PDG->(!EOF()) .AND. PDG->(PDG_FILIAL + PDG_PONTUA) == PD5->(PD5_FILIAL + PD5_PONTUA) 
								AADD(aResp,{ PDG->PDG_EQUIV, PDG->PDG_CONCEI, PDG->PDG_NOTAPO})
								PDG->(DBSKIP())
							END
							ASORT(aResp,2,,{|X,Y| X[1]>Y[1]})
							For nPos := 1 To Len(aResp)
								If nPos > 1
									cResp += ','
								EndIF
								cResp += '{"label":'+ '"' + AllTrim(aResp[nPos][2]) + '"'
								cResp += ',"value":'+ '"' + AllTrim(aResp[nPos][1]) + '"'
								cResp += ',"equivalencia":'+ '"' + AllTrim(aResp[nPos][1]) + '"'
								cResp += ',"conceito":'+ '"' + AllTrim(aResp[nPos][2]) + '"}'
							Next
						ENDIF
					ENDIF
					AADD(aPesq,{PD5->PD5_PESQ, PD5->PD5_ITEM, PD5->PD5_FINALI, PD5->PD5_DEPTO,;
								PD5->PD5_ASSUNT, EncodeUTF8(PD5->PD5_PERGUN), EncodeUTF8(PD5->PD5_MEMO), ;
								cResp, alltrim(PD5->PD5_PONTUA), aPD5_FINALI[val(PD5->PD5_FINALI)][3] })

				ENDIF
				PD5->(DBSKIP())
			END

			If Len(aPesq) > 0
				Asort(aPesq,,,{|z,x| z[1]+z[3]+z[2]< x[1]+x[3]+x[2] })			
				cJSon += '"resultado":"1", "aPesq": ['
				For nPos := 1 To Len(aPesq)
					If nPos > 1
						cJSon += ","
					EndIf
					cJSon += '{"PD5_PESQ":' 	  + '"'   + Alltrim(aPesq[nPos][1]) 	+ '"'
					cJSon += ',"PD5_ITEM":' 	  + '"'   + Alltrim(aPesq[nPos][2]) 	+ '"'
					cJSon += ',"PD5_FINALI":' 	  + '"'   + Alltrim(aPesq[nPos][3]) 	+ '"'
					cJSon += ',"PD5_DEPTO":' 	  + '"'   + Alltrim(aPesq[nPos][4]) 	+ '"'
					cJSon += ',"PD5_ASSUNTO":' 	  + '"'   + Alltrim(aPesq[nPos][5]) 	+ '"'
					cJSon += ',"PD5_PERGUN":' 	  + '"'   + Alltrim(aPesq[nPos][6]) 	+ '"'
					cJSon += ',"PD5_MEMO":' 	  + '"'   + Alltrim(aPesq[nPos][7]) 	+ '"'
					cJSon += ', "aRespostas": [' + aPesq[nPos][8] + "]"
					cJSon += ',"PD5_PONTUA":' 	  + '"'   + Alltrim(aPesq[nPos][9]) 	+ '"'					
					cJSon += ',"PD5_FINALI_D":'   + '"'   + Alltrim(aPesq[nPos][10]) 	+ '"'
					cJSon += "}"
				Next
				cJSon += ']'
			Else
				cJSon += '"RESULTADO": "0", '
				cJSon += '"DESCRICAO":' + '"' + "Não existe perguntas ativas para pesquisa [" + PD3->PD3_PESQ + "] na Turma [" + cPDF_TURMA + "]" + '"'
			EndIF
		ELSE
			cJSon += '"RESULTADO": "0", '
			cJSon += '"DESCRICAO":' + '"' + "Não existe o cadastro de pesquisa [" + PD3->PD3_PESQ + "] na Turma [" + cPDF_TURMA + "]" + '"'
		ENDIF
	else
		cJSon += '"RESULTADO": "0", "DESCRICAO":' + '"' + "A Turma/periodo [" + cPDF_TURMA + "/" + cPDF_PERIO + "] não foram encontradas" + '"'
	ENDIF

	cJson += '}'
	Self:SetResponse(cJSon)
	
Return .T.

//------------------------------------
// post - "Grava Dados pesquisa de SatisfaÃ§Ã£o
//------------------------------------
WSMETHOD POST grava WSSERVICE CTT
 
    Local cJSON     := Self:GetContent() // Pega a string do JSON
    Local oJson     := Nil
    Local cResponse := ""
	Local aItem     := {}
	Local nPos      := 1
	Local aNames    := {}
	Local nNames    := 1
	Local xValue    := Nil
	Local aPD4		:= {}
	Local lOk		:= .F.
	Local aDadosC	:= {}

    // define o tipo de retorno do metodo
    Self:SetContentType("application/json")
    oJson  := JsonObject():New()
    cError := oJSon:FromJson(cJson) 

   If ValType(cError) != "U"

        cResponse := '{"msg": "Erro no Parser do jSon "}'
        SetRestFault(400, cResponse)
    Else
		aNames := oJson:GETNAMES()
		For nNames := 1 To Len(aNames)
			If Upper(aNames[nNames]) == "RESPOSTAS"
				Loop
			EndIF
			xValue := oJson[aNames[nNames]]
			If FWSX3Util():GetFieldType( aNames[nNames] ) == "D"
 				xValue := Ctod(XValue)
			EndIF
			Aadd(aPD4, { aNames[nNames], xValue })
		Next

		M->PD4_TURMA := ""
		M->PD4_PROF  := ""
		M->PD4_ALUNO := ""
		M->PD4_PESQ  := ""
		M->PD4_PERIO := ""
		// PD4_FILIAL+PD4_PESQ+PD4_TURMA+PD4_ALUNO+PD4_PERIO+PD4_ITEM  
		// 0100100000100000101
		aItem := oJson:GetJsonObject('respostas') 
		for nPos := 1 to len(aItem)
			aNames := oJson['respostas'][nPos]:GETNAMES()
			For nNames := 1 To Len(aPD4)
				If aPD4[nNames][1] == "PD4_PROF"
					M->PD4_PROF := Left(aPD4[nNames][2] + Space(Len(PD4->PD4_PROF)), Len(PD4->PD4_PROF))
				ElseIf aPD4[nNames][1] == "PD4_TURMA"
					M->PD4_TURMA := Left(aPD4[nNames][2] + Space(Len(PD4->PD4_TURMA)), Len(PD4->PD4_TURMA))
				ElseIf aPD4[nNames][1] == "PD4_ALUNO"
					M->PD4_ALUNO := Left(aPD4[nNames][2] + Space(Len(PD4->PD4_ALUNO)), Len(PD4->PD4_ALUNO))
				ElseIf aPD4[nNames][1] == "PD4_PESQ"
					M->PD4_PESQ := Left(aPD4[nNames][2] + Space(Len(PD4->PD4_PESQ)), Len(PD4->PD4_PESQ))
				ElseIf aPD4[nNames][1] == "PD4_PERIO"
					M->PD4_PERIO := Left(aPD4[nNames][2] + Space(Len(PD4->PD4_PERIO)), Len(PD4->PD4_PERIO))
				EndIf
			Next
		Next

		// ConOut("Chave: [" + xFilial("PD4") + M->PD4_PESQ+M->PD4_TURMA+M->PD4_ALUNO+M->PD4_PERIO + "]")
		If Empty(M->PD4_PESQ) .Or. Empty(M->PD4_TURMA) .Or. Empty(M->PD4_ALUNO) .Or. Empty(M->PD4_PERIO)
			cResponse := '{ "msg": "É obrigatorio o preenchimento dos campos PD4_PESQ, PD4_TURMA, PD4_ALUNO e PD4_PERIO" }'
		ElseIf PD4->(DbSeek(xFilial("PD4") + M->PD4_PESQ+M->PD4_TURMA+M->PD4_ALUNO+M->PD4_PERIO, .T.))
			cResponse := '{ "msg": "Pesquisa já respondida para essa turma/aluno e periodo" }'
		Else
			lOk := .T.
		EndIf
	EndIf
	
	If lOk
		aItem := oJson:GetJsonObject('respostas') 
		for nPos := 1 to len(aItem)
			aMatriz  := {}
			oJsonDet :=  aItem[nPos]
			aNames := oJson['respostas'][nPos]:GETNAMES()

			RecLock("PD4", .T.)
			PD4->PD4_FILIAL := xFilial("PD4")
			PD4->PD4_DTRESP := msDate()
			For nNames := 1 To Len(aPD4)
				&("PD4->" + aPD4[nNames][1]) := aPD4[nNames][2]
			Next

			For nNames := 1 To Len(aNames)
				If ! Empty(oJsonDet[aNames[nNames]])
					xValue := oJsonDet[aNames[nNames]]
					If FWSX3Util():GetFieldType( aNames[nNames] ) == "D"
						xValue := Stod(StrTran(xValue, "-", ""))
					EndIF
					&("PD4->" + aNames[nNames]) := xValue
				EndIf
			Next
		Next
		cSQL := "UPDATE " + RetSqlName("PD7") + " SET PD7_PESQRP = PD7_PESQRP + 1 " +; 
		         "WHERE D_E_L_E_T_ = ' ' AND PD7_FILIAL = '" + xFilial("PD7") + "' AND PD7_TURMA = '" + M->PD4_TURMA + "' " +;
		           "AND PD7_ALUNO = '" + M->PD4_ALUNO + "'" 
		
		If (nError := TCSQLExec(cSQL)) <> 0
			cResponse := '{ "msg": "Erro Update - " + ' + AllTrim(Str(nError)) + "-" + TCSQLError() + " }'
   			DisarmTran()
		Else
			cResponse := '{ "msg": "Sucesso" } '
			PD3->(DbSeek(xFilial() + M->PD4_TURMA))
			PD2->(DbSeek(xFilial() + M->PD4_PROF))
			PDL->(DbSeek(xFilial() + M->PD4_ALUNO))
			PDF->(DbSeek(xFilial() + M->PD4_TURMA + PD4_PERIO))

// Versão Advpl ASP
//			aadd(aDadosC,{	HTTPPOST->aDadosC1,HTTPPOST->aDadosC2,HTTPPOST->aDadosC3,HTTPPOST->aDadosC4 ,HTTPPOST->aDadosC5 ,HTTPPOST->aDadosC6,;
//							HTTPPOST->aDadosC7,HTTPPOST->aDadosC8,HTTPPOST->aDadosC9,HTTPPOST->aDadosC10,HTTPPOST->aDadosC11,HTTPPOST->aDadosC12,;
//							HTTPPOST->aDadosC13})
//	AADD(aDadosC,{ 	TRANS(PDLQRY->PDL_CPF,"@R 999.999.999-99") 01, PDLQRY->PDL_NOME 02, PDLQRY->PDL_EMAIL 03,;
//					transform(PDLQRY->A1_CGC, If(Len(PDLQRY->A1_CGC) = 11, "@R 999.999.999-99", "@R 99.999.999/9999-99")) 04, PDLQRY->A1_NOME 05,;
//                  DATE() 06, TIME() 07, PDLQRY->PDL_ALUNO 08, _cEmp_ 09, _cFil_ 10, PDF->PDF_DTINI 11, PDF->PDF_DTFIM 12, PD3->PD3_PERIOD 13 })

			aDadosC := { { 	"", PDL->PDL_NOME, PDL->PDL_EMAIL, "", "", Date(), Time(), M->PD4_ALUNO, cEmpAnt, cFilAnt,;
							Dtoc(PDF->PDF_DTINI), Dtoc(PDF->PDF_DTFIM), PD3->PD3_PERIOD } }
			StartJob( "U_TCTTM010", GetEnvServer(), .F., {{	SM0->M0_CODIGO,SM0->M0_CODFIL}, AllTrim(PD2->PD2_EMAIL),;
															"", "", "", aDadosC, M->PD3_CURSO } )

   		EndIf

    EndIf
	Self:SetResponse( cResponse )

Return .T.