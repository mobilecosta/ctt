#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} TCTTS001
ServiÁo REST para retornar informacoes do Portal Pesquisa SatisfaÁ„o CTT
/*/
//--------------------------------------------------------------
User Function TCTTS001()	
Return

//------------------------------------
// DefiniÁ„o da estrutura do webservice ..
// @type class
//------------------------------------
WSRESTFUL CTT DESCRIPTION "ServiÁo REST para retornar informacoes do Portal Pesquisa SatisfaÁ„o CTT"
    WSDATA cpf         AS STRING	OPTIONAL

    WSMETHOD GET Login ;
    DESCRIPTION 'ValidaÁ„o do login pelo cpf' ;
    WSSYNTAX '/api/login/{cpf}/?{,cpf}' ;
    PATH '/api/login/{cpf}' 

	WSMETHOD POST montagem ;
    DESCRIPTION 'Montagem lista de cursos a partir de um CPF' ;
    WSSYNTAX '/api/montagem/{body}';
    PATH '/api/montagem/{body}'	

	WSMETHOD POST grava ;
    DESCRIPTION 'Grava Dados pesquisa de satisfaÁ„o preenchida pelo Aluno' ;
    WSSYNTAX '/api/grava/{body}' ;
    PATH '/api/grava/{body}' 
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
			PD3.PD3_NOME, PD2.PD2_NOME, PD3.PD3_SALA, PDO.PDO_NOME, PDF.PDF_DTINI, PDF.PDF_DTFIM, 
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
					WHERE PD4_FILIAL BETWEEN %Exp:''% and %Exp:'zzzzz'% AND PD4_ALUNO = %Exp:M->PDL_ALUNO%
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
	//-- Aluno com alocaÁ„o
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
			cJSon += '{"PD3_NOME":' 	  + '"'   + Alltrim(PDLQRY->PD3_NOME) 	+ '"'
			cJSon += ',"PD2_NOME":' 	  + '"'   + Alltrim(PDLQRY->PD2_NOME) 	+ '"'
			cJSon += ',"PD3_SALA":' 	  + '"'   + Alltrim(PDLQRY->PD3_SALA) 	+ '"'
			cJSon += ',"PDO_NOME":' 	  + '"'   + Alltrim(PDLQRY->PDO_NOME) 	+ '"'
			cJSon += ',"PDF_DTINI":' 	  + '"'   + DTOC(PDLQRY->PDF_DTINI) 	+ '"'
			cJSon += ',"PDF_DTFIM":' 	  + '"'   + DTOC(PDLQRY->PDF_DTFIM) 	+ '"'
			cJSon += ',"PDF_PERIO":' 	  + '"'   + Alltrim(PDLQRY->PDF_PERIO) 	+ '"'
			cJSon += ',"PD7_TURMA":' 	  + '"'   + Alltrim(PDLQRY->PD7_TURMA) 	+ '"'
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
// POST - Montagem das questıes para pagina da pesquisa de satisfaÁaı
//------------------------------------
WSMETHOD POST montagem WSSERVICE CTT

Local cJson       := Self:GetContent()
Local oJson  	  := Nil
Local cErro  	  := ""
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

	// define o tipo de retorno do mÈtodo
	::SetContentType("application/json")

    oJson := JsonObject():New()
    cErro := oJSon:FromJson(cJson) 

   	If ValType(cError) != "U"
        cErro := '{"msg": "Erro no Parser do jSon "}'
        SetRestFault(400, cErro)
		Return .T.
	EndIf

	cPDF_TURMA := Alltrim(self:turma)
	cPDF_PERIO := Alltrim(self:periodo)
	
	PD2->(DbSetOrder(1))
	PDF->(DbSetOrder(1))
	IF PDF->(DBSEEK(_cFil_+ cPDF_TURMA + PERIODO)) .And. PD3->(DBSEEK(_cFil_+cPDF_TURMA))
		PD2->(DbSeek(xFilial() + PDF->PDF_PROF))
		
		PD5->(dbsetorder(1))	// Perguntas Pesquisa de SatisfaÁ„o
		PDG->(DBSETORDER(1))	// Equivalencias
		IF PD5->(Dbseek(xFilial("PD5")+PD3->PD3_PESQ))
			while PD5->(!EOF()) .AND. xFilial("PD5")+PD3->PD3_PESQ == PD5->(PD5_FILIAL+PD5_PESQ)
				IF PD5->PD5_MSBLQL == '2'	//-- N„o bloqueado
					cResp := ""
					IF ! Empty(PD5->PD5_PONTUA)
						IF PDG->(DBSEEK(xFilial()+PD5->PD5_PONTUA))
							AADD(aResp,{ "--", "--", 0})
							while PDG->(!EOF()) .AND. PDG->(PDG_FILIAL + PDG_PONTUA) == PD5->(PD5_FILIAL + PD5_PONTUA) 
								AADD(aResp,{ PDG->PDG_EQUIV, PDG->PDG_CONCEI, PDG->PDG_NOTAPO})
								PDG->(DBSKIP())
							END
							ASORT(aResp,2,,{|X,Y| X[1]>Y[1]})
							For nPos := 1 To Len(aResp)
								If nResp > 1
									cResp += ','
								EndIF

								cResp += '{"PDG_EQUIV":' + '"' + aResp[nPos][1] + '"'
								cResp += ',"PDG_CONCEI":'+ '"' + aResp[nPos][2] + '"'
								cResp += ',"PDG_NOTAPO":'+ '"' + aResp[nPos][3] + '"}'
							Next
						ENDIF
					ENDIF
					AADD(aPesq,{PD5->PD5_PESQ, PD5->PD5_ITEM, PD5->PD5_FINALI, PD5->PD5_DEPTO, PD5->PD5_ASSUNTO, PD5->PD5_PERGUN, PD5->PD5_MEMO, ;
								cResp, alltrim(PD5->PD5_PONTUA), aPD5_FINALI[val(PD5->PD5_FINALI)][3] })

				ENDIF
				PD5->(DBSKIP())
			END

			If Len(aPesq) > 0
				cJSon += '"resultado":"1"'
				cJSon += ',"PDL_CPF":' + '"' + Alltrim(self:PDL_CPF) + '"'
				cJSon += ',"PDL_NOME":' + '"' + Alltrim(self:PDL_NOME) + '"'
				cJSon += ',"PDL_EMAIL":' + '"' + Alltrim(self:PDL_EMAIL) + '"'
				cJSon += ',"A1_CGC":' + '"' + Alltrim(self:A1_CGC) + '"'
				cJSon += ',"A1_NOME":' + '"' + Alltrim(self:A1_NOME) + '"'
				cJSon += ',	"PDL_ALUNO":' + '"' + Alltrim(self:PDL_ALUNO) + '"'
				cJSon += ', ",aPesq": ['
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
				cJSon += '"DESCRICAO":' + '"' + "N„o existe perguntas ativas para pesquisa [" + PD3->PD3_PESQ + "] na Turma [" + cPDF_TURMA + "]" + '"'
			EndIF
		ELSE
			cJSon += '"RESULTADO": "0", '
			cJSon += '"DESCRICAO":' + '"' + "N„o existe o cadastro de pesquisa [" + PD3->PD3_PESQ + "] na Turma [" + cPDF_TURMA + "]" + '"'
		ENDIF
	else
		cJSon += '"RESULTADO": "0", "DESCRICAO":' + '"' + "A Turma/periodo [" + cPDF_TURMA + "/" + cPDF_PERIO + "] n„o foram encontradas" + '"'
	ENDIF

	cJson += '}'
	Self:SetResponse(cJSon)
	
Return .T.

//------------------------------------
// post - "Grava Dados pesquisa de Satisfa√ß√£o
//------------------------------------
WSMETHOD POST grava WSSERVICE CTT
 
 Local lPost := .T.
 Local cJson     := Self:GetContent()
 Local oParseJson    := NIL
 loca oItems := NIL
 Local cJsonRet  := ""
 local nCpf :=""
 local nEnd :=""

Local nP4_TURMA	:= 0
Local nP4_PERIO	:= 0
Local nP4_PESQ	:= 0
Local nP4_ALUNO	:= 0
Local nPCPF		:= 0
Local Radios	:= ""
Local Areas		:= ""
Local finalid	:= ""
Local depto		:= ""
Local nX
Local nY
Local oItems
Local aItens    := {}
Local Pontuac	:= ""
Local lRA		:= ""
Local lRet		:= .F.
Local lDelete	:= .F.
Local nGravado	:= nError := 0
Local cSQL		:= ""
Local nFor		:= 0

Private	cCpf	:= ""
//Private	cCurso	:= HttpPost->cCurso
Private cResp	:= "Problemas ao tentar salvar. Tente mais tarde ..."
Private aDadosC := {}

    Self:SetContentType("application/json")
 	//adiciona valores as variaveis vindo do body
   If FWJsonDeserialize(cJson,@oParseJson)
	
			//Busca os itens no JSON, percorre eles e adiciona no array da SC6
            For nX  := 1 To Len (oParseJson:ITENS)
                aLinha  := {}
                aAdd(aLinha,{"PDL_CPF",  AllTrim(oParseJson:ITENS[nX]:PDL_CPF),          NIL})
                aAdd(aLinha,{"PD4_TURMA",      AllTrim(oParseJson:ITENS[nX]:PD4_TURMA),  NIL})    
				aAdd(aLinha,{"PD4_PERIO",  AllTrim(oParseJson:ITENS[nX]:PD4_PERIO),          NIL})
                aAdd(aLinha,{"PD4_PESQ",      AllTrim(oParseJson:ITENS[nX]:PD4_PESQ),  NIL})  
				aAdd(aLinha,{"PD4_ALUNO",      AllTrim(oParseJson:ITENS[nX]:PD4_ALUNO),  NIL})  
               aAdd(aItens,aLinha)

            Next nX 

				if len(aItens)>0
					cCpf 	:= aItens[ITENS][2]
					cTurma	:= aItens[PD4_TURMA][2]
					cPerio	:= aItens[PD4_PERIO][2]
					cPesq   := aItens[PD4_PESQ][2]
					cAluno	:= aItens[PD4_ALUNO][2]
					
					PD3->(DbSetOrder(1))
					PDF->(DbSetOrder(1))
					PD3->(DbSeek(_cFil_ + cTurma))
					PDF->(DbSeek(_cFil_ + cTurma + cPerio))
					
					BeginTran()
					For nFor := 1 to len(aItens)
						if nFor < nPCPF
							lRA			:= SUBSTR(aItens[nFor][1],1,1)=='R'
							Radios		:= SUBSTR(aItens[nFor][1],6,2)
							Areas		:= SUBSTR(aItens[nFor][1],5,2)
							finalid		:= SUBSTR(aItens[nFor][1],AT('FINALID',aItens[nFor][1])+7,1)
							depto		:= SUBSTR(aItens[nFor][1],AT('DEPTO',aItens[nFor][1])+5,1)
							Pontuac		:= iif(lRA,SUBSTR(aItens[nFor][1],AT('PONTUAC',aItens[nFor][1])+7),' ')
							if UPPER(substr(IIF(lRA,Radios,Areas),1,2)) != 'OS'
								nGravado ++

								If ! lDelete
									cSQL := "DELETE FROM " + RetSqlName("PD4") + " " +;
											" WHERE D_E_L_E_T_ = ' ' AND PD4_FILIAL = '" + _cFil_ + "' AND PD4_TURMA = '" + cTurma + "' " +;
											"AND PD4_PERIO = '" + cPerio + "' AND PD4_ALUNO = '" + cAluno + "'"

									If (nError := TCSQLExec(cSQL)) <> 0
										cResp := "TCTTH040:DELETE_PD4 - " + AllTrim(Str(nError)) + "-" + TCSQLError()
										DisarmTran()
										Loop
									EndIf

									lDelete := .T.
								EndIf
								
								RecLock("PD4", .T.)
								PD4->PD4_FILIAL := _cFil_
								PD4->PD4_TURMA  := cTurma
								PD4->PD4_PERIO  := cPerio
								PD4->PD4_PESQ   := cPesq
								PD4->PD4_ALUNO  := cAluno
								PD4->PD4_ITEM   := IIF(lRA,Radios,Areas)
								PD4->PD4_FINALI := finalid 
								PD4->PD4_DEPTO  := depto
								PD4->PD4_ASSUNT := IIF(lRA,'1','2')
								PD4->PD4_PONTUA := Pontuac
								PD4->PD4_DTRESP := DATE()  
								PD4->PD4_RESPOS := IIF(lRA,'',aItens[nFor][2])
								PD4->PD4_EQUIV  := IIF(lRA,aItens[nFor][2],'')
								PD4->PD4_PROF	:= PDF->PDF_PROF
								PD4->PD4_DTCURS	:= PDF->PDF_DTINI
								PD4->(MsUnLock())
							EndIf
						endif
					Next nFor

					If nGravado > 0
						cSQL := "UPDATE " + RetSqlName("PD7") + " SET PD7_PESQRP = PD7_PESQRP + 1 " +; 
								"WHERE D_E_L_E_T_ = ' ' AND PD7_FILIAL = '" + xFilial("PD7") + "' AND PD7_TURMA = '" + cTurma + "' " +;
								"AND PD7_ALUNO = '" + cAluno + "'" 
						
						If (nError := TCSQLExec(cSQL)) <> 0
							cResp := "TCTTH040:UPDATE_PD7 - " + AllTrim(Str(nError)) + "-" + TCSQLError()
							DisarmTran()
						EndIf
					EndIf
					If nError == 0
						EndTran()
						
						If nGravado > 0
							cResp := "Respostas salvas com Sucesso"
						Else
							cResp := "Nenhum resposta para ser salva ..."
						EndIf
					EndIf
					
				Endif

		ELSE
				Conout(Dtoc(Date()) + " " + Time() + " - Erro na importa√ß√£o verifique " )
				SetRestFault(500,'Erro na importa√ß√£o verifique ')
				lRet    := .F.
		EndIf


Return lRet
