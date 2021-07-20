#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FSI502   º Autor ³ Jose Mendes        º Data ³  16/07/2021   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ WebService Rest ()					  º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TCRMS057()	
Return

//------------------------------------
// Definição da estrutura do webservice ..
// @type class
//------------------------------------
WSRESTFUL CTT DESCRIPTION "Serviço REST para retornar informacoes do cadastro de alunos por Cpf"

WSDATA CPF As String //String que vamos receber via URL
 
WSMETHOD GET DESCRIPTION "Retorna os dados dos alunos na URL" WSSYNTAX "/CPF || /CPF/{CPF}" 	//Disponibilizamos um método do tipo GET
WSMETHOD POST DESCRIPTION "envia dados post" WSSYNTAX "/atualiza"
END WSRESTFUL
//------------------------------------
// Processa as informações e retorna o json
// @type class
// @param oSelf, object, Objeto contendo dados da requisição efetuada pelo cliente, tais como:
//    - Parâmetros querystring (parâmetros informado via URL)
//    - Objeto JSON caso o requisição seja efetuada via Request Post
//    - Header da requisição
//// @type Method
//------------------------------------
WSMETHOD GET WSRECEIVE CPF WSSERVICE CTT

Local cJSon		:= "{"
// define o tipo de retorno do método
::SetContentType("application/json")

//verificar se existe parametro no ctt\cpf
If Len(::aURLParms) > 0
	cCPF := Alltrim(::aURLParms[1])

If Select("TMPFS2M") > 0
			TMPFS2M->(dbCloseArea())
Endif                                     
	
		cQry1 := "Select PDL.PDL_CPF,PDL.PDL_NOME "
		cQry1 += "From " + RetSqlName("PDL") + " PDL (NoLock) "
		cQry1 += "Where PDL.D_E_L_E_T_<>'*' "
		cQry1 += "And PDL_FILIAL = '" + xFilial("PDL") 	+ "' "
		cQry1 += "And PDL.PDL_CPF = '" + cCPF	+ "' "
			 
		cQry1 := ChangeQuery(cQry1)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TMPFS2M",.T.,.F.)
	
		dbSelectArea("TMPFS2M")
		dbGoTop()
		
		if (TMPFS2M->(Eof()))
			// NÃO ACHOU CNPJ
			cJSon += '"resultado":"0"}'
			TMPFS2M->(dbCloseArea())
		Else
			cJSon += '"resultado":"1"'
			//cJSon += '"cpf":' 	  + '"'   + Alltrim(TMPFS2M->PDL_CPF) 	+ '"'
			//cJSon += '"":' + '"' + Alltrim(TMPFS2M->PDL_NOME)  + '"'
			cJSon += "}"
			TMPFS2M->(dbCloseArea())		
		Endif
	
::SetResponse(cJSon)

Else
		        cJSon += '"resultado":"0"}'
				Self:SetResponse(cJSon)
	
EndIf

Return .T.

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
		
		//exemplo para atualizar dados ALTERA ENDEREÇO
			DbSelectArea('PDL')
			PDL->(DbSetOrder(3)) 
			If PDL->(DbSEek(xFilial('PDL')+nCpf))
				RecLock('PDL', .F.)
					PDL->PDL_END := nEnd 
				PDL->(MsUnLock())
				cJsonRet    := '{"Cadastro do aluno atualizado com sucesso " ' + PDL->PDL_NOME + '}'
				Self:SetResponse(cJsonRet)
			ELSE
		     	cJsonRet    := '{"NÃ£o achou o cadastro do aluno com o cpf " ' + nCpf + '}'
				Self:SetResponse(cJsonRet)
			Endif

		ELSE
				Conout(Dtoc(Date()) + " " + Time() + " - Erro na importação verifique " )
				SetRestFault(500,'Erro na importação verifique ')
				lRet    := .F.
		EndIf
	 
Return lPost
