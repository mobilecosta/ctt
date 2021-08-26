#INCLUDE "tctta010.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-- Definições para montagem do MVC
STATIC aForms 	:= { { 	"PDM"/* Tabela */, STR0001 /* Descrição */, .F. /* SetOptional */, .F.  /* SetOnlyView */, { } /* Relation */,; //"Cadastro de Cursos"
"" /* Fields Modelo 1 */, /* AutoIncremento */ "", 50 /* Area do Componente */, {} /* Unique Line */ },;
	{ 	"PDA", STR0002,  .T., .F., { { "PDA_FILIAL", "xFilial('PDM')" }, { "PDA_CURSO", "PDM_CURSO" } }, "", "PDA_ITEM", 50, {} } } //"Pre-Requisitos"
STATIC cFunName	:= "TCTTA010"
STATIC cFilter	:= ""
STATIC aLegend  := {}

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do cadastro de Cursos

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA010

	U_TCTTBrowse(aForms, cFunName, cFilter, aLegend)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem do Menu do cadastro de Cursos

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE STR0007  ACTION 'PesqBrw'             	OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE STR0008 ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0009    ACTION 'VIEWDEF.TCTTXMVC' 	OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE STR0010    ACTION 'VIEWDEF.TCTTXMVC'		OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE STR0011    ACTION 'VIEWDEF.TCTTXMVC'		OPERATION 5 ACCESS 0 //"Excluir"

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
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
@since 05/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ViewDef()

Return &("StaticCall(TCTTXMVC,VIEWDEF)")

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Ativação do modelo do cadastro de Cursos

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function Activate(oModel)

	Local nOperation := 0
	Local aError	 := {}, cError := "", nError := 0
	Local aArea		 := GetArea()
	Local cRetVLab :=""

	If oModel == Nil //-- É realizada chamada com modelo nulo para verIficar se a função existe
		Return .T.
	EndIf
	



	nOperation := oModel:GetOperation()

	If nOperation == MODEL_OPERATION_DELETE
	//-- 1. Uso em Pré-Requisitos
		BeginSQL Alias "PDAQRY"
			SELECT MIN(PDA_CURSO) AS PDA_CURSO
			FROM %table:PDA%
			WHERE %notDel% AND PDA_FILIAL = %Exp:xFilial("PDA")% AND PDA_CODCUR = %Exp:PDM->PDM_CURSO% AND PDA_CURSO <> %Exp:PDM->PDM_CURSO%
		EndSql

		If ! Empty(PDAQRY->PDA_CURSO)
			AAdd(aError, STR0003 + PDAQRY->PDA_CURSO + "]") //"PDA-Curso em uso no pré-requisito do curso ["
		EndIf
		PDAQRY->(DbCloseArea())

	//-- 2. Uso em Capacitação dos Professores
		BeginSQL Alias "PDNQRY"
			SELECT MIN(PD2.PD2_PROF) AS PD2_PROF, MIN(PD2.PD2_NOME) AS PD2_NOME
			FROM %table:PDN% PDN
			JOIN %table:PD2% PD2 ON PD2.%notDel% AND PD2.PD2_FILIAL = %Exp:xFilial("PD2")% AND PD2.PD2_PROF = PDN.PDN_PROF
			WHERE PDN.%notDel% AND PDN.PDN_FILIAL = %Exp:xFilial("PDN")% AND PDN.PDN_CURSO = %Exp:PDM->PDM_CURSO%
		EndSql

		If ! Empty(PDNQRY->PD2_PROF)
			AAdd(aError, STR0004 + PDNQRY->PD2_PROF + "/" + AllTrim(PDNQRY->PD2_NOME) + "]") //"PDN-Curso em uso na capacitação do professor ["
			lRet := .F.
		EndIf
		PDNQRY->(DbCloseArea())

	//-- 3. Uso em Turmas
		BeginSQL Alias "PD3QRY"
			SELECT MIN(PD3_TURMA) AS PD3_TURMA
			FROM %table:PD3%
			WHERE %notDel% AND PD3_FILIAL BETWEEN %Exp:Repl(" ", Len(xFilial("PD3")))% AND %Exp:Repl("Z", Len(xFilial("PD3")))%
			AND PD3_CURSO = %Exp:PDM->PDM_CURSO%
		EndSql

		If ! Empty(PD3QRY->PD3_TURMA)
			AAdd(aError, STR0005 + PD3QRY->PD3_TURMA + "]") //"PD3-Curso em uso na turma ["
			lRet := .F.
		EndIf
		PD3QRY->(DbCloseArea())

	//-- 4. Uso em Itens de Propostas
		BeginSQL Alias "PD9QRY"
			SELECT MIN(PD9_FILIAL) AS PD9_FILIAL, MIN(PD9_PROPOS) AS PD9_PROPOS
			FROM %table:PD9%
			WHERE %notDel% AND PD9_FILIAL BETWEEN %Exp:Repl(" ", Len(xFilial("PD3")))% AND %Exp:Repl("Z", Len(xFilial("PD3")))%
			AND PD9_CURSO = %Exp:PDM->PDM_CURSO%
		EndSql

		If ! Empty(PD9QRY->PD9_PROPOS)
			AAdd(aError, STR0006 + PD9QRY->(PD9_FILIAL + "/" + PD9_PROPOS) + "]") //"PD3-Curso em uso na filial/proposta ["
			lRet := .F.
		EndIf
		PD9QRY->(DbCloseArea())

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
// Integração COM VLabs
	//cRetVLab := u_WsCurso(nOperation)

	RestArea(aArea)

Return Len(aError) == 0

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Pós Validação (TudoOk) do modelo do cadastro de Turma alunos

@author Wagner Mobile Costa
@version P12
@since 28/08/2016
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function PosValid(oModel)
 
 

	Local lRet := .T.
	Local cRetVLab :=''
	Local nOperation := 0
	
	If oModel == Nil //-- É realizada chamada com modelo nulo para verIficar se a função existe
		Return .T.
	EndIf
// Integração COM VLabs
	If oModel:GetOperation() == MODEL_OPERATION_DELETE
		cRetVLab := u_WsCurso(MODEL_OPERATION_DELETE)
		Return .T.
	EndIf
	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		cRetVLab := u_WsCurso(MODEL_OPERATION_INSERT)
	ElseIf oModel:GetOperation() == MODEL_OPERATION_UPDATE
		cRetVLab := u_WsCurso(MODEL_OPERATION_UPDATE)
	EndIf

Return lRet
//--------------------------------------------------------------------------------
/*/{Protheus.doc} WsCurso
Função para consumir Ws VLabs
@type function
@author queizy.nascimento
@since 21/03/2017
@version 1.0
@param nOperation, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*/
User Function WsCurso(nOperation)

	Local lOk, cResp, aElem, nPos, aInput := {}, aComplex := {}, nA, nPos, cMsg,xRet
	Local cRet			:= 'OK'
	Local cURL			:= getMv('TI_URLVLAB',,'https://apis_dev.totvstreinamentos.com/webservices/CTTWService.asmx?WSDL')
	Local cMetodo		:= ''
	Local cResult		:= ''
	Local oWsdl 		:= tWSDLManager():New()
	Local cTraining:= "AddTraining#1.training#1"
	Local cRemove := "RemoveTraining#1.TrainingInfo#1"
	default nOperation	:= 0	// 3=INCLUSAO;4=ALTERACAO;5=EXCLUCAO;

	// Caso parametro esteja em branco não tenta integrar
	If Empty(cURL)
		Return ""
	EndIf

	oWsdl:lSSLInsecure 	:= .T.	// Define se fará a conexão SSL com o servidor de forma anônima, ou seja, sem verIficação de certIficados ou chaves.

	If nOperation == 5
		cMetodo := 'DeleteCTTTraining'
		cResult := 'RemoveTraining'
	ElseIf nOperation == 3 .OR. nOperation == 4
		cMetodo := 'CreateCTTTraining'
		cResult := 'AddTraining'
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

	aSimple := oWsdl:SimpleInput()

	If nOperation == 5
	
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cRemove } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PDM->PDM_CURSO )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "DELETEDON" .AND. aVet[5] == cRemove } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], FWTimeStamp(3,date() ))
		
		
	ElseIf nOperation == 3
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cTraining } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  M->PDM_CURSO )
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cTraining } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],M->PDM_NOME )
			
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "COURSELOAD" .AND. aVet[5] == cTraining } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], cValToChar(M->PDM_QTDHOR) )
		
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "MODALITY" .AND. aVet[5] == cTraining } )

		If M->PDM_CATEG == "1"
			xRet := oWsdl:SetValue(aSimple[nPos][1],"Presencial")
		ElseIf M->PDM_CATEG == "2"
			xRet := oWsdl:SetValue(aSimple[nPos][1],"Elearning")
		ElseIf M->PDM_CATEG == "3"
			xRet := oWsdl:SetValue(aSimple[nPos][1],"Controller")
		ElseIf M->PDM_CATEG == "4"
			xRet := oWsdl:SetValue(aSimple[nPos][1],"EAD")
		EndIf

		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PRODUCT" .AND. aVet[5] == cTraining } )

		If M->PDM_TPOSIS =='P'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'PROTHEUS')
		ElseIf M->PDM_TPOSIS =='R'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'RM')
		ElseIf M->PDM_TPOSIS =='G'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'FLUIG')
		ElseIf M->PDM_TPOSIS =='D'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'DATASUL')
		ElseIf M->PDM_TPOSIS =='L'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'LOGIX')
		ElseIf M->PDM_TPOSIS =='F'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'FORMACAO')
		ElseIf M->PDM_TPOSIS =='E'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'EAD')
		ElseIf M->PDM_TPOSIS =='H'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'PCSISTEMAS')
		ElseIf M->PDM_TPOSIS =='I'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'VIRTUALAGE')		
		EndIF

     /* Alteração realizada - 18/10/2018 
		aSx3Box 	:= (SX3->(DbSetOrder(2)), SX3->(DbSeek(M->PDM_TPOSIS)), RetSx3Box( X3CBox(),,, 1 ))
		nPos		:= Ascan( aSx3Box, { |aBox| aBox[2] = M->PDM_TPOSIS } )

		If nPos > 0
			xRet := upper(aSx3Box[nPos][3])
			oWsdl:SetValue( aSimple[nPos][1],xRet)
		endif
	*/
		
	ElseIf  nOperation == 4
	
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "TOKEN" .AND. aVet[5] == "CTTAuthToken#1" } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], U_RetToken() )
		
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "ID" .AND. aVet[5] == cTraining } )
		xRet := oWsdl:SetValue( aSimple[nPos][1],  PDM->PDM_CURSO)
  
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "NAME" .AND. aVet[5] == cTraining } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], PDM->PDM_NOME )
			
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "COURSELOAD" .AND. aVet[5] == cTraining } )
		xRet := oWsdl:SetValue( aSimple[nPos][1], cValToChar(M->PDM_QTDHOR) )
		
		nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "MODALITY" .AND. aVet[5] == cTraining } )
		IF M->PDM_CATEG =='1'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'Presencial')
		ElseIf M->PDM_CATEG =='2'
			xRet := oWsdl:SetValue( aSimple[nPos][1], 'Elearning')
		ElseIf M->PDM_CATEG =='3'
			xRet := oWsdl:SetValue( aSimple[nPos][1],  'Controller' )
		EndIf
		
		 nPos := aScan( aSimple, {|aVet| Upper(aVet[2]) == "PRODUCT" .AND. aVet[5] == cTraining } )
		If M->PDM_TPOSIS =='P'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'PROTHEUS')
		ElseIf M->PDM_TPOSIS =='R'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'RM')
		ElseIf M->PDM_TPOSIS =='G'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'FLUIG')
		ElseIf M->PDM_TPOSIS =='D'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'DATASUL')
		ElseIf M->PDM_TPOSIS =='L'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'LOGIX')
		ElseIf M->PDM_TPOSIS =='F'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'FORMACAO')
		ElseIf M->PDM_TPOSIS =='E'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'EAD')
		ElseIf M->PDM_TPOSIS =='H'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'PCSISTEMAS')
		ElseIf M->PDM_TPOSIS =='I'
			xRet := oWsdl:SetValue( aSimple[nPos][1],'VIRTUALAGE')		
		EndIF
		
/*    Alteração realizada - 18/10/2018   
		aSx3Box 	:= (SX3->(DbSetOrder(2)), SX3->(DbSeek(M->PDM_TPOSIS)), RetSx3Box( X3CBox(),,, 1 ))
		nPos		:= Ascan( aSx3Box, { |aBox| aBox[2] = M->PDM_TPOSIS } )

		If nPos > 0
			xRet := upper(aSx3Box[nPos][3])
			oWsdl:SetValue( aSimple[nPos][1],xRet)
		endif
*/		
	
	EndIf

///Pega a mensagem que sera enviada para Web Service
	cMsg := oWsdl:GetSoapMsg()

// Faz a requisição ao WebService 
	lOk := oWsdl:SendSoapMsg(cMsg)
	If !lOk
		cRet := oWsdl:cError
		// ConOut('ERROR INTEGRAÇÃO VLABS-> ' + cRet + CRLF + cMsg)
		Return cRet
	EndIf

Return
