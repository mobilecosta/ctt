#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} TCTTS001
Servi�o REST para retornar informacoes do Portal Pesquisa Satisfa��o CTT
/*/
//--------------------------------------------------------------
User Function TCTTS001()	
Return

//------------------------------------
// Defini��o da estrutura do webservice ..
// @type class
//------------------------------------
WSRESTFUL CTT DESCRIPTION "Servi�o REST para retornar informacoes do Portal Pesquisa Satisfa��o CTT"
    WSDATA cpf         AS STRING	OPTIONAL
	WSDATA turma       AS STRING	OPTIONAL // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL
	WSDATA periodo       AS STRING	OPTIONAL // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL	
	WSDATA id	        AS STRING	OPTIONAL

    WSMETHOD GET Login ;
    DESCRIPTION 'Valida��o do login pelo cpf' ;
    WSSYNTAX '/api/login/{cpf}/?{,cpf}' ;
    PATH '/api/login/{cpf}' 

	WSMETHOD GET montagem ;
    DESCRIPTION 'Montagem lista de cursos a partir de um CPF' ;
    WSSYNTAX '/api/montagem/?{turma, periodo}';
    PATH '/api/montagem'	

	WSMETHOD POST grava ;
    DESCRIPTION 'Grava Dados pesquisa de satisfa��o preenchida pelo Aluno' ;
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

	// define o tipo de retorno do método
	::SetContentType("application/json")

	//-- Aluno com alocação
	IF Empty(PDLQRY->PDL_ALUNO)
		cJSon += '"RESULTADO": "0", "DESCRICAO":' + '"' + "Nao existe aluno com cpf informado [" + cCPF + "]" + '"'
	ELSEIF Empty(PDLQRY->PD7_TURMA)
		cJSon += '"RESULTADO": "0", "DESCRICAO":' + '"' + "Aluno do CPF [" + cCPF + "] sem alocacao" + '"'
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
// GET - "Montagem das questões para pagina da pesquisa de satisfação
//------------------------------------
WSMETHOD GET montagem  WSRECEIVE turma, periodo WSSERVICE CTT
Local lRet			       := .T.
Local i
Local aResp	 := {}
Local cTurma := cChave := ""
Local _cEmp_    := GetPvProfString(GetEnvServer(),"EMP_CTT","00",GetAdv97())
Local _cFil_    := GetPvProfString(GetEnvServer(),"FIL_CTT","00001000100",GetAdv97())
Local cDados               :=''
Local cJSon	               := ""
Default self:turma         := ''
Default self:periodo       := ''

// define o tipo de retorno do método
::SetContentType("application/json")

PERIODO := Alltrim(self:periodo)
cTurma := Alltrim(self:turma)

 
RpcSetEnv( _cEmp_,_cFil_,,, "FIN", "pesquisa", { "PD2", "PD3", "PD5", "PDG" },,,,)

//CODALU	:= HTTPPOST->aDadosC8
//aTipo   := RetSx3Box( Posicione("SX3", 2, "PD5_FINALI", "X3CBox()" ),,, 1 )

Self:SetResponse('[')

PD2->(DbSetOrder(1))
PDF->(DbSetOrder(1))
IF PDF->(DBSEEK(_cFil_+cTurma + PERIODO)) .And. PD3->(DBSEEK(_cFil_+cTurma))
	//aadd(aDadosC,{	HTTPPOST->aDadosC1,HTTPPOST->aDadosC2,HTTPPOST->aDadosC3,HTTPPOST->aDadosC4,HTTPPOST->aDadosC5,HTTPPOST->aDadosC6,HTTPPOST->aDadosC7,;
					//HTTPPOST->aDadosC8,HTTPPOST->aDadosC9,HTTPPOST->aDadosC10, PDF->PDF_DTINI, PDF->PDF_DTFIM, PD3->PD3_PERIOD, _cFil_, PERIODO })
	//HTTPSESSION->aDadosC := aDadosC
	
	PD2->(DbSeek(xFilial() + PDF->PDF_PROF))
	cCurso	:= 	"Turma " + cTurma + "/" + PERIODO + " - " + ALLTRIM(PD3->PD3_NOME)+" / "+ALLTRIM(PD2->PD2_NOME) + " - " +;
				DTOC(PDF->PDF_DTINI) + " a " + DTOC(PDF->PDF_DTFIM) + " - Carga Horária: " + AllTrim(Str(PDF->PDF_QTDHOR)) + " hs"   
	
	PD5->(dbsetorder(1))	// PERGUNTAS PESQUISA SATISFAÇÃO
	PDG->(DBSETORDER(1))	// EQUIVALENCIAS
	IF PD5->(Dbseek(xFilial("PD5")+PD3->PD3_PESQ))
		while PD5->(!EOF()) .AND. xFilial("PD5")+PD3->PD3_PESQ == PD5->(PD5_FILIAL+PD5_PESQ)
			IF PD5->PD5_MSBLQL == '2'	//-- Não bloqueado
				IF ! Empty(PD5->PD5_PONTUA)
					IF PDG->(DBSEEK(xFilial()+PD5->PD5_PONTUA))
						AADD(aResp,{ "--", "--", 0})
						while PDG->(!EOF()) .AND. PDG->(PDG_FILIAL + PDG_PONTUA) == PD5->(PD5_FILIAL + PD5_PONTUA) 
							AADD(aResp,{ PDG->PDG_EQUIV, PDG->PDG_CONCEI, PDG->PDG_NOTAPO})
							PDG->(DBSKIP())
						END
						//ASORT(aResp,2,,{|X,Y| X[1]>Y[1]})
						cRep := ""
					ELSE
						cRep := "Não possui um grupo de resposta para essa pergunta"
					ENDIF
				ENDIF
				//AADD(aPesq,{PD5->PD5_PESQ, PD5->PD5_ITEM, PD5->PD5_FINALI, PD5->PD5_DEPTO, PD5->PD5_ASSUNTO, PD5->PD5_PERGUN, PD5->PD5_MEMO, ;
						//	aResp, cRep, alltrim(PD5->PD5_PONTUA), cTurma, aTipo[val(PD5->PD5_FINALI)][3]})
			cJSon += '{"PD5_PESQ":' 	  + '"'   + Alltrim(PD5->PD5_PESQ) 	+ '"'
            cJSon += ',"PD5_ITEM":' 	  + '"'   + Alltrim(PD5->PD5_ITEM) 	+ '"'
			cJSon += ',"PD5_FINALI":' 	  + '"'   + Alltrim(PD5->PD5_FINALI) 	+ '"'
			cJSon += ',"PD5_DEPTO":' 	  + '"'   + Alltrim(PD5->PD5_DEPTO) 	+ '"'
			cJSon += ',"PD5_PERGUN":' 	  + '"'   + Alltrim(PD5->PD5_PERGUN) 	+ '"'
			cJSon += ',"PD5_MEMO":' 	  + '"'   + Alltrim(PD5->PD5_MEMO) 	+ '"'
      		cJSon += ',"PD5_PONTUA":' 	  + '"'   + Alltrim(PD5->PD5_PONTUA) 	+ '"'
			cJSon += ',"PD5_FINALI":' 	  + '"'   + Alltrim(PD5->PD5_FINALI) 	+ '"'
			cJSon += "},"
				
				aResp 	:= {}
				cRep 	:= ""
				CODPESQ	:= PD5->PD5_PESQ
 			  	CODTURM	:= cTurma
			ENDIF
			PD5->(DBSKIP())
		END
		//mostra cjson rest
		
	
	ELSE
		//cRep := "Não existe o cadastro de pesquisa [" + PD3->PD3_PESQ + "] na Turma [" + cTurma + "]"
		cRet := "Não existe o cadastro de pesquisa [" + PD3->PD3_PESQ + "] na Turma [" + cTurma + "]"
				cJSon += '[{"resultado":"0"'
				cJSon += ',"Motivo":' 	  + '"'   + Alltrim(cRet) 	+ '" }]'
	ENDIF
else
	//cRep := "A Turma/periodo [" + cTurma + "/" + PERIODO + "] não foram encontradas"
    cRet := "A Turma/periodo [" + cTurma + "/" + PERIODO + "] não foram encontradas"
				cJSon += '[{"resultado":"0"'
				cJSon += ',"Motivo":' 	  + '"'   + Alltrim(cRet) 	+ '"}]'
					//	aadd(aDadosC,{	HTTPPOST->aDadosC1,HTTPPOST->aDadosC2,HTTPPOST->aDadosC3,HTTPPOST->aDadosC4,HTTPPOST->aDadosC5,HTTPPOST->aDadosC6,HTTPPOST->aDadosC7,;
					//HTTPPOST->aDadosC8,HTTPPOST->aDadosC9,HTTPPOST->aDadosC10,STOD(''),STOD(''),''})
					//	HTTPSESSION->aDadosC := aDadosC
ENDIF

Self:SetResponse(cJSon)
Self:SetResponse(']')
Return lRet


//------------------------------------
// post - "Grava Dados pesquisa de Satisfação
//------------------------------------
WSMETHOD POST grava WSSERVICE CTT
 
 Local lPost := .T.
 Local cJson     := Self:GetContent()
 Local oParseJson    := NIL
 loca oItems := NIL
 Local cJsonRet  := ""
 local nCpf :=""
 local nEnd :=""
Local oResponse   := JsonObject():New()
Local oBody       := JsonObject():New()
Local oDataBase   := JsonObject():New()

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
Local _cEmp_    := GetPvProfString(GetEnvServer(),"EMP_CTT","00",GetAdv97())
Local _cFil_    := GetPvProfString(GetEnvServer(),"FIL_CTT","00001000100",GetAdv97())
Local nFor		:= 0

Private	cCpf	:= ""
//Private	cCurso	:= HttpPost->cCurso
Private cResp	:= "Problemas ao tentar salvar. Tente mais tarde ..."
Private aDadosC := {}

//aadd(aDadosC,{	HTTPPOST->aDadosC1,HTTPPOST->aDadosC2,HTTPPOST->aDadosC3,HTTPPOST->aDadosC4,HTTPPOST->aDadosC5,HTTPPOST->aDadosC6,HTTPPOST->aDadosC7,;
			//	HTTPPOST->aDadosC8,HTTPPOST->aDadosC9,HTTPPOST->aDadosC10,HTTPPOST->aDadosC11,HTTPPOST->aDadosC12,HTTPPOST->aDadosC13})
//HTTPSESSION->aDadosC := aDadosC


RpcClearEnv()
RpcSetEnv( _cEmp_,_cFil_,,, "FIN", "pesquisa", { "PD2", "PD3", "PD4" },,,,)


//Definindo o conteÃºdo como JSON, e pegando o content e dando um parse para ver se a estrutura estÃ¡ ok
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
				Conout(Dtoc(Date()) + " " + Time() + " - Erro na importação verifique " )
				SetRestFault(500,'Erro na importação verifique ')
				lRet    := .F.
		EndIf


Return lRet
