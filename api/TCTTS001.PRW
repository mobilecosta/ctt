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
	WSDATA CPF As String //String que vamos receber via URL
 
	WSMETHOD GET Login DESCRIPTION "Valida Login por Cpf" WSSYNTAX "/CPF || /CPF/{CPF}" 	//Disponibilizamos um método do tipo GET
	WSMETHOD POST DESCRIPTION "Envia Post da Pesquisa " WSSYNTAX "/envia"
END WSRESTFUL


//------------------------------------
// GET - "Valida Login por Cpf
//------------------------------------
WSMETHOD GET Login WSRECEIVE CPF WSSERVICE CTT
Local i
Local cRet		:= ""
Local nX		  := 0
Local cJSon		:= "{"
Private aDadosC	:= {}
Private aDadosI	:= {}

// define o tipo de retorno do método
::SetContentType("application/json")

cCpf := Alltrim(::aURLParms[2])
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
	cJson := 'code: "Não existe aluno com CPF informado [" + cCPF + "]"'
 
ELSEIF Empty(PDLQRY->PD7_TURMA)
	cJson := 'code: "Aluno do CPF [" + cCPF + "] sem alocação"'
 
ELSEIF ! Empty(PDLQRY->PD7_TURMA)

	cJSon += '"resultado": "1"'
	cJSon += ',"PDL_CPF":' 	  + '"'   + Alltrim(aDadosC[1][1]) 	+ '"'
	cJSon += ',"PDL_NOME":' 	  + '"'   + Alltrim(aDadosC[1][2]) 	+ '"'
	cJSon += ',"PDL_EMAIL":' 	  + '"'   + Alltrim(aDadosC[1][3]) 	+ '"'
	cJSon += ',"A1_CGC":' 	  + '"'   + Alltrim(aDadosC[1][4]) 	+ '"'
	cJSon += ',"A1_NOME":' 	  + '"'   + Alltrim(aDadosC[1][5]) 	+ '"'
	cJSon += ',"PDL_ALUNO":' 	  + '"'   + Alltrim(aDadosC[1][8]) 	+ ''
	cJSon += "}"

	AADD(aDadosC,{ 	TRANS(PDLQRY->PDL_CPF,"@R 999.999.999-99"), PDLQRY->PDL_NOME, PDLQRY->PDL_EMAIL,;
					transform(PDLQRY->A1_CGC, If(Len(PDLQRY->A1_CGC) = 11, "@R 999.999.999-99", "@R 99.999.999/9999-99")), PDLQRY->A1_NOME, DATE(), TIME(),;
					PDLQRY->PDL_ALUNO, _cEmp_, _cFil_})
					
	WHILE PDLQRY->(!EOF())
		AADD(aDadosI,{	PDLQRY->PD7_TURMA, PDLQRY->PD3_NOME+If(PDLQRY->PD7_PESQOK == 1, '<B> [ Pesquisa Respondida ]</B>', ""),;
						PDLQRY->PD2_NOME, PDLQRY->PD3_SALA, PDLQRY->PDO_NOME, PDLQRY->PDF_DTINI, PDLQRY->PDF_DTFIM,;
						PDLQRY->PD7_TURMA + "/" + PDLQRY->PDF_PERIO + "/" + PDLQRY->PD7_FILIAL })
		
		PDLQRY->(DBSKIP())
	ENDDO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ANALISE PARA SABER SE DEVE VOLTAR A PAGINA PRINCIPAL OU PROSSEGUGIR PARA A ESCOLHA DA AULA PARA RESPONDER A PESQUISA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//verifica se achou cadastro do aluno  " aDadosC" se não achar traz json resultado =0
	IF LEN(aDadosC)>0

	For nX := 1 To Len(aDadosC)
		
		
		Next nX

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

ENDIF
PDLQRY->(DbCloseArea()) 

Self:SetResponse(cJSon)

Return .T.

//------------------------------------
// GET - "Retorna Pesquisa a serem Pesquisadas
//------------------------------------


//------------------------------------
// GET - "Envia Post da Pesquisa
//------------------------------------
WSMETHOD POST WSSERVICE CTT

	//Definindo o conteÃºdo como JSON, e pegando o content e dando um parse para ver se a estrutura estÃ¡ ok
    Self:SetContentType("application/json")
 
Return .t.
