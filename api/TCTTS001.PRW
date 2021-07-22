#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TCTTS001   º Autor ³ Jose Mendes        º Data ³  16/07/2021   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ WebService Rest ()					  º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TCTTS001()	
Return

WSRESTFUL CTT DESCRIPTION "Serviço REST para retornar informacoes do Ctt"

WSDATA CPF As String //String que vamos receber via URL
WSDATA codpesq As String
WSDATA count      AS INTEGER
WSDATA startIndex AS INTEGER
 
WSMETHOD GET DESCRIPTION "Valida Login por Cpf" WSSYNTAX "/CPF || /CPF/{CPF}" 	//Disponibilizamos um método do tipo GET
//WSMETHOD GET DESCRIPTION "Retorna perguntas a serem Pesquisadas" WSSYNTAX "/pesquisa/{codpesq}" 
WSMETHOD POST DESCRIPTION "Envia Post da Pesquisa " WSSYNTAX "/envia"
END WSRESTFUL

//------------------------------------
// GET - "Valida Login por Cpf
//------------------------------------
WSMETHOD GET WSRECEIVE CPF WSSERVICE CTT
Local i
Local cJSon		:= "{"
// define o tipo de retorno do método
::SetContentType("application/json")

//verificar se existe parametro no ctt\cpf
If Len(::aURLParms) > 0
	cCPF := Alltrim(::aURLParms[1])

// FAZ TESTE FAKE 
	IF cCPF = "0000000000001"
			//cJSon += '"resultado":"1"'
		//	cJSon += '"PDL_CPF":"0000000000001"'
			//cJSon += '"PDL_NOME":"Aluno Silva Santos"'
		//	cJSon += '"PDL_EMAIL":"naotem@naotem.com.br"'

		//faço um for para 3 registro fake se caso login retornar mais de uma pesquisa
		// ::count pode colocar quantidade de registro para teste
		DEFAULT ::startIndex := 1, ::count := 1
	   	
	  	::SetResponse('[')
	  	For i := ::startIndex To ::count + 1
	  		If i > ::startIndex
	      		::SetResponse(',')
	    	EndIf
	    	::SetResponse('{"Resultado":"1","PDL_CPF":"0000000000001","cEmp":"00.0000.254/00001-35","cFil":"TOTVS SA","PDL_ALUNO":"Aluno Silva Santos","PDL_EMAIL":"naotem@naotem.com.br","PD7_TURMA":"00003","PD7_PESQOK":"0","PD2_NOME":"CURSO","PD2_NOME":"PROFESSOR","PDF_DTINI":"21/06/2021","PDF_DTFIM":"21/07/2021","PD7_TURMA":"TURMA","PD3_SALA":"SALA" }')
	  	Next
	  	
	  	::SetResponse(']')


	Else
		cJSon += '"resultado":"0"'
Endif	

//If Select("TMPFS2M") > 0
			//TMPFS2M->(dbCloseArea())
//Endif                                     
	
	//	cQry1 := "Select PDL.PDL_CPF,PDL.PDL_NOME "
	//	cQry1 += "From " + RetSqlName("PDL") + " PDL (NoLock) "
	//	cQry1 += "Where PDL.D_E_L_E_T_<>'*' "
	//	cQry1 += "And PDL_FILIAL = '" + xFilial("PDL") 	+ "' "
	//	cQry1 += "And PDL.PDL_CPF = '" + cCPF	+ "' "
			 
	//	cQry1 := ChangeQuery(cQry1)
	//	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TMPFS2M",.T.,.F.)
	
	//	dbSelectArea("TMPFS2M")
	//	dbGoTop()
		
	//	if (TMPFS2M->(Eof()))
			// NÃO ACHOU CNPJ
		//	cJSon += '"resultado":"0"}'
		///	TMPFS2M->(dbCloseArea())
	//	Else
		//	cJSon += '"resultado":"1"'
			//cJSon += '"cpf":' 	  + '"'   + Alltrim(TMPFS2M->PDL_CPF) 	+ '"'
			//cJSon += '"":' + '"' + Alltrim(TMPFS2M->PDL_NOME)  + '"'
		//	cJSon += "}"
		///	TMPFS2M->(dbCloseArea())		
	//	Endif
	

//::SetResponse(cJSon)

Else
		        cJSon += '"resultado":"0"}'
				Self:SetResponse(cJSon)
	
EndIf
Return .T.

//------------------------------------
// post - "Envia Post da Pesquisa
//------------------------------------
WSMETHOD POST WSSERVICE CTT
Local lPost := .T.
local nNome := ""
 Local cJson     := Self:GetContent()
 Local cError := ""
 Local oParseJson    := NIL
 Local cJsonRet  := ""
 local nCpf :=""
 local nEnd :=""
Local oResponse   := JsonObject():New()
Local oBody       := JsonObject():New()
Local oDataBase   := JsonObject():New()
Local cErroAuto   := ''
Local cErrBody    := ''

//Definindo o conteÃºdo como JSON, e pegando o content e dando um parse para ver se a estrutura estÃ¡ ok
    Self:SetContentType("application/json")
 
   If FWJsonDeserialize(cJson,@oParseJson)
		nCpf  := AllTrim(oParseJson:Cpf)
		nEnd  := AllTrim(oParseJson:Endereco)
		
		// retorna dados que foi feito o post 
	cJsonRet    := '{"Post Realizado com sucesso " ' + nCpf + ' " " ' + nEnd + ' }'
	Self:SetResponse(cJsonRet)

		//exemplo para atualizar dados ALTERA ENDEREÇO
			//DbSelectArea('PDL')
		//	PDL->(DbSetOrder(3)) 
		//	If PDL->(DbSEek(xFilial('PDL')+nCpf))
		//		RecLock('PDL', .F.)
		//			PDL->PDL_END := nEnd 
		//		PDL->(MsUnLock())
		//		cJsonRet    := '{"Cadastro do aluno atualizado com sucesso " ' + PDL->PDL_NOME + '}'
		//		Self:SetResponse(cJsonRet)
	//		ELSE
		//     	cJsonRet    := '{"NÃ£o achou o cadastro do aluno com o cpf " ' + nCpf + '}'
		//		Self:SetResponse(cJsonRet)
		//	Endif

		ELSE
				Conout(Dtoc(Date()) + " " + Time() + " - Erro na importação verifique " )
				SetRestFault(500,'Erro na importação verifique ')
				lRet    := .F.
		EndIf
	 
Return lPost
