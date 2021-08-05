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

WSRESTFUL CTT DESCRIPTION 'API de integração do CTT'

	WSDATA cpf         AS STRING	OPTIONAL
	WSDATA turma       AS STRING	OPTIONAL // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL
	WSDATA periodo       AS STRING	OPTIONAL // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL	
	WSDATA id	        AS STRING	OPTIONAL
    WSDATA fields     AS STRING	OPTIONAL
    WSDATA order			AS STRING	OPTIONAL
	WSDATA page				AS INTEGER	OPTIONAL
	WSDATA pageSize   AS INTEGER	OPTIONAL
	WSDATA filter     AS STRING	OPTIONAL

  WSMETHOD GET Login ;
    DESCRIPTION 'Valida login por cpf CTT' ;
    WSSYNTAX '/api/login/{cpf}/?{fields, order, page, pageSize, filter,periodo,turma}' ;
    PATH '/api/login/{cpf}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

	WSMETHOD GET montagem ;
    DESCRIPTION 'Montagem lista de pesquisa de Satisfação' ;
    WSSYNTAX '/api/montagem/?{turma, periodo}' ; // chave pesquisa PD7_TURMA + PDF_PERIO + PD7_FILIAL
    PATH '/api/montagem'	;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD POST grava ;
    DESCRIPTION 'Grava Dados pesquisa de Satisfação' ;
    WSSYNTAX '/api/grava/{body}' ;
    PATH '/api/grava/{body}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON



ENDWSRESTFUL

//------------------------------------
// GET - "Valida Login por Cpf
//------------------------------------
WSMETHOD GET Login  PATHPARAM cpf WSRECEIVE fields, order, page, pageSize, filter,turma, periodo WSSERVICE CTT

Local lRet			  := .T.
Local oResponse   
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0
local cFilcam :=''

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Default self:fields   := ''
Default self:id       := ''
Default self:order    := ''

Begin Sequence

   // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .F. ) 
  oDataBase:SetFields( self:fields )  

// Mapa de campos retornaveis conforme GET  self:fields o que for colocado no params no get será retornado os campos
aFields := StrToKArr2(self:fields, ',')
  
 for nx := 1 to Len(aFields)
      oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'PDL' ) + " PDL "
  cQuery += " WHERE #QueryWhere#"
  cWhere := " PDL_FILIAL = '"+ FWxFilial('PDL') +"' AND PDL.D_E_L_E_T_ = ' ' AND PDL_CPF = '" + self:cpf + "' "
  
  oDataBase:SetQuery( cQuery )
  oDataBase:SetWhere( cWhere )
  oDataBase:SetOrder( self:order )


  //Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
  If oDataBase:Execute()
    // Gera o arquivo Json com o retorno da Query
    oDataBase:FillGetResponse()
  EndIf

  If oDataBase:lOk

    If Type('oResponse') == 'O'
      FreeObj(oResponse)
    EndIf

    oResponse := JsonObject():New()

    //Campos de exceções
    oResponse:fromJson(oDataBase:getJSONResponse())
    //Campo de log de alteração
   EndIf

End Sequence

ErrorBlock(oException)


  // Verifica execução da query
  If oDataBase:lOk
     self:SetResponse(oResponse:toJson())
  EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil
aFields := nil

Return lRet

//------------------------------------
// GET - "Montagem das questões para pagina da pesquisa de satisfação
//------------------------------------
WSMETHOD GET montagem  WSRECEIVE turma, periodo WSSERVICE CTT

Local lRet			       := .T.
Local i
Local cDados               :=''
Local cJSon	               := "{"
Default self:turma         := ''
Default self:periodo       := ''


// define o tipo de retorno do método
::SetContentType("application/json")

//verificar se existe parametro no ctt\turma / periodo
If Len(self:turma) > 0 .or. Len(self:periodo) > 0 
	
	cTurma := Alltrim(self:turma)
	cPeriod := Alltrim(self:periodo)

// FAZ TESTE FAKE PARA MONTAGEM DAS PERGUNTAS A SEREM CONSUMIDAS
	
		// ::count pode colocar quantidade de registro para teste
		DEFAULT self:startIndex := 1, self:count := 1
	   	
	  	::SetResponse('[')
	  	For i := ::startIndex To ::count + 1
	  		If i > ::startIndex
	      		::SetResponse(',')
	    	EndIf
	    	//AQUI PODEMOS COLOCAR O JSON DAS PERGUNTAS PARA RETORNO
			
	//DADOS PARA CABE		
	cDados := '{"PD5_PESQ":"001","PD5_ITEM":"11","PD5_FINALI":"Finalidade","PD5_DEPTO":"Departamento","PD5_ASSUNTO":"Assunto","PD5_PERGUN":"Pontualidade - inicio e termino de aula saida e retorno para intervalo?","PD7_TURMA":"00003","PDF_DTINI":"21/06/2021","PDF_DTFIM":"21/07/2021","PD3_SALA":"SALA"}'
   //PODE SER ADICIONADO MAIS 
   // cDados += '"Resultado":"1","PDL_CPF":"0000000000001","cEmp":"00.0000.254/00001-35","cFil":"TOTVS SA","PDL_ALUNO":"Aluno Silva Santos","PDL_EMAIL":"naotem@naotem.com.br","PD7_TURMA":"00003","PD7_PESQOK":"0","PD2_NOME":"CURSO","PD2_NOME":"PROFESSOR","PDF_DTINI":"21/06/2021","PDF_DTFIM":"21/07/2021","PD7_TURMA":"TURMA","PD3_SALA":"SALA" }'
    
	::SetResponse(cDados)
	
	Next
	  		  	::SetResponse(']')


	Else
		 cJSon += '"error":"Falta Parametros turma ou periodo"}'
		Self:SetResponse(cJSon)
Endif	


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
