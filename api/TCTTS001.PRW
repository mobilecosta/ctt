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

//-- Aluno com alocação
IF Empty(PDLQRY->PDL_ALUNO)
	cRet := "Não existe aluno com CPF informado [" + cCPF + "]"
 
ELSEIF Empty(PDLQRY->PD7_TURMA)
	cRet := "Aluno do CPF [" + cCPF + "] sem alocação"
 
ELSEIF ! Empty(PDLQRY->PD7_TURMA)
	AADD(aDadosC,{ 	TRANS(PDLQRY->PDL_CPF,"@R 999.999.999-99"), PDLQRY->PDL_NOME, PDLQRY->PDL_EMAIL,;
					transform(PDLQRY->A1_CGC, If(Len(PDLQRY->A1_CGC) = 11, "@R 999.999.999-99", "@R 99.999.999/9999-99")), PDLQRY->A1_NOME, DATE(), TIME(),;
					PDLQRY->PDL_ALUNO, _cEmp_, _cFil_})
					
	//httpsession->cEMPRESA := _cEmp_+'|'+_cFil_
	
	WHILE PDLQRY->(!EOF())
		AADD(aDadosI,{	PDLQRY->PD7_TURMA, PDLQRY->PD3_NOME+If(PDLQRY->PD7_PESQOK == 1, '<B> [ Pesquisa Respondida ]</B>', ""),;
						PDLQRY->PD2_NOME, PDLQRY->PD3_SALA, PDLQRY->PDO_NOME, PDLQRY->PDF_DTINI, PDLQRY->PDF_DTFIM,;
						PDLQRY->PD7_TURMA + "/" + PDLQRY->PDF_PERIO + "/" + PDLQRY->PD7_FILIAL })
		
		PDLQRY->(DBSKIP())
	ENDDO

ENDIF
PDLQRY->(DbCloseArea()) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ANALISE PARA SABER SE DEVE VOLTAR A PAGINA PRINCIPAL OU PROSSEGUGIR PARA A ESCOLHA DA AULA PARA RESPONDER A PESQUISA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// define o tipo de retorno do método
::SetContentType("application/json")

//verifica se achou cadastro do aluno  " aDadosC" se não achar traz json resultado =0
IF LEN(aDadosC)>0

For nX := 1 To Len(aDadosC)
	
	  	cJSon += '"resultado":"1"'
			cJSon += ',"PDL_CPF":' 	  + '"'   + Alltrim(aDadosC[1][1]) 	+ '"'
			cJSon += ',"PDL_NOME":' 	  + '"'   + Alltrim(aDadosC[1][2]) 	+ '"'
      cJSon += ',"PDL_EMAIL":' 	  + '"'   + Alltrim(aDadosC[1][3]) 	+ '"'
			cJSon += ',"A1_CGC":' 	  + '"'   + Alltrim(aDadosC[1][4]) 	+ '"'
      cJSon += ',"A1_NOME":' 	  + '"'   + Alltrim(aDadosC[1][5]) 	+ '"'
      cJSon += ',"PDL_ALUNO":' 	  + '"'   + Alltrim(aDadosC[1][8]) 	+ '"'
      cJSon += ',"cEmp":' 	  + '"'   + Alltrim(aDadosC[1][9]) 	+ '"'
      cJSon += ',"cFil":' 	  + '"'   + Alltrim(aDadosC[1][10]) 	+ '"'
      cJSon += "}"
	
	Next nX

    //Self:SetResponse(cJSon)

ELSE
	    cJSon += '"resultado":"0"'
			cJSon += ',"Motivo":' 	  + '"'   + Alltrim(cRet) 	+ '"'

				Self:SetResponse(cJSon)
 
ENDIF



//verifica se achou pesquisa para o aluno  " aDadosC" se não achar traz json resultado =0
IF LEN(aDadosI)>0

For nX := 1 To Len(aDadosI)
	
	  	cJSon += ',"PD7_TURMA":' 	  + '"'   + Alltrim(aDadosI[1][1]) 	+ '"'
			cJSon += ',"PD3_NOME":' 	  + '"'   + Alltrim(aDadosI[1][2]) 	+ '"'
      cJSon += ',"PD2_NOME":' 	  + '"'   + Alltrim(aDadosI[1][3]) 	+ '"'
			cJSon += ',"PD3_SALA":' 	  + '"'   + Alltrim(aDadosI[1][4]) 	+ '"'
      cJSon += ',"PDO_NOME":' 	  + '"'   + Alltrim(aDadosI[1][5]) 	+ '"'
      cJSon += ',"PDF_DTINI":' 	  + '"'   + Alltrim(aDadosI[1][6]) 	+ '"'
      cJSon += ',"PDF_DTFIM":' 	  + '"'   + Alltrim(aDadosI[1][7]) 	+ '"'
      
      //PDLQRY->PD7_TURMA + "/" + PDLQRY->PDF_PERIO + "/" + PDLQRY->PD7_FILIA
      cJSon += ',"PD7_TURMA":' 	  + '"'   + Alltrim(aDadosI[1][8]) 	+ '"'
      cJSon += "}"
	
	Next nX

    Self:SetResponse(cJSon)

ELSE
	    cJSon += '"resultado":"0"'
			cJSon += ',"Motivo":' 	  + '"'   + Alltrim(cRet) 	+ '"'

				Self:SetResponse(cJSon)
 
ENDIF


//verificar se existe parametro no ctt\cpf
//If Len(::aURLParms) > 0
	//cCPF := Alltrim(::aURLParms[2])
// FAZ PESQUISA VIA CQRY1
//If Select("TMPFS2M") > 0
		//	TMPFS2M->(dbCloseArea())
//Endif                                     
		//cQry1 := "Select PDL.PDL_CPF,PDL.PDL_NOME,PDL.PDL_EMAIL "
	//	cQry1 += "From " + RetSqlName("PDL") + " PDL (NoLock) "
	//	cQry1 += "Where PDL.D_E_L_E_T_<>'*' "
	//	cQry1 += "And PDL_FILIAL = '" + xFilial("PDL") 	+ "' "
	//	cQry1 += "And PDL.PDL_CPF = '" + ::aURLParms[2]	+ "' "
	//	cQry1 := ChangeQuery(cQry1)
	//	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TMPFS2M",.T.,.F.)
	
	//	dbSelectArea("TMPFS2M")
	//	dbGoTop()
//		if (TMPFS2M->(Eof()))
//					cJSon += '"resultado":"0"}'
	//		TMPFS2M->(dbCloseArea())
	//	Else
	//		cJSon += '"resultado":"1"'
		//	cJSon += ',"cpf":' 	  + '"'   + Alltrim(TMPFS2M->PDL_CPF) 	+ '"'
	//		cJSon += ',"Nome":' + '"' + Alltrim(TMPFS2M->PDL_NOME)  + '"'
  //    cJSon += ',"E-mail":' + '"' + Alltrim(TMPFS2M->PDL_EMAIL)  + '"'
 	//		cJSon += "}"
	//		TMPFS2M->(dbCloseArea())		
	//	Endif
//Else
		    //    cJSon += '"resultado":"0"}'
			//	Self:SetResponse(cJSon)
	
//EndIf


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

