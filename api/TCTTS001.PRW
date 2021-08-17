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

//------------------------------------
// Definição da estrutura do webservice ..
// @type class
//------------------------------------
WSRESTFUL CTT DESCRIPTION "Serviço REST para retornar informacoes do Ctt"


    WSDATA startIndex AS INTEGER
    WSDATA cpf         AS STRING	OPTIONAL
	WSDATA turma       AS STRING	OPTIONAL // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL
	WSDATA periodo       AS STRING	OPTIONAL // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL	
	WSDATA id	        AS STRING	OPTIONAL
    WSDATA fields     AS STRING	OPTIONAL
   

    WSMETHOD GET Login ;
    DESCRIPTION 'Valida login por cpf CTT' ;
    WSSYNTAX '/api/login/{cpf}/?{,cpf}' ;
    PATH '/api/login/{cpf}' 

	WSMETHOD GET montagem ;
    DESCRIPTION 'Montagem lista de pesquisa de Satisfação' ;
    WSSYNTAX '/api/montagem/?{turma, periodo}' ; // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL
    PATH '/api/montagem'	


WSMETHOD POST grava ;
    DESCRIPTION 'Grava Dados pesquisa de Satisfação' ;
    WSSYNTAX '/api/grava/{body}' ;
    PATH '/api/grava/{body}' 




END WSRESTFUL



//------------------------------------
// GET - "Valida Login por Cpf
//------------------------------------
WSMETHOD GET Login  PATHPARAM cpf WSRECEIVE cpf WSSERVICE CTT
Local i
Local _cEmp_    := GetPvProfString(GetEnvServer(),"EMP_CTT","00",GetAdv97())
Local _cFil_    := GetPvProfString(GetEnvServer(),"FIL_CTT","00001000100",GetAdv97())
Local cRet		:= ""
Local nX		  := 0
Local cJSon		:= "{"
Private aDadosC	:= {}
Private aDadosI	:= {}

RpcClearEnv()
RpcSetEnv( _cEmp_,_cFil_,,, "FIN", "pesquisa", { "PDL", "PD7", "SA1" },,,,)
cCpf := Alltrim(::aURLParms[3])
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
	            cRet := "Nao existe aluno com cpf informado [" + cCPF + "]"
				cJSon += '"resultado":"0"'
				cJSon += ',"Motivo":' 	  + '"'   + Alltrim(cRet) 	+ '"'
 
ELSEIF Empty(PDLQRY->PD7_TURMA)
				cRet := "Aluno do CPF [" + cCPF + "] sem alocacao"
 				cJSon += '"resultado":"0"'
				cJSon += ',"Motivo":' 	  + '"'   + Alltrim(cRet) 	+ '"'
ELSEIF ! Empty(PDLQRY->PD7_TURMA)
	
		cJSon += '"resultado":"1"'
		cJSon += ',"PDL_CPF":' 	  + '"'   + Alltrim(PDLQRY->PDL_CPF) 	+ '"'
		cJSon += ',"PDL_NOME":' 	  + '"'   + Alltrim(PDLQRY->PDL_NOME) 	+ '"'
		cJSon += ',"PDL_EMAIL":' 	  + '"'   + Alltrim(PDLQRY->PDL_EMAIL) 	+ '"'
		cJSon += ',"A1_CGC":' 	  + '"'   + Alltrim(PDLQRY->A1_CGC) 	+ '"'
		cJSon += ',"A1_NOME":' 	  + '"'   + Alltrim(PDLQRY->A1_NOME) 	+ '"'
		cJSon += ',"PDL_ALUNO":' 	  + '"'   + Alltrim(PDL_ALUNO) 	+ '"'
		cJSon += ',"cEmp":' 	  + '"'   + Alltrim(_cEmp_) 	+ '"'
		cJSon += ',"cFil":' 	  + '"'   + Alltrim(_cFil_) 	+ '"'
		cJSon += "}"

	
	WHILE PDLQRY->(!EOF())
			cJSon += ',"PD7_TURMA":' 	  + '"'   + Alltrim(PDLQRY->PD7_TURMA) 	+ '"'
			cJSon += ',"PD3_NOME":' 	  + '"'   + Alltrim(PDLQRY->PD3_NOME) 	+ '"'
            cJSon += ',"PD2_NOME":' 	  + '"'   + Alltrim(PDLQRY->PD2_NOME) 	+ '"'
			cJSon += ',"PD3_SALA":' 	  + '"'   + Alltrim(PDLQRY->PD3_SALA) 	+ '"'
			cJSon += ',"PDO_NOME":' 	  + '"'   + Alltrim(PDLQRY->PDO_NOME) 	+ '"'
			cJSon += ',"PDF_DTINI":' 	  + '"'   + Alltrim(PDLQRY->PDF_DTINI) 	+ '"'
			cJSon += ',"PDF_DTFIM":' 	  + '"'   + Alltrim(PDLQRY->PDF_DTFIM) 	+ '"'
      		//PDLQRY->PD7_TURMA + "/" + PDLQRY->PDF_PERIO + "/" + PDLQRY->PD7_FILIA
			cJSon += ',"PD7_TURMA":' 	  + '"'   + Alltrim(PDLQRY->PD7_TURMA) 	+ '"'
			cJSon += "}"
	  PDLQRY->(DBSKIP())

	ENDDO
	

ENDIF
PDLQRY->(DbCloseArea()) 

Self:SetResponse(cJSon)


Return .T.

//------------------------------------
// GET - "Montagem das questões para pagina da pesquisa de satisfação
//------------------------------------
WSMETHOD GET montagem  WSRECEIVE turma, periodo WSSERVICE CTT
Local lRet			       := .T.
Local i
//local self:startIndex :=''
//local self:count :=''
Local cDados               :=''
Local cJSon	               := "{"
Default self:turma         := ''
Default self:periodo       := ''

// define o tipo de retorno do método
::SetContentType("application/json")
//verificar se existe parametro no ctt\turma / periodo
//If Len(self:turma) > 0 .or. Len(self:periodo) > 0 
	
	cTurma := Alltrim(self:turma)
	cPeriod := Alltrim(self:periodo)
// FAZ TESTE FAKE PARA MONTAGEM DAS PERGUNTAS A SEREM CONSUMIDAS
	
		// ::count pode colocar quantidade de registro para teste
	//	DEFAULT self:startIndex := 1, self:count := 1
	   	
	  //	::SetResponse('[')
	  //	For i := ::startIndex To ::count + 1
	  //		If i > ::startIndex
	   //   		::SetResponse(',')
	  //  	EndIf
	    	//AQUI PODEMOS COLOCAR O JSON DAS PERGUNTAS PARA RETORNO
			
	//DADOS PARA CABE		
	cDados := '{"PD5_PESQ":"001","PD5_ITEM":"11","PD5_FINALI":"Finalidade","PD5_DEPTO":"Departamento","PD5_ASSUNTO":"Assunto","PD5_PERGUN":"Pontualidade - inicio e termino de aula saida e retorno para intervalo?","PD7_TURMA":"00003","PDF_DTINI":"21/06/2021","PDF_DTFIM":"21/07/2021","PD3_SALA":"SALA"}'
   //PODE SER ADICIONADO MAIS 
   // cDados += '"Resultado":"1","PDL_CPF":"0000000000001","cEmp":"00.0000.254/00001-35","cFil":"TOTVS SA","PDL_ALUNO":"Aluno Silva Santos","PDL_EMAIL":"naotem@naotem.com.br","PD7_TURMA":"00003","PD7_PESQOK":"0","PD2_NOME":"CURSO","PD2_NOME":"PROFESSOR","PDF_DTINI":"21/06/2021","PDF_DTFIM":"21/07/2021","PD7_TURMA":"TURMA","PD3_SALA":"SALA" }'
    
		Self:SetResponse(cDados)
	
//	Next
	  		  	::SetResponse(']')
//	Else
	//	 cJSon += '"error":"Falta Parametros turma ou periodo"}'
		//Self:SetResponse(cJSon)
//Endif	

Return lRet


//------------------------------------
// post - "Grava Dados pesquisa de Satisfação
//------------------------------------
WSMETHOD POST grava WSSERVICE CTT
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
	 
Return lRet
