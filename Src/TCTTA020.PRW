#INCLUDE "TCTTA020.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

STATIC aForms 	:= { { 	'PDL'/* Tabela */, STR0002 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */, { } /* Relation */,; //"Cadastro de Alunos"
"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 0 /* Area do Componente */, {} /* Unique Line */ } }
STATIC cFunName	:= "TCTTA020"
STATIC cFilter	:= ""
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do cadastro de Alunos

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA020

	U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Menu do cadastro de Alunos

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE STR0006  ACTION 'PesqBrw'             	OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE STR0007 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0008    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE STR0009    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE STR0010    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 5 ACCESS 0 //"Excluir"

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
Ativação do modelo do cadastro de alunos

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
	//-- 1. Uso em Alocações
		BeginSQL Alias "PD7QRY"
			SELECT MIN(PD7_TURMA) AS PD7_TURMA
			FROM %table:PD7%
			WHERE %notDel% AND PD7_FILIAL BETWEEN %Exp:Repl(" ", Len(xFilial("PD7")))% AND %Exp:Repl("Z", Len(xFilial("PD7")))%
			AND PD7_ALUNO = %Exp:PDL->PDL_ALUNO%
		EndSql

		If ! Empty(PD7QRY->PD7_TURMA)
			AAdd(aError, STR0003 + PD7QRY->PD7_TURMA + STR0004) //"PD7-Aluno em uso na alocação da turma ["###"]"
		EndIf
		PD7QRY->(DbCloseArea())

	//-- 2. Uso em Resposta de pesquisa de satisfação
		BeginSQL Alias "PD4QRY"
			SELECT MIN(PD4_TURMA) AS PD4_TURMA
			FROM %table:PD4%
			WHERE %notDel% AND PD4_FILIAL BETWEEN %Exp:Repl(" ", Len(xFilial("PD4")))% AND %Exp:Repl("Z", Len(xFilial("PD4")))%
			AND PD4_ALUNO = %Exp:PDL->PDL_ALUNO%
		EndSql

		If ! Empty(PD4QRY->PD4_TURMA)
			AAdd(aError, STR0005 + PD4QRY->PD4_TURMA + STR0004) //"PD4-Aluno em uso na pesquisa de satisfação da turma ["###"]"
		EndIf
		PD4QRY->(DbCloseArea())

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

Return Len(aError) == 0


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Pós Validação (TudoOk) do modelo do cadastro de alunos

@author Wagner Mobile Costa
@version P12
@since 28/08/2016
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function PosValid(oModel)
 
	Local cRetVLab :=''
	
	If oModel == Nil //-- É realizada chamada com modelo nulo para verIficar se a função existe
		Return .T.
	EndIf
	// Integração COM VLabs
	If oModel:GetOperation() == MODEL_OPERATION_DELETE
		cRetVLab := u_WsAluno(MODEL_OPERATION_DELETE)
	EndIf
	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		cRetVLab := u_WsAluno(MODEL_OPERATION_INSERT)
	ElseIf oModel:GetOperation() == MODEL_OPERATION_UPDATE
		cRetVLab := u_WsAluno(MODEL_OPERATION_UPDATE)
	EndIf

If ! Empty(cRetVLab)
	 help(NIL, NIL, "PosValid TCTTA020", NIL, cRetVLab, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Erro de integração com Vlabs"})
	 
	 AVISO("PosValid TCTTA020", cRetVLab, {"Fechar"}, 2)
	 
	 If MsgNoYes("Aluno não foi integrado com o Vlabs, deseja continuar assim mesmo")
	 	Return .T.
	 Endif
Endif	 
	 	
Return Empty(cRetVLab)


/*/{Protheus.doc} WsAluno
Função para consumir Ws Vlabs
@type function
@author queizy.nascimento
@since 21/03/2017
@version 1.0
@param nOperation, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*/
User Function WsAluno(nOperation)

	Local lOk, cResp, aElem, nPos, aInput := {}, aComplex := {}, nA, nPos, cMsg,xRet
	Local cRet			:= ''
	Local cURL			:= getMv('TI_URLVLAB',,'https://apis_dev.totvstreinamentos.com/webservices/CTTWService.asmx?WSDL')
	Local cMetodo		:= ''
	Local cResult		:= ''
	Local oWsdl 		:= tWSDLManager():New()
	Local cConst := "AddStudent#1.StudentInfo#1"
	Local cVal := "AddStudent#1.StudentInfo#1.Customer#1"
	Local cRemove :="RemoveStudent#1.StudentInfo#1"
	Local cIdTotvs	:= ""
	Local cDocId		:= ""
	Local cNameId		:= ""
	Local cPaisID		:= ""
	Local cTipoId		:= ""
	Local cEntId		:= ""
	

	default nOperation	:= 0	// 3=INCLUSAO;4=ALTERACAO;5=EXCLUCAO;

	oWsdl:lSSLInsecure 	:= .T.	// Define se fará a conexão SSL com o servidor de forma anônima, ou seja, sem verIficação de certIficados ou chaves.
	
	If nOperation == 5
		cMetodo := 'DeleteCTTStudent'
		cResult := 'RemoveStudent'
	ElseIf nOperation == 3 .OR. nOperation == 4
		cMetodo := 'CreateCTTStudent'
		cResult := 'AddStudent'
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
		lOk := oWsdl:SetComplexOccurs( aComplex[1], 1 )
		if !lOk 
			// conout( "Erro ao definir elemento " + aComplex[2] + ", ID " + cValToChar( aComplex[1] ) + ", com 1 ocorrência" )
			cRet := "Erro ao definir elemento " + aComplex[2] + ", ID " + cValToChar( aComplex[1] ) + ", com 1 ocorrência"
			//return
		endif
		aComplex := oWsdl:NextComplex()
	End
	
	If lOk
		aSimple := oWsdl:SimpleInput()
	
		If Empty(M->PDL_CLIENT)
			cIdTotvs	:= SUS->US_COD
			cDocId		:= SUS->US_CGC
			cNameId	:= SUS->US_NOME
			cPaisID	:= SUS->US_PAIS 
			cTipoId	:= SUS->US_TIPO
			cEntId		:= "SUS"
		
		Else
			cIdTotvs	:= SA1->A1_COD
			cDocId		:= SA1->A1_CGC
			cNameId	:= SA1->A1_NOME
			cPaisID	:= SA1->A1_PAIS 
			cTipoId	:= SA1->A1_TIPO
			cEntId		:= "SA1"
		EndIf
			
		If nOperation == 5
	
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cRemove } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], PDL->PDL_ALUNO )
	
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DELETEDON" .AND. aVet[5] == cRemove } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], FWTimeStamp(3,date() ))
		
		ElseIf nOperation == 3
		 
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "STUDENTID" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], M->PDL_ALUNO )
			
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "EMAIL" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],M->PDL_EMAIL )
	
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "FIRSTNAME" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(M->PDL_NOME, 1,AT(' ',PDL->PDL_NOME )) )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "LASTNAME" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(M->PDL_NOME,AT(' ',PDL->PDL_NOME )) )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTNUMBER" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], M->PDL_CPF )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PHONENUMBER" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], M->PDL_TEL )
	//CUSTOMER
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOTVSID" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cIdTotvs)
			
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTID" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],cDocId )
	
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cNameId )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "COUNTRYID" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cPaisID)
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TYPE" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cTipoId)
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ENTITY" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cEntId )
	
	
			
		
		ElseIf nOperation == 4
		
		
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "STUDENTID" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],PDL->PDL_ALUNO )
	
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "EMAIL" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],M->PDL_EMAIL )
		
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "FIRSTNAME" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(PDL->PDL_NOME, 1,AT(' ',PDL->PDL_NOME )) )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "LASTNAME" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], SUBSTR(PDL->PDL_NOME,AT(' ',PDL->PDL_NOME )) )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTNUMBER" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], M->PDL_CPF )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PHONENUMBER" .AND. aVet[5] == cConst } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], M->PDL_TEL )
			
	//CUSTOMER
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOTVSID" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cIdTotvs)
			
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DOCUMENTID" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1],cDocId)
	
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cNameId )
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "COUNTRYID" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cPaisID)
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TYPE" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cTipoId)
	  
			nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ENTITY" .AND. aVet[5] == cVal } )
			xRet := oWsdl:SetValue( aSimple[nPos][1], cEntId )
			
		EndIf
	  
			
	 
	
	
	///Pega a mensagem que sera enviada para Web Service
		cMsg := oWsdl:GetSoapMsg()
	
	// Faz a requisição ao WebService 
		lOk := oWsdl:SendSoapMsg(cMsg)
		If !lOk
			cRet += GetWSCError()
			cRet += CRLF
			cRet += oWSDL:GetSoapResponse()
		EndIf
	EndIf

	//CRET:=oWSDL:GetSoapResponse()
	//ALERT(CRET)
Return cRet

