#INCLUDE "tctta030.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { { 	"PD2"/* Tabela */, STR0001 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */, { } /* Relation */,; //"Cadastro de Professores"
"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 50 /* Area do Componente */, {} /* Unique Line */ },;
	{ 	"PDN", STR0002,  .T., .F., { { "PDN_FILIAL", "xFilial('PD2')" }, { "PDN_PROF", "PD2_PROF" } }, "", "PDN_ITEM", 50, {} } } //"Capacitação"
STATIC cFunName	:= "TCTTA030"
STATIC cFilter	:= ""
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do cadastro de Professores

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA030

	U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem do Menu do Cadastro de Professores

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE STR0004  ACTION 'PesqBrw'            OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE STR0005 ACTION 'VIEWDEF.TCTTXMVC'   OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0006    ACTION 'VIEWDEF.TCTTXMVC'   OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE STR0007    ACTION 'VIEWDEF.TCTTXMVC'   OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE STR0008    ACTION 'VIEWDEF.TCTTXMVC'   OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE STR0009     ACTION 'U_TCTTA050()' 	  OPERATION 2 ACCESS 0 //"Turmas"

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
@return oModel
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
@since 06/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ViewDef()

Return &("StaticCall(TCTTXMVC,VIEWDEF)")

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Ativação do modelo do cadastro de professores

@author Wagner Mobile Costa
@version P12
@since 07/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function Activate(oModel)

	Local nOperation := 0
	Local aError	 := {}, cError := "", nError := 0
	Local aArea		 := GetArea()

	If oModel == Nil	//-- É realizada chamada com modelo nulo para verificar se a função existe
		Return .F.
	EndIf

	nOperation := oModel:GetOperation()

	If nOperation == MODEL_OPERATION_DELETE
	//-- 1. Uso em Turmas
		BeginSQL Alias "PD3QRY"
			SELECT MIN(PD3_TURMA) AS PD3_TURMA
			FROM %table:PD3%
			WHERE %notDel% AND PD3_FILIAL BETWEEN %Exp:Repl(" ", Len(xFilial("PD3")))% AND %Exp:Repl("Z", Len(xFilial("PD3")))%
			AND PD3_PROF = %Exp:PD2->PD2_PROF%
		EndSql

		If ! Empty(PD3QRY->PD3_TURMA)
			AAdd(aError, STR0003 + PD3QRY->PD3_TURMA + "]") //"PD3-Professor em uso na turma ["
		EndIf
		PD3QRY->(DbCloseArea())

		If Len(aError) > 0
			For nError := 1 To Len(aError)
				If ! Empty(cError)
					cError += Chr(13) + Chr(10)
				EndIf
				cError += aError[nError]
			Next
			Help(,, "EMUSO",, cError, Len(aError), 0)
		EndIf
	
	EndIf

	RestArea(aArea)
	// Integração COM VLabs
	//cRetVLab := u_WsProf(nOperation)
Return Len(aError) == 0

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Pós Validação (TudoOk) do modelo do cadastro de Professor
@author Wagner Mobile Costa
@version P12
@since 28/08/2016
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function PosValid(oModel)
 
 

	Local lRet := .T.
	Local nOperation := 0
	Local cRetVLab :=''


	If oModel == Nil //-- É realizada chamada com modelo nulo para verIficar se a função existe
		Return .T.
	EndIf
	// Integração COM VLabs
	If oModel:GetOperation() == MODEL_OPERATION_DELETE
		cRetVLab := u_WsProf(MODEL_OPERATION_DELETE)
		Return .T.
	EndIf
	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		cRetVLab := u_WsProf(MODEL_OPERATION_INSERT)
	ElseIf oModel:GetOperation() == MODEL_OPERATION_UPDATE
		cRetVLab := u_WsProf(MODEL_OPERATION_UPDATE)
	EndIf
Return lRet
//--------------------------------------------------------------------------------

/*/{Protheus.doc} WsProf
Função para consumir WsProf
@type function
@author queizy.nascimento
@since 21/03/2017
@version 1.0
@param nOperation, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*/
User Function WsProf(nOperation)

	Local lOk, cResp, aElem, nPos, aInput := {}, aComplex := {}, nA, nPos, cMsg,xRet
	Local cRet			:= 'OK'
	Local cURL			:= getMv('TI_URLVLAB',,'https://apis_dev.totvstreinamentos.com/webservices/CTTWService.asmx?WSDL')
	Local cMetodo		:= ''
	Local cResult		:= ''
	Local oWsdl 		:= tWSDLManager():New()
	Local cConst := "AddInstructor#1.Instructor#1"
	Local cRemove:= "RemoveInstructor#1.Instructor#1"
	Local oModel		:= FwModelActivate()
	Local oMdlPD2 		:= oModel:getModel('PD2')

	default nOperation	:= 0	// 3=INCLUSAO;4=ALTERACAO;5=EXCLUCAO;

	// Caso parametro esteja em branco não tenta integrar
	If Empty(cURL)
		Return ""
	EndIf

	oWsdl:lSSLInsecure 	:= .T.	// Define se fará a conexão SSL com o servidor de forma anônima, ou seja, sem verIficação de certIficados ou chaves.

	If nOperation == 5
		cMetodo := 'DeleteCTTInstructor'
		cResult := 'RemoveInstructor'
	ElseIf nOperation == 3 .OR. nOperation == 4
		cMetodo := 'CreateCTTInstructor'
		cResult := 'AddInstructor'
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

	aComplex := oWsdl:NextComplex()
	while ValType( aComplex ) == "A"
		cRet := oWsdl:SetComplexOccurs( aComplex[1], 1 )
		if cRet == .F.
			// conout( "Erro ao definir elemento " + aComplex[2] + ", ID " + cValToChar( aComplex[1] ) + ", com 1 ocorrência" )
	      //return
			lok := .F.
		endif
		aComplex := oWsdl:NextComplex()
	End

	aSimple := oWsdl:SimpleInput()//

	If nOperation == 5
	
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cRemove } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PD2->PD2_PROF )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DELETEDON" .AND. aVet[5] == cRemove } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], FWTimeStamp(3,date()) )
  
  	   
	ElseIf nOperation == 3
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], oMdlPD2:getValue('PD2_PROF') )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "FIRSTNAME" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(oMdlPD2:getValue('PD2_NOME'), 1,AT(' ',oMdlPD2:getValue('PD2_NOME') )) )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "LASTNAME" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(oMdlPD2:getValue('PD2_NOME'),AT(' ',oMdlPD2:getValue('PD2_NOME') )) )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "EMAIL" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], oMdlPD2:getValue('PD2_EMAIL') )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PHONENUMBER" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], oMdlPD2:getValue('PD2_TEL') )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTNUMBER" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], oMdlPD2:getValue('PD2_CPF') )
	
		
	ElseIf nOperation == 4
	
		
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], oMdlPD2:getValue('PD2_PROF') )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "FIRSTNAME" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(oMdlPD2:getValue('PD2_NOME'), 1,AT(' ',oMdlPD2:getValue('PD2_NOME') )) )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "LASTNAME" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(oMdlPD2:getValue('PD2_NOME'),AT(' ',oMdlPD2:getValue('PD2_NOME') )) )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "EMAIL" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], oMdlPD2:getValue('PD2_EMAIL') )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PHONENUMBER" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], oMdlPD2:getValue('PD2_TEL') )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTNUMBER" .AND. aVet[5] == cConst } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], oMdlPD2:getValue('PD2_CPF') )
		
	EndIf

//Pega a mensagem que sera enviada para Web Service
	cMsg := oWsdl:GetSoapMsg()

// Faz a requisição ao WebService 
	lOk := oWsdl:SendSoapMsg(cMsg)
	If !lOk
		cRet := oWsdl:cError
		Return cRet
	EndIf

	//CRET:=oWSDL:GetSoapResponse()
	//ALERT(CRET)
Return
