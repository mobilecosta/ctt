#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'FWMVCDEF.CH'

Static _SA1PERMA := GetMv('TI_CPPSA1A',,'A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_PESSOA,A1_CGC,A1_MSBLQL,A1_INSCR,A1_CNAE,A1_CODSEG,A1_CEP,A1_END,A1_COMPLEM,A1_BAIRRO,A1_MUN,A1_EST,A1_EMAIL,A1_VEND,A1_SUPER,A1_XDAR,A1_XGAR,A1_DDD,A1_DDI,A1_TEL,A1_PAIS,A1_TIPO,A1_XNEND,A1_NREDUZ,A1_DTNASC') // Campos permitidos para retorno SA1
Static _SA1PERMB := GetMv('TI_CPPSA1B',,'A1_DTCAD,A1_PRICOM,A1_UNIDVEN,A1_DDD,A1_XCODSUB,A1_XSITCLI,A1_CONTATO,A1_USERLGA,AI0_XFATAN,AI0_XINAD,U5_CODCONT,U5_CONTAT,U5_EMAIL') // Campos permitidos para retorno SA1 - complemento
Static _SUSPERMA := GetMv('TI_CPPSUSA',,'US_FILIAL,US_COD,US_LOJA,US_NOME,US_PESSOA,US_CGC,US_MSBLQL,US_INSCR,US_CNAE,US_CODSEG,US_CEP,US_END,US_XCOMPLE,US_BAIRRO,US_MUN,US_EST,US_EMAIL,US_VEND,US_XGAR,US_XDTNAS') // Campos permitidos para retorno SUS
Static _SUSPERMB := GetMv('TI_CPPSUSB',,'') // Campos permitidos para retorno SUS
Static _ACHPERMA := GetMv('TI_CPPACHA',,'ACH_FILIAL,ACH_CODIGO,ACH_LOJA,ACH_RAZAO,ACH_NFANT,ACH_PESSOA,ACH_CGC,ACH_MSBLQL,ACH_XINSCR,ACH_CNAE,ACH_CODSEG,ACH_CEP,ACH_END,ACH_BAIRRO,ACH_EST,ACH_CIDADE,ACH_CODMUN,ACH_EMAIL,ACH_VEND,ACH_XGAR,ACH_DDD,ACH_TEL,ACH_PAIS,ACH_XUPMSH') // Campos permitidos para retorno ACH
Static _ACHPERMB := GetMv('TI_CPPACHB',,'') // Campos permitidos para retorno ACH
Static _SU5PERMA := GetMv('TI_CPPSU5A',,'U5_FILIAL,U5_CODCONT,U5_CONTAT,U5_EMAIL,U5_CPF,U5_FCOM1,U5_CELULAR,U5_DDD,U5_FONE,U5_MSBLQL,U5_END,U5_BAIRRO,U5_MUN,U5_EST,U5_CEP,A1_COD,A1_LOJA,A1_CODMEMB,US_COD,US_LOJA,US_CODMEMB,ACH_CODIGO,ACH_LOJA,ACH_CODMEM') // Campos permitidos para retorno SU5
Static _SU5PERMB := GetMv('TI_CPPSU5B',,'') // Campos permitidos para retorno SU5

Static _SA1PERMZ := AllTrim(_SA1PERMA) + ',' + AllTrim(_SA1PERMB)
Static _SUSPERMZ := AllTrim(_SUSPERMA) + ',' + AllTrim(_SUSPERMB)
Static _ACHPERMZ := AllTrim(_ACHPERMA) + ',' + AllTrim(_ACHPERMB)
Static _SU5PERMZ := AllTrim(_SU5PERMA) + ',' + AllTrim(_SU5PERMB)

/*/{Protheus.doc} TCRMS056
Dummy Function
@author Jose Camilo
@since 29/09/2020
@version 1.0
/*/
User Function TCRMS056()
return .T.

/*/{Protheus.doc} Contas

API de integração de Contas: Clientes, Prospects e Suspects

@param	id    	, Codigo do cliente ou Codigo + Loja que deve ser retornado Ex: /TEXHMP ou /TEXHMP00
@param	fields	, Campos, separados por virgula, que serão retornados nos objetos Ex: /?fields=A1_COD,A1_LOJA,A1_NOME
@param	filter	, Filtro para busca, no modo chave=valor ou no padrão oData Ex:  /?A1_COD=TEXHMP&A1_LOJA=00 ou /?filter=A1_COD eq 'TEXHMP'
@param	order		, Campos para ordenação da busca, separados por virgula  Ex: /?order=A1_COD,A1_LOJA
@param	page		, Número da página que deve retornar
@param	pageSize	, Número de registros por páginas

@author		Jose Camilo
@since		29/09/2020
/*/
WSRESTFUL Contas DESCRIPTION 'API de integração de Contas: Clientes, Prospects e Suspects'

	WSDATA fields     AS STRING	OPTIONAL
	WSDATA order			AS STRING	OPTIONAL
	WSDATA page				AS INTEGER	OPTIONAL
	WSDATA pageSize   AS INTEGER	OPTIONAL
	WSDATA id	        AS STRING	OPTIONAL
  WSDATA filter     AS STRING	OPTIONAL
 
  WSMETHOD GET ListClientes ;
    DESCRIPTION 'Lista de Clientes' ;
    WSSYNTAX '/api/crm/contas/v1/clientes/?{fields, order, page, pageSize, filter}' ;
    PATH '/api/crm/contas/v1/clientes' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

	WSMETHOD GET ItemClientes ;
    DESCRIPTION 'Devolve um Cliente específico' ;
    WSSYNTAX '/api/crm/contas/v1/clientes/{id}/?{fields}' ;
    PATH '/api/crm/contas/v1/clientes/{id}'	;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD GET ListProspects ;
    DESCRIPTION 'Lista de Prospects' ;
    WSSYNTAX '/api/crm/contas/v1/prospects/?{fields, order, page, pageSize, filter}' ;
    PATH '/api/crm/contas/v1/prospects' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

	WSMETHOD GET ItemProspects ;
    DESCRIPTION 'Devolve um Prospect específico' ;
    WSSYNTAX '/api/crm/contas/v1/prospects/{id}/?{fields}' ;
    PATH '/api/crm/contas/v1/prospects/{id}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD PUT Prospects ;
    DESCRIPTION 'Altera um Prospects' ;
    WSSYNTAX '/api/crm/contas/v1/prospects/{id}/?{body}' ;
    PATH '/api/crm/contas/v1/prospects/{id}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD POST Prospects ;
    DESCRIPTION 'Inclui um novo Prospects' ;
    WSSYNTAX '/api/crm/contas/v1/prospects/?{body}' ;
    PATH '/api/crm/contas/v1/prospects/' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD GET ListSuspects ;
    DESCRIPTION 'Lista de Suspects' ;
    WSSYNTAX '/api/crm/contas/v1/suspects/?{fields, order, page, pageSize, filter}' ;
    PATH '/api/crm/contas/v1/suspects' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

	WSMETHOD GET ItemSuspects ;
    DESCRIPTION 'Devolve um Suspect específico' ;
    WSSYNTAX '/api/crm/contas/v1/suspects/{id}/?{fields}' ;
    PATH '/api/crm/contas/v1/suspects/{id}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON
	
  WSMETHOD PUT Suspects ;
    DESCRIPTION 'Altera um Suspect' ;
    WSSYNTAX '/api/crm/contas/v1/suspects/{id}/?{body}' ;
    PATH '/api/crm/contas/v1/suspects/{id}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD POST Suspects ;
    DESCRIPTION 'Inclui um novo Suspect' ;
    WSSYNTAX '/api/crm/contas/v1/suspects/?{body}' ;
    PATH '/api/crm/contas/v1/suspects/' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON
  
  WSMETHOD GET ListContatos ;
    DESCRIPTION 'Lista de Contatos' ;
    WSSYNTAX '/api/crm/contas/v1/contatos/?{fields, order, page, pageSize, filter}' ;
    PATH '/api/crm/contas/v1/contatos' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

	WSMETHOD GET ItemContatos ;
    DESCRIPTION 'Devolve um Contato específico' ;
    WSSYNTAX '/api/crm/contas/v1/contatos/{id}/?{fields}' ;
    PATH '/api/crm/contas/v1/contatos/{id}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD PUT Contatos ;
    DESCRIPTION 'Altera um Contato' ;
    WSSYNTAX '/api/crm/contas/v1/contatos/{id}/?{body}' ;
    PATH '/api/crm/contas/v1/contatos/{id}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD POST Contatos ;
    DESCRIPTION 'Inclui um novo Contato' ;
    WSSYNTAX '/api/crm/contas/v1/contatos/?{body}' ;
    PATH '/api/crm/contas/v1/contatos/' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD GET ValidaIncLead ;
    DESCRIPTION 'Valida a inclusão de um lead' ;
    WSSYNTAX '/api/crm/contas/v1/validacoes/inclusao-lead' ;
    PATH '/api/crm/contas/v1/validacoes/inclusao-lead' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD POST ValidaEmail ;
    DESCRIPTION 'Valida um ou mais e-mails' ;
    WSSYNTAX '/api/crm/contas/v1/validacoes/emails/?{body}' ;
    PATH '/api/crm/contas/v1/validacoes/emails' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

ENDWSRESTFUL

/*/{Protheus.doc} GET 
/ api/crm/contas/v1/clientes
Retorna todos os Clientes

@param	fields		, caracter, Campos que serão retornados no GET.
@param	order		, caracter, Ordenação da tabela principal
@param	page		, numérico, Número da página inicial da consulta
@param	pageSize	, numérico, Número de registro por páginas
@param	filter	, Filtro para busca simples ou no padrão oData

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ListClientes WSRECEIVE fields, order, page, pageSize, filter  WSSERVICE Contas

Local lRet			  := .T.
Local oResponse  
Local oDataBase   := nil

Local cWhere      := ''
Local cQuery      := ''

Local aFields     := {}
Local nx          := 0

Local lUserLGA    := .F.
Local dDataAux    := ctod('')

Local lLstCont    := .F.
Local aLstCont    := {}

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Local cHeadMigra  := Lower(AllTrim(httpHeader('integration-migration')))

Default self:fields   := 'A1_COD,A1_LOJA,A1_NOME'
Default self:order    := 'A1_FILIAL,A1_COD,A1_LOJA'
Default self:page     := 1
Default self:pageSize := 20
Default self:filter   := ''

If !Empty(cHeadMigra) .And. cHeadMigra == 'true'
  self:pageSize := Iif(self:pageSize > 1000, 1000, self:pageSize)
Else
  self:pageSize := Iif(self:pageSize > 50, 50, self:pageSize)
EndIf

Begin Sequence

  //Tratamento para campos passados para o rest
  self:fields := VldCposCli(self:fields, @lUserLGA, @lLstCont)

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .T. ) 
  oDataBase:setPage(self:page)
  oDataBase:setPageSize(self:pageSize)
  oDataBase:SetOrderQuery(self:order)
  oDataBase:SetUrlFilter({{'FILTER',self:filter}})
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SA1PERMZ, ',')

  for nx := 1 to Len(aFields)
    If AllTrim(Upper(aFields[nx])) != 'A1_USERLGA' //A1_USERLGA tem tratamento diferenciado abaixo
      oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
    EndIf
  next

  //Tratamento específico para o A1_USERLGA - somente usa no filtro pois é retirado da lista de campos
  oDataBase:AddMapFields( "A1_USERLGA"   , ;
          "TO_CHAR(TO_DATE('19960101', 'YYYYMMDD')+((ASCII(SUBSTR(A1_USERLGA,12,1))-50)*100+(ASCII(SUBSTR(A1_USERLGA,16,1))-50)))" , ;
          .T., .F., { "A1_USERLGA"  , 'C', 8, 0 } )

  // Dados da Query
  cQuery := " SELECT DISTINCT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'SA1' ) + " SA1 "

  If At('AI0_',Upper(self:fields)) > 0 .Or. At('AI0_',Upper(self:filter)) > 0 //Se tiver campo da AI0
    cQuery += " INNER JOIN " + RetSqlName( 'AI0' ) + " AI0 "
    cQuery += "    ON AI0_FILIAL = '" + xFilial('AI0') + "' "
    cQuery += "   AND AI0_CODCLI = A1_COD "
    cQuery += "   AND AI0_LOJA = A1_LOJA "
    cQuery += "   AND AI0.D_E_L_E_T_ = ' ' "
  EndIf

  If At('U5_',Upper(self:filter)) > 0 //Se tiver campo da SU5 no filtro
    cQuery += " INNER JOIN " + RetSqlName( 'AC8' ) + " AC8 "
    cQuery += "    ON AC8_FILIAL = '" + xFilial('AC8') + "' "
    cQuery += "   AND AC8_ENTIDA = 'SA1' "
    cQuery += "   AND AC8_CODENT = A1_COD || A1_LOJA "
    cQuery += "   AND AC8.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN " + RetSqlName( 'SU5' ) + " SU5 "
    cQuery += "    ON U5_FILIAL = '" + xFilial('SU5') + "' "
    cQuery += "   AND U5_CODCONT = AC8_CODCON "
    cQuery += "   AND SU5.D_E_L_E_T_ = ' ' "    
  EndIf

  cQuery += " WHERE #QueryWhere#"
  cWhere := " A1_FILIAL = '"+ FWxFilial('SA1') +"' AND SA1.D_E_L_E_T_ = ' '"  
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

    For nX := 1 To Len(oResponse["items"])

      //Campo de log de alteração
      If lUserLGA

        SA1->(DBSetOrder(1))

        If SA1->(DbSeek(xFilial('SA1') + Padr(oResponse["items"][nX]["a1_cod"], TamSx3('A1_COD')[1]) + Padr(oResponse["items"][nX]["a1_loja"], TamSx3('A1_LOJA')[1])))

          dDataAux := stod('19960101')+((Asc(Substr(SA1->A1_USERLGA,12,1))-50)*100+(Asc(Substr(SA1->A1_USERLGA,16,1))-50))

          oResponse["items"][nX]["a1_userlga"] := AllTrim(Str(Year( dDataAux))) + '-' + AllTrim(StrZero(Month(dDataAux),2)) + '-' + AllTrim(StrZero(Day(dDataAux),2))

        EndIf

      EndIf

      //Lista de contatos
      If lLstCont

        aLstCont := aClone(ListaCont('SA1', Padr(oResponse["items"][nX]["a1_cod"],TamSX3('A1_COD')[1]) + oResponse["items"][nX]["a1_loja"]))

        oResponse["items"][nX]["contatos"] := AClone(aLstCont)

      EndIf

    Next nX

  EndIf

End Sequence

ErrorBlock(oException)

// Verifica errorBlock
If lRet
  
  // Verifica execução da query
  If oDataBase:lOk

      self:SetResponse(oResponse:toJson())

  Else

    If Type('oResponse') == 'O'
      FreeObj(oResponse)
    EndIf

    oResponse   := JsonObject():New()    

    oResponse['code'] := 2 // oDataBase:GetCode()
    oResponse['status'] := 400
    oResponse['message'] := 'Não foi possível realizar o filtro dos registros!'
    oResponse['detailedMessage'] := oDataBase:GetMessage()
    lRet := .F.

  EndIf

Else

  If Type('oResponse') == 'O'
    FreeObj(oResponse)
  EndIf

  oResponse   := JsonObject():New()    

  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk

EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil
aFields := nil
Return lRet

/*/{Protheus.doc} GET 
/ api/crm/contas/v1/clientes
Retorna um Cliente especifico

@param	id    		, caracter, Codigo do cliente ou Codigo + Loja que deve ser retornado
@param	fields		, caracter, Campos que serão retornados no GET

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ItemClientes PATHPARAM id WSRECEIVE fields WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local lUserLGA    := .F.
Local dDataAux    := ctod('')

Local lLstCont    := .F.
Local aLstCont    := {}

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Default self:fields   := _SA1PERMZ
Default self:id       := ''
Default self:order    := 'A1_FILIAL,A1_COD,A1_LOJA'

Begin Sequence

  //Tratamento para campos passados para o rest
  self:fields := VldCposCli(self:fields, @lUserLGA, @lLstCont)

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .F. ) 
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SA1PERMZ, ',')
  for nx := 1 to Len(aFields)
    If AllTrim(Upper(aFields[nx])) != 'A1_USERLGA' //A1_USERLGA tem tratamento diferenciado abaixo
      oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
    EndIf
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'SA1' ) + " SA1 "

  If At('AI0_',Upper(self:fields)) > 0 .Or. At('AI0_',Upper(self:filter)) > 0 //Se tiver campo da AI0
    cQuery += " INNER JOIN " + RetSqlName( 'AI0' ) + " AI0 "
    cQuery += "    ON AI0_FILIAL = '" + xFilial('AI0') + "' "
    cQuery += "   AND AI0_CODCLI = A1_COD "
    cQuery += "   AND AI0_LOJA = A1_LOJA "
    cQuery += "   AND AI0.D_E_L_E_T_ = ' ' "
  EndIf

  cQuery += " WHERE #QueryWhere#"

  cWhere := " A1_FILIAL = '"+ FWxFilial('SA1') +"' AND SA1.D_E_L_E_T_ = ' '"
  If Len(self:id) >= 7
    cWhere += " AND A1_COD = '" + SubStr(self:id, 0, Len(self:id)-2) + "' "
    cWhere += " AND A1_LOJA = '" + SubStr(self:id, Len(self:id)-1, 2) + "' "
  Else
    cWhere += " AND A1_COD = '" + self:id + "' "
  EndIf 
    
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
    If lUserLGA

      SA1->(DBSetOrder(1))

      If SA1->(DbSeek(xFilial('SA1') + Padr(oResponse["a1_cod"], TamSx3('A1_COD')[1]) + Padr(oResponse["a1_loja"], TamSx3('A1_LOJA')[1])))

        dDataAux := stod('19960101')+((Asc(Substr(SA1->A1_USERLGA,12,1))-50)*100+(Asc(Substr(SA1->A1_USERLGA,16,1))-50))

        oResponse["a1_userlga"] := AllTrim(Str(Year( dDataAux))) + '-' + AllTrim(StrZero(Month(dDataAux),2)) + '-' + AllTrim(StrZero(Day(dDataAux),2))

      EndIf

    EndIf

    //Lista de contatos
    If lLstCont

      aLstCont := aClone(ListaCont('SA1', Padr(oResponse["a1_cod"],TamSX3('A1_COD')[1]) + oResponse["a1_loja"]))

      oResponse["contatos"] := AClone(aLstCont)

    EndIf

  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  // Verifica execução da query
  If oDataBase:lOk

      self:SetResponse(oResponse:toJson())

  Else

    If Type('oResponse') == 'O'
      FreeObj(oResponse)
    EndIf

    oResponse   := JsonObject():New()    

    oResponse['code'] := 2 // oDataBase:GetCode()
    oResponse['status'] := 400
    oResponse['message'] := 'Não foi possível realizar o filtro dos registros!'
    oResponse['detailedMessage'] := oDataBase:GetMessage()
    lRet := .F.
  EndIf

Else

  If Type('oResponse') == 'O'
    FreeObj(oResponse)
  EndIf

  oResponse   := JsonObject():New()    

  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil
aFields := nil
Return lRet

/*/{Protheus.doc} GET 
/ api/crm/contas/v1/prospects
Retorna todos os Prospects

@param	fields		, caracter, Campos que serão retornados no GET.
@param	order		, caracter, Ordenação da tabela principal
@param	page		, numérico, Número da página inicial da consulta
@param	pageSize	, numérico, Número de registro por páginas
@param	filter	, Filtro para busca simples ou no padrão oData

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ListProspects WSRECEIVE fields, order, page, pageSize, filter  WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local lUserLGA  := .F.
Local lLstCont  := .F.
Local dDataAux  := nil
Local aLstCont  := {}

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Local cHeadMigra  := Lower(AllTrim(httpHeader('integration-migration')))

Default self:fields   := 'US_COD,US_LOJA,US_NOME'
Default self:order    := 'US_FILIAL,US_COD,US_LOJA'
Default self:page     := 1
Default self:pageSize := 20
Default self:filter   := ''

If !Empty(cHeadMigra) .And. cHeadMigra == 'true'
  self:pageSize := Iif(self:pageSize > 1000, 1000, self:pageSize)
Else
  self:pageSize := Iif(self:pageSize > 50, 50, self:pageSize)
EndIf

Begin Sequence

  //Tratamento para campos passados para o rest
  self:fields := VldCposSUS(self:fields, @lUserLGA, @lLstCont)

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .T. ) 
  oDataBase:setPage(self:page)
  oDataBase:setPageSize(self:pageSize)
  oDataBase:SetOrderQuery(self:order)
  oDataBase:SetUrlFilter(self:aQueryString)
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SUSPERMZ, ',')

  for nx := 1 to Len(aFields)
    If AllTrim(Upper(aFields[nx])) != 'US_USERLGA' // USERLGA tem tratamento diferenciado
      oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
    EndIf
  next

  //Tratamento específico para o USERLGA - somente usa no filtro pois é retirado da lista de campos
  oDataBase:AddMapFields( "US_USERLGA" , ;
          "TO_CHAR(TO_DATE('19960101', 'YYYYMMDD')+((ASCII(SUBSTR(US_USERLGA,12,1))-50)*100+(ASCII(SUBSTR(US_USERLGA,16,1))-50)))" , ;
          .T., .F., { "US_USERLGA"  , 'C', 8, 0 } )

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'SUS' ) + " SUS "

  If At('U5_',Upper(self:filter)) > 0 //Se tiver campo da SU5 no filtro
    cQuery += " INNER JOIN " + RetSqlName( 'AC8' ) + " AC8 "
    cQuery += "    ON AC8_FILIAL = '" + xFilial('AC8') + "' "
    cQuery += "   AND AC8_ENTIDA = 'SUS' "
    cQuery += "   AND AC8_CODENT = US_COD || US_LOJA "
    cQuery += "   AND AC8.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN " + RetSqlName( 'SU5' ) + " SU5 "
    cQuery += "    ON U5_FILIAL = '" + xFilial('SU5') + "' "
    cQuery += "   AND U5_CODCONT = AC8_CODCON "
    cQuery += "   AND SU5.D_E_L_E_T_ = ' ' "    
  EndIf
  
  cQuery += " WHERE #QueryWhere#"
  cWhere := " US_FILIAL = '"+ FWxFilial('SUS') +"' AND SUS.D_E_L_E_T_ = ' '"  
  oDataBase:SetQuery( cQuery )
  oDataBase:SetWhere( cWhere )
  oDataBase:SetOrder( self:order )
  
  //Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
  If oDataBase:Execute()
    // Gera o arquivo Json com o retorno da Query
    oDataBase:FillGetResponse()
  EndIf
  
  If oDataBase:lOk
    oResponse := JsonObject():New()
    oResponse:fromJson(oDataBase:getJSONResponse())

    For nx := 1 To Len(oResponse["items"])
      //Campo de log de alteração
      If lUserLGA
        SUS->(DBSetOrder(1))
        If SUS->(DbSeek(xFilial('SUS') + Padr(oResponse["items"][nx]["us_cod"], TamSx3('US_COD')[1]) + Padr(oResponse["items"][nx]["us_loja"], TamSx3('US_LOJA')[1])))
          dDataAux := stod('19960101')+((Asc(Substr(SUS->US_USERLGA,12,1))-50)*100+(Asc(Substr(SUS->US_USERLGA,16,1))-50))
          oResponse["items"][nx]["us_userlga"] := AllTrim(Str(Year( dDataAux))) + '-' + AllTrim(StrZero(Month(dDataAux),2)) + '-' + AllTrim(StrZero(Day(dDataAux),2))
        EndIf
      EndIf

      //Lista de contatos
      If lLstCont
        aLstCont := aClone(ListaCont('SUS', Padr(oResponse["items"][nx]["us_cod"],TamSX3('US_COD')[1]) + Padr(oResponse["items"][nx]["us_loja"], TamSx3('US_LOJA')[1])))
        oResponse["items"][nx]["contatos"] := AClone(aLstCont)
      EndIf
    Next nx
  EndIf

End Sequence

ErrorBlock(oException)

// Verifica errorBlock
If lRet
  // Verifica execução da query
  If oDataBase:lOk
    self:SetResponse(oResponse:toJson())
  Else
    oResponse['code'] := 2
    oResponse['status'] := 400
    oResponse['message'] := 'Não foi possível realizar o filtro dos registros!'
    oResponse['detailedMessage'] := oDataBase:GetMessage()
    lRet := .F.
  EndIf
Else
  oResponse['code'] := 001
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil
aFields := nil
Return lRet

/*/{Protheus.doc} GET 
/ api/crm/contas/v1/prospects
Retorna um Prospect especifico

@param	id    		, caracter, Codigo do Prospect que deve ser retornado
@param	fields		, caracter, Campos que serão retornados no GET

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ItemProspects PATHPARAM id WSRECEIVE fields WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local lLstCont  := .F.
Local aLstCont  := {}

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Default self:fields   := _SUSPERMZ + ',contatos'
Default self:id       := ''
Default self:order    := 'US_FILIAL,US_COD,US_LOJA'

Begin Sequence

  //Tratamento para campos passados para o rest
  self:fields := VldCposSUS(self:fields,, @lLstCont)

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .F. ) 
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SUSPERMZ, ',')
  for nx := 1 to Len(aFields)
    oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'SUS' ) + " SUS "
  cQuery += " WHERE #QueryWhere#"

  cWhere := " US_FILIAL = '"+ FWxFilial('SUS') +"' AND SUS.D_E_L_E_T_ = ' '"
  If Len(self:id) >= 7
    cWhere += " AND US_COD = '" + SubStr(self:id, 0, Len(self:id)-2) + "' "
    cWhere += " AND US_LOJA = '" + SubStr(self:id, Len(self:id)-1, 2) + "' "
  Else
    cWhere += " AND US_COD = '" + self:id + "' "
  EndIf 
    
  oDataBase:SetQuery( cQuery )
  oDataBase:SetWhere( cWhere )
  oDataBase:SetOrder( self:order )
  
  //Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
  If oDataBase:Execute()
    // Gera o arquivo Json com o retorno da Query
    oDataBase:FillGetResponse()
  EndIf

  If oDataBase:lOk
    oResponse := JsonObject():New()
    oResponse:fromJson(oDataBase:getJSONResponse())

    //Lista de contatos
    If lLstCont
      aLstCont := aClone(ListaCont('SUS', Padr(oResponse["us_cod"],TamSX3('US_COD')[1]) + Padr(oResponse["us_loja"], TamSx3('US_LOJA')[1])))
      oResponse["contatos"] := AClone(aLstCont)
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  // Verifica execução da query
  If oDataBase:lOk
    self:SetResponse(oResponse:toJson())
  Else
    oResponse['code'] := 2 // oDataBase:GetCode()
    oResponse['status'] := 400
    oResponse['message'] := 'Não foi possível realizar o filtro dos registros!'
    oResponse['detailedMessage'] := oDataBase:GetMessage()
    lRet := .F.
  EndIf

Else
  oResponse['code'] := 001
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil
aFields := nil
Return lRet

/*/{Protheus.doc} PUT 
/ api/crm/contas/v1/prospects
Altera um Prospect

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD PUT Prospects PATHPARAM id WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oBody       := JsonObject():New()
Local oDataBase   := JsonObject():New()
Local cBody       := self:GetContent()

Local cErroAuto   := ''
Local cErrBody    := ''
Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })


Begin Sequence

  If !Empty(cErrBody := oBody:fromJson(cBody))
    lRet := .F.
    oResponse['code'] := 4
    oResponse['status'] := 400
    oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
    oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody
  Else

    // Busca conta através do código
    If Empty(self:id) 
      lRet := .F.
      oResponse['code'] := 3
      oResponse['status'] := 400
      oResponse['message'] := 'Deve ser enviado o código + Loja do prospect (US_COD+US_LOJA)'
      oResponse['detailedMessage'] := 'Verifique se a url está completa com o código + Loja do prospect (US_COD+US_LOJA).'
    Else

      DbSelectArea("SUS")
      SUS->(DBSetOrder(1)) //US_FILIAL+US_COD+US_LOJA

      If !SUS->(DbSeek(xFilial("SUS")+self:id))
        lRet := .F.
        oResponse['code'] := 2
        oResponse['status'] := 400
        oResponse['message'] := 'O Prospect ' + self:id + ' não existe em nossa base (US_COD+ACH_LOJA).'
        oResponse['detailedMessage'] := 'Certifique-se de que o id enviado é de um prospect (US_COD+US_LOJA).'
      Else

        oBody['US_COD'] := SUS->US_COD
        oBody['US_LOJA'] := SUS->US_LOJA

        oDataBase := U_TCSSUSAlt(oBody, @cErroAuto)

        If !Empty(cErroAuto)
          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível alterar a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil 
oBody:DeActivate()
oBody := nil 
aFields := nil
Return lRet

/*/{Protheus.doc} POST 
/ api/crm/contas/v1/prospects
Inclui um novo Prospect

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD POST Prospect WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oBody       := JsonObject():New()
Local oDataBase   := JsonObject():New()
Local cBody       := self:GetContent()

Local cErroAuto   := ''
Local cErrBody    := ''
Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })


Begin Sequence

  If !Empty(cErrBody := oBody:fromJson(cBody))
    lRet := .F.
    oResponse['code'] := 4
    oResponse['status'] := 400
    oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
    oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody
  Else
    
    // Valida atributos obrigatorios
    If Empty(oBody['US_CGC'])
      lRet := .F.
      oResponse['code'] := 3
      oResponse['status'] := 400
      oResponse['message'] := 'Deve ser enviada a propriedade US_CGC com CPF/CNPJ'
      oResponse['detailedMessage'] := 'Verifique se no conteúdo está sendo enviado a propriedade US_CGC.'
    Else

      // Busca conta através de CPF/CNPJ
      DbSelectArea("SA1")
      SA1->(DBSetOrder(3)) //A1_FILIAL+A1_CGC
      DbSelectArea("SUS")
      SUS->(DBSetOrder(4)) //US_FILIAL+US_CGC
      DbSelectArea("ACH")
      ACH->(DBSetOrder(2)) //ACH_FILIAL+ACH_CGC

      If SA1->(DbSeek(xFilial("SA1")+oBody['US_CGC'])) .Or.;
          SUS->(DbSeek(xFilial("SUS")+oBody['US_CGC'])) .Or.;
          ACH->(DbSeek(xFilial("ACH")+oBody['US_CGC']))
        lRet := .F.
        oResponse['code'] := 2
        oResponse['status'] := 400
        oResponse['message'] := 'CPF/CNPJ ' + oBody['US_CGC'] + ' já existe em nossa base.'
        oResponse['detailedMessage'] := 'Certifique-se de que não exista uma conta com o CPF/CNPJ ' + oBody['US_CGC'] + '.'
      Else
        oDataBase := U_TCSSUSInc(oBody, @cErroAuto)

        If !Empty(cErroAuto)
          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível incluir a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil 
oBody:DeActivate()
oBody := nil
aFields := nil
Return lRet

/*/{Protheus.doc} TCSSUSInc
Inclui um novo Prospect

@param	oConta		, object, Objeto JsonObject() com as propriedades que serão inclusas na conta
Campos obrigatorios neste objeto:
US_CGC,US_PESSOA,US_NOME,US_VEND,US_END,US_CEP,US_EST,US_MUN,US_COD_MUN,US_CNAE

@param	cErro      , string , Variavel para receber via referencia, possiveis erros

@return oResult	, object, Retorna o registro incluido na base

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
User Function TCSSUSInc(oConta, cErro)

Local aExecAuto   := {}
Local aFields     := {}
Local nx          := 0
Local oResult     := JsonObject():New()
Local cCmpObrig   := GetMv('TI_S56SUS1',,'US_CGC,US_PESSOA,US_NOME,US_VEND,US_END,US_CEP,US_EST,US_MUN,US_COD_MUN,US_CNAE,US_XDTNAS')

Default oConta    := nil
Default cErro     := ''

Private lMsErroAuto	:= .F.

If ValType(oConta) == nil
  cErro := 'Não foram enviadas informações sobre a conta'
  Return nil
EndIf

// Campos obrigatórios
If !TCSVldAtrb(oConta, cCmpObrig)
  cErro := 'As seguintes propriedades são obrigatórias: ' + cCmpObrig
  Return nil
EndIf

aFields := oConta:GetNames()
for nx := 1 to Len(aFields)
  If aFields[nx] $ _SUSPERMZ

    // Campos que precisam de tratamentos
    If TamSX3(aFields[nx])[3] == 'D'
      oConta[aFields[nx]] := StoD(oConta[aFields[nx]])
    EndIf

    AAdd( aExecAuto, {aFields[nx], oConta[aFields[nx]], nil})
  EndIf
next

If U_TSetPapel(@cErro, oConta['US_VEND'])
  M->TMKA260_P := .T.		//-- Passagem direta na inclusão de prospect
  TMKA260(aExecAuto, 3)

  cErro := U_SrvXGetMostraErro()
  If !lMsErroAuto .And. Empty(cErro)
    aFields := StrToKArr2(_SUSPERMZ, ',')
    
    for nx := 1 to Len(aFields)
      oResult[aFields[nx]] := SUS->&(aFields[nx])
    next
  EndIf
EndIf

aExecAuto := nil
aFields := nil
Return oResult

/*/{Protheus.doc} TCSSUSAlt
Altera um Prospect

@param	oConta		, object, Objeto JsonObject() com as propriedades que serão alteradas na conta

@param	cErro      , string , Variavel para receber via referencia, possiveis erros

@return oResult	, object, Retorna o registro alterado na base

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
User Function TCSSUSAlt(oConta, cErro)

Local aExecAuto   := {}
Local aFields     := {}
Local nx          := 0
Local oResult     := JsonObject():New()
Local cCmpAlter   := GetMv('TI_S56SUS2',,'US_MSBLQL,US_INSCR,US_CNAE,US_CODSEG,US_CEP,US_END,US_XCOMPLE,US_BAIRRO,US_MUN,US_EST,US_EMAIL,US_VEND,US_XGAR,US_XDTNAS') // Campos permitidos para alterar SUS

Default oConta    := nil
Default cErro     := ''

Private lMsErroAuto	:= .F.

If ValType(oConta) == nil
  cErro := 'Não foram enviadas informações sobre a conta'
  Return nil
ElseIf Empty(oConta['US_COD']) .Or. Empty(oConta['US_LOJA'])
  cErro := 'Não foram enviadas informações de identificação da conta'
  Return nil
EndIf

// Campos de identificação
AAdd( aExecAuto, {'US_COD', oConta['US_COD'], nil})
AAdd( aExecAuto, {'US_LOJA', oConta['US_LOJA'], nil})

aFields := oConta:GetNames()
for nx := 1 to Len(aFields)
  If aFields[nx] $ cCmpAlter

    // Campos que precisam de tratamentos
    If TamSX3(aFields[nx])[3] == 'D'
      oConta[aFields[nx]] := StoD(oConta[aFields[nx]])
    EndIf

    AAdd( aExecAuto, {aFields[nx], oConta[aFields[nx]], nil})
  EndIf
next

TMKA260(aExecAuto, 4)

cErro := U_SrvXGetMostraErro()
If !lMsErroAuto .And. Empty(cErro)
  aFields := StrToKArr2(_SUSPERMZ, ',')
  for nx := 1 to Len(aFields)
    oResult[aFields[nx]] := SUS->&(aFields[nx])
  next
EndIf

aExecAuto := nil
aFields := nil
Return oResult

/*/{Protheus.doc} GET 
/ api/crm/contas/v1/suspects
Retorna todos os Suspects

@param	fields		, caracter, Campos que serão retornados no GET.
@param	order		, caracter, Ordenação da tabela principal
@param	page		, numérico, Número da página inicial da consulta
@param	pageSize	, numérico, Número de registro por páginas
@param	filter	, Filtro para busca simples ou no padrão oData

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ListSuspects WSRECEIVE fields, order, page, pageSize, filter  WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local lUserLGA  := .F.
Local lLstCont  := .F.
Local dDataAux  := nil
Local aLstCont  := {}

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Local cHeadMigra  := Lower(AllTrim(httpHeader('integration-migration')))

Default self:fields   := 'ACH_CODIGO,ACH_LOJA,ACH_NFANT'
Default self:order    := 'ACH_FILIAL,ACH_CODIGO,ACH_LOJA'
Default self:page     := 1
Default self:pageSize := 20
Default self:filter   := ''

If !Empty(cHeadMigra) .And. cHeadMigra == 'true'
  self:pageSize := Iif(self:pageSize > 1000, 1000, self:pageSize)
Else
  self:pageSize := Iif(self:pageSize > 50, 50, self:pageSize)
EndIf

Begin Sequence

  //Tratamento para campos passados para o rest
  self:fields := VldCposACH(self:fields, @lUserLGA, @lLstCont)
  
  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .T. ) 
  oDataBase:setPage(self:page)
  oDataBase:setPageSize(self:pageSize)
  oDataBase:SetOrderQuery(self:order)
  oDataBase:SetUrlFilter(self:aQueryString )
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_ACHPERMZ, ',')

  for nx := 1 to Len(aFields)
    If AllTrim(Upper(aFields[nx])) != 'ACH_USERGA' // USERLGA tem tratamento diferenciado
      oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
    EndIf
  next

  //Tratamento específico para o USERLGA - somente usa no filtro pois é retirado da lista de campos
  oDataBase:AddMapFields( "ACH_USERGA" , ;
          "TO_CHAR(TO_DATE('19960101', 'YYYYMMDD')+((ASCII(SUBSTR(ACH_USERGA,12,1))-50)*100+(ASCII(SUBSTR(ACH_USERGA,16,1))-50)))" , ;
          .T., .F., { "ACH_USERGA"  , 'C', 8, 0 } )

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'ACH' ) + " ACH "

  If At('U5_',Upper(self:filter)) > 0 //Se tiver campo da SU5 no filtro
    cQuery += " INNER JOIN " + RetSqlName( 'AC8' ) + " AC8 "
    cQuery += "    ON AC8_FILIAL = '" + xFilial('AC8') + "' "
    cQuery += "   AND AC8_ENTIDA = 'ACH' "
    cQuery += "   AND AC8_CODENT = ACH_CODIGO || ACH_LOJA "
    cQuery += "   AND AC8.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN " + RetSqlName( 'SU5' ) + " SU5 "
    cQuery += "    ON U5_FILIAL = '" + xFilial('SU5') + "' "
    cQuery += "   AND U5_CODCONT = AC8_CODCON "
    cQuery += "   AND SU5.D_E_L_E_T_ = ' ' "    
  EndIf

  cQuery += " WHERE #QueryWhere#"
  cWhere := " ACH_FILIAL = '"+ FWxFilial('ACH') +"' AND ACH.D_E_L_E_T_ = ' '"  
  oDataBase:SetQuery( cQuery )
  oDataBase:SetWhere( cWhere )
  oDataBase:SetOrder( self:order )
  
  //Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
  If oDataBase:Execute()
    // Gera o arquivo Json com o retorno da Query
    oDataBase:FillGetResponse()
  EndIf

  If oDataBase:lOk
    oResponse := JsonObject():New()
    oResponse:fromJson(oDataBase:getJSONResponse())

    For nx := 1 To Len(oResponse["items"])
      //Campo de log de alteração
      If lUserLGA
        ACH->(DBSetOrder(1))
        If ACH->(DbSeek(xFilial('ACH') + Padr(oResponse["items"][nx]["ach_codigo"], TamSx3('ACH_CODIGO')[1]) + Padr(oResponse["items"][nx]["ach_loja"], TamSx3('ACH_LOJA')[1])))
          dDataAux := stod('19960101')+((Asc(Substr(ACH->ACH_USERGA,12,1))-50)*100+(Asc(Substr(ACH->ACH_USERGA,16,1))-50))
          oResponse["items"][nx]["ach_userga"] := AllTrim(Str(Year( dDataAux))) + '-' + AllTrim(StrZero(Month(dDataAux),2)) + '-' + AllTrim(StrZero(Day(dDataAux),2))
        EndIf
      EndIf

      //Lista de contatos
      If lLstCont
        aLstCont := aClone(ListaCont('ACH', Padr(oResponse["items"][nx]["ach_codigo"],TamSX3('ACH_CODIGO')[1]) + Padr(oResponse["items"][nx]["ach_loja"], TamSx3('ACH_LOJA')[1])))
        oResponse["items"][nx]["contatos"] := AClone(aLstCont)
      EndIf
    Next nx
  EndIf

End Sequence

ErrorBlock(oException)

// Verifica errorBlock
If lRet
  // Verifica execução da query
  If oDataBase:lOk
      self:SetResponse(oResponse:toJson())
  Else
    oResponse['code'] := 2 // oDataBase:GetCode()
    oResponse['status'] := 400
    oResponse['message'] := 'Não foi possível realizar o filtro dos registros!'
    oResponse['detailedMessage'] := oDataBase:GetMessage()
    lRet := .F.
  EndIf
Else
  oResponse['code'] := 001
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil
aFields := nil
Return lRet

/*/{Protheus.doc} GET 
/ api/crm/contas/v1/suspects
Retorna um Suspect especifico

@param	id    		, caracter, Codigo do Prospect que deve ser retornado
@param	fields		, caracter, Campos que serão retornados no GET

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ItemSuspects PATHPARAM id WSRECEIVE fields WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local lLstCont  := .F.
Local aLstCont  := {}

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Default self:fields   := _ACHPERMZ + ',contatos'
Default self:id       := ''
Default self:order    := 'ACH_FILIAL,ACH_CODIGO,ACH_LOJA'

Begin Sequence

  //Tratamento para campos passados para o rest
  self:fields := VldCposACH(self:fields,, @lLstCont)

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .F. ) 
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_ACHPERMZ, ',')
  for nx := 1 to Len(aFields)
    oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'ACH' ) + " ACH "
  cQuery += " WHERE #QueryWhere#"

  cWhere := " ACH_FILIAL = '"+ FWxFilial('ACH') +"' AND ACH.D_E_L_E_T_ = ' '"
  If Len(self:id) >= 7
    cWhere += " AND ACH_CODIGO = '" + SubStr(self:id, 0, Len(self:id)-2) + "' "
    cWhere += " AND ACH_LOJA = '" + SubStr(self:id, Len(self:id)-1, 2) + "' "
  Else
    cWhere += " AND ACH_CODIGO = '" + self:id + "' "
  EndIf 
    
  oDataBase:SetQuery( cQuery )
  oDataBase:SetWhere( cWhere )
  oDataBase:SetOrder( self:order )
  
  //Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
  If oDataBase:Execute()
    // Gera o arquivo Json com o retorno da Query
    oDataBase:FillGetResponse()
  EndIf

  If oDataBase:lOk
    oResponse := JsonObject():New()
    oResponse:fromJson(oDataBase:getJSONResponse())

    //Lista de contatos
    If lLstCont
      aLstCont := aClone(ListaCont('ACH', Padr(oResponse["ach_codigo"],TamSX3('ACH_CODIGO')[1]) + Padr(oResponse["ach_loja"], TamSx3('ACH_LOJA')[1])))
      oResponse["contatos"] := AClone(aLstCont)
    EndIf

  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  // Verifica execução da query
  If oDataBase:lOk
    self:SetResponse(oResponse:toJson())
  Else
    oResponse['code'] := 2 // oDataBase:GetCode()
    oResponse['status'] := 400
    oResponse['message'] := 'Não foi possível realizar o filtro dos registros!'
    oResponse['detailedMessage'] := oDataBase:GetMessage()
    lRet := .F.
  EndIf

Else
  oResponse['code'] := 001
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil 
aFields := nil
Return lRet

/*/{Protheus.doc} PUT 
/ api/crm/contas/v1/suspects
Altera um Suspect

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD PUT Suspects PATHPARAM id WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oBody       := JsonObject():New()
Local oDataBase   := JsonObject():New()
Local cBody       := self:GetContent()

Local cErroAuto   := ''
Local cErrBody    := ''
Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })


Begin Sequence

  If !Empty(cErrBody := oBody:fromJson(cBody))
    lRet := .F.
    oResponse['code'] := 4
    oResponse['status'] := 400
    oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
    oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody
  Else

    // Busca conta através do código
    If Empty(self:id) 
      lRet := .F.
      oResponse['code'] := 3
      oResponse['status'] := 400
      oResponse['message'] := 'Deve ser enviado o código + Loja do suspect (ACH_CODIGO+ACH_LOJA)'
      oResponse['detailedMessage'] := 'Verifique se a url está completa com o código + Loja do suspect (ACH_CODIGO+ACH_LOJA).'
    Else

      DbSelectArea("ACH")
      ACH->(DBSetOrder(1)) //ACH_FILIAL+ACH_CODIGO+ACH_LOJA

      If !ACH->(DbSeek(xFilial("ACH")+self:id))
        lRet := .F.
        oResponse['code'] := 2
        oResponse['status'] := 400
        oResponse['message'] := 'O Suspect ' + self:id + ' não existe em nossa base (ACH_CODIGO+ACH_LOJA).'
        oResponse['detailedMessage'] := 'Certifique-se de que o id enviado é de um prospect (ACH_CODIGO+ACH_LOJA).'
      Else

        oBody['ACH_CODIGO'] := ACH->ACH_CODIGO
        oBody['ACH_LOJA'] := ACH->ACH_LOJA

        oDataBase := U_TCSACHAlt(oBody, @cErroAuto)

        If !Empty(cErroAuto)
          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível alterar a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil 
oBody:DeActivate()
oBody := nil 
aFields := nil
Return lRet

/*/{Protheus.doc} POST 
/ api/crm/contas/v1/suspects
Inclui um novo Suspect

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD POST Suspects WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oBody       := JsonObject():New()
Local oDataBase   := JsonObject():New()
Local cBody       := self:GetContent()

Local cErroAuto   := ''
Local cErrBody    := ''
Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })


Begin Sequence

  If !Empty(cErrBody := oBody:fromJson(cBody))
    lRet := .F.
    oResponse['code'] := 4
    oResponse['status'] := 400
    oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
    oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody
  Else
    
    // Valida atributos obrigatorios
    If Empty(oBody['ACH_CGC'])
      lRet := .F.
      oResponse['code'] := 3
      oResponse['status'] := 400
      oResponse['message'] := 'Deve ser enviada a propriedade ACH_CGC com CPF/CNPJ'
      oResponse['detailedMessage'] := 'Verifique se no conteúdo está sendo enviado a propriedade ACH_CGC.'
    Else

      // Busca conta através de CPF/CNPJ
      DbSelectArea("SA1")
      SA1->(DBSetOrder(3)) //A1_FILIAL+A1_CGC
      DbSelectArea("SUS")
      SUS->(DBSetOrder(4)) //US_FILIAL+US_CGC
      DbSelectArea("ACH")
      ACH->(DBSetOrder(2)) //ACH_FILIAL+ACH_CGC

      If SA1->(DbSeek(xFilial("SA1")+oBody['ACH_CGC'])) .Or.;
          SUS->(DbSeek(xFilial("SUS")+oBody['ACH_CGC'])) .Or.;
          ACH->(DbSeek(xFilial("ACH")+oBody['ACH_CGC']))
        lRet := .F.
        oResponse['code'] := 2
        oResponse['status'] := 400
        oResponse['message'] := 'CPF/CNPJ ' + oBody['ACH_CGC'] + ' já existe em nossa base.'
        oResponse['detailedMessage'] := 'Certifique-se de que não exista uma conta com o CPF/CNPJ ' + oBody['ACH_CGC'] + '.'
      Else
        oDataBase := U_TCSACHInc(oBody, @cErroAuto)

        If !Empty(cErroAuto)
          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível incluir a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil 
oBody:DeActivate()
oBody := nil
aFields := nil
Return lRet

/*/{Protheus.doc} TCSACHInc
Inclui um novo Suspect

@param	oConta		, object, Objeto JsonObject() com as propriedades que serão inclusas na conta
Campos obrigatorios neste objeto:
ACH_CGC, ACH_PESSOA, ACH_RAZAO, ACH_END, ACH_CEP, ACH_EST, ACH_CODMUN, ACH_CIDADE, ACH_BAIRRO,
ACH_DDD, ACH_TEL, ACH_XINSCR, ACH_NFANT, ACH_EMAIL, ACH_PAIS, ACH_XUPMSH, ACH_CNAE

@param	cErro      , string , Variavel para receber via referencia, possiveis erros

@return oResult	, object, Retorna o registro incluido na base

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
User Function TCSACHInc(oConta, cErro)

Local aExecAuto   := {}
Local aFields     := {}
Local nx          := 0
Local oResult     := JsonObject():New()
Local cCmpObrig   := GetMv('TI_S56ACH1',,'ACH_CGC,ACH_PESSOA,ACH_RAZAO,ACH_END,ACH_CEP,ACH_EST,ACH_CODMUN,ACH_CIDADE,ACH_BAIRRO,ACH_DDD,ACH_TEL,ACH_XINSCR,ACH_NFANT,ACH_EMAIL,ACH_PAIS,ACH_XUPMSH,ACH_CNAE,ACH_VEND')

Default oConta    := nil
Default cErro     := ''

Private lMsErroAuto	:= .F.

If ValType(oConta) == nil
  cErro := 'Não foram enviadas informações sobre a conta'
  Return nil
EndIf

// Campos obrigatórios
If !TCSVldAtrb(oConta, cCmpObrig)
  cErro := 'As seguintes propriedades são obrigatórias: ' + cCmpObrig
  Return nil
EndIf

// Campos que devem entrar primeiro no array
If !Empty(oConta['ACH_XUPMSH'])
  AAdd( aExecAuto, {'ACH_XUPMSH', oConta['ACH_XUPMSH'], nil}) // When TCRME001, precisa estar antes de alguns campos
EndIf

aFields := oConta:GetNames()
for nx := 1 to Len(aFields)
  If aFields[nx] $ _ACHPERMZ
    AAdd( aExecAuto, {aFields[nx], oConta[aFields[nx]], nil})
  EndIf
next

If U_TSetPapel(@cErro, oConta['ACH_VEND'])
  TMKA341(aExecAuto, 3)

  cErro := U_SrvXGetMostraErro()
  If !lMsErroAuto .And. Empty(cErro)
    aFields := StrToKArr2(_ACHPERMZ, ',')
    for nx := 1 to Len(aFields)
      oResult[aFields[nx]] := ACH->&(aFields[nx])
    next
  EndIf
EndIf

aExecAuto := nil
aFields := nil
Return oResult

/*/{Protheus.doc} TCSACHAlt
Altera um Suspect

@param	oConta		, object, Objeto JsonObject() com as propriedades que serão alteradas na conta

@param	cErro      , string , Variavel para receber via referencia, possiveis erros

@return oResult	, object, Retorna o registro alterado na base

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
User Function TCSACHAlt(oConta, cErro)

Local aExecAuto   := {}
Local aFields     := {}
Local nx          := 0
Local oResult     := JsonObject():New()
Local cCmpAlter   := GetMv('TI_S56ACH2',,'ACH_XINSCR,ACH_CNAE,ACH_CODSEG,ACH_CEP,ACH_END,ACH_BAIRRO,ACH_EST,ACH_CIDADE,ACH_CODMUN,ACH_EMAIL,ACH_VEND,ACH_XGAR,ACH_DDD,ACH_TEL,ACH_PAIS') // Campos permitidos para alterar ACH

Default oConta    := nil
Default cErro     := ''

Private lMsErroAuto	:= .F.

If ValType(oConta) == nil
  cErro := 'Não foram enviadas informações sobre a conta'
  Return nil
ElseIf Empty(oConta['ACH_CODIGO']) .Or. Empty(oConta['ACH_LOJA'])
  cErro := 'Não foram enviadas informações de identificação da conta'
  Return nil
EndIf

// Campos de identificação
AAdd( aExecAuto, {'ACH_CODIGO', oConta['ACH_CODIGO'], nil})
AAdd( aExecAuto, {'ACH_LOJA', oConta['ACH_LOJA'], nil})

aFields := oConta:GetNames()
for nx := 1 to Len(aFields)
  If aFields[nx] $ cCmpAlter
    AAdd( aExecAuto, {aFields[nx], oConta[aFields[nx]], nil})
  EndIf
next

TMKA341(aExecAuto, 4)

cErro := U_SrvXGetMostraErro()
If !lMsErroAuto .And. Empty(cErro)
  aFields := StrToKArr2(_ACHPERMZ, ',')
  for nx := 1 to Len(aFields)
    oResult[aFields[nx]] := ACH->&(aFields[nx])
  next
EndIf

aExecAuto := nil
aFields := nil
Return oResult

/*/{Protheus.doc} GET 
/ api/crm/contas/v1/contatos
Retorna todos os Contatos

@param	fields		, caracter, Campos que serão retornados no GET.
@param	order		, caracter, Ordenação da tabela principal
@param	page		, numérico, Número da página inicial da consulta
@param	pageSize	, numérico, Número de registro por páginas
@param	filter	, Filtro para busca simples ou no padrão oData

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ListContatos WSRECEIVE fields, order, page, pageSize, filter  WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local lUserLGA  := .F.
Local lLstCont  := .F.
Local dDataAux  := nil
Local aLstCont  := {}

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Local cHeadMigra  := Lower(AllTrim(httpHeader('integration-migration')))

Default self:fields   := 'U5_CODCONT,U5_CONTAT,U5_EMAIL'
Default self:order    := 'U5_FILIAL,U5_CODCONT'
Default self:page     := 1
Default self:pageSize := 20
Default self:filter   := ''

If !Empty(cHeadMigra) .And. cHeadMigra == 'true'
  self:pageSize := Iif(self:pageSize > 1000, 1000, self:pageSize)
Else
  self:pageSize := Iif(self:pageSize > 50, 50, self:pageSize)
EndIf

Begin Sequence

  //Tratamento para campos passados para o rest
  self:fields := VldCposSU5(self:fields, @lUserLGA, @lLstCont)

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .T. ) 
  oDataBase:setPage(self:page)
  oDataBase:setPageSize(self:pageSize)
  oDataBase:SetOrderQuery(self:order)
  oDataBase:SetUrlFilter(self:aQueryString )
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SU5PERMZ, ',')
  for nx := 1 to Len(aFields)
    If AllTrim(Upper(aFields[nx])) != 'U5_USERLGA' // USERLGA tem tratamento diferenciado
      oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
    EndIf
  next

  //Tratamento específico para o USERLGA - somente usa no filtro pois é retirado da lista de campos
  oDataBase:AddMapFields( "U5_USERLGA" , ;
          "TO_CHAR(TO_DATE('19960101', 'YYYYMMDD')+((ASCII(SUBSTR(U5_USERLGA,12,1))-50)*100+(ASCII(SUBSTR(U5_USERLGA,16,1))-50)))" , ;
          .T., .F., { "U5_USERLGA"  , 'C', 8, 0 } )

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'SU5' ) + " SU5 "

  If At('A1_',Upper(self:filter)) > 0 //Se tiver campo da SA1 no filtro
    cQuery += " INNER JOIN " + RetSqlName( 'AC8' ) + " AC8 "
    cQuery += "    ON AC8_FILIAL = '" + xFilial('AC8') + "' "
    cQuery += "   AND AC8_ENTIDA = 'SA1' "
    cQuery += "   AND AC8_CODCON = U5_CODCONT "
    cQuery += "   AND AC8.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN " + RetSqlName( 'SA1' ) + " SA1 "
    cQuery += "    ON A1_FILIAL = '" + xFilial('SA1') + "' "
    cQuery += "   AND A1_COD || A1_LOJA = AC8_CODENT "
    cQuery += "   AND SA1.D_E_L_E_T_ = ' ' "    
  EndIf
  If At('US_',Upper(self:filter)) > 0 //Se tiver campo da SUS no filtro
    cQuery += " INNER JOIN " + RetSqlName( 'AC8' ) + " AC8 "
    cQuery += "    ON AC8_FILIAL = '" + xFilial('AC8') + "' "
    cQuery += "   AND AC8_ENTIDA = 'SUS' "
    cQuery += "   AND AC8_CODCON = U5_CODCONT "
    cQuery += "   AND AC8.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN " + RetSqlName( 'SUS' ) + " SUS "
    cQuery += "    ON US_FILIAL = '" + xFilial('SUS') + "' "
    cQuery += "   AND US_COD || US_LOJA = AC8_CODENT "
    cQuery += "   AND SUS.D_E_L_E_T_ = ' ' "    
  EndIf
  If At('ACH_',Upper(self:filter)) > 0 //Se tiver campo da ACH no filtro
    cQuery += " INNER JOIN " + RetSqlName( 'AC8' ) + " AC8 "
    cQuery += "    ON AC8_FILIAL = '" + xFilial('AC8') + "' "
    cQuery += "   AND AC8_ENTIDA = 'ACH' "
    cQuery += "   AND AC8_CODCON = U5_CODCONT "
    cQuery += "   AND AC8.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN " + RetSqlName( 'ACH' ) + " ACH "
    cQuery += "    ON ACH_FILIAL = '" + xFilial('ACH') + "' "
    cQuery += "   AND ACH_CODIGO || ACH_LOJA = AC8_CODENT "
    cQuery += "   AND ACH.D_E_L_E_T_ = ' ' "    
  EndIf

  cQuery += " WHERE #QueryWhere#"
  cWhere := " U5_FILIAL = '"+ FWxFilial('SU5') +"' AND SU5.D_E_L_E_T_ = ' '"  
  oDataBase:SetQuery( cQuery )
  oDataBase:SetWhere( cWhere )
  oDataBase:SetOrder( self:order )
  
  //Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
  If oDataBase:Execute()
    // Gera o arquivo Json com o retorno da Query
    oDataBase:FillGetResponse()
  EndIf

  If oDataBase:lOk
    oResponse := JsonObject():New()
    oResponse:fromJson(oDataBase:getJSONResponse())

    For nx := 1 To Len(oResponse["items"])
      //Campo de log de alteração
      If lUserLGA
        SU5->(DBSetOrder(1))
        If SU5->(DbSeek(xFilial('SU5') + oResponse["items"][nx]["u5_codcont"]))
          dDataAux := stod('19960101')+((Asc(Substr(SU5->U5_USERLGA,12,1))-50)*100+(Asc(Substr(SU5->U5_USERLGA,16,1))-50))
          oResponse["items"][nx]["u5_userlga"] := AllTrim(Str(Year( dDataAux))) + '-' + AllTrim(StrZero(Month(dDataAux),2)) + '-' + AllTrim(StrZero(Day(dDataAux),2))
        EndIf
      EndIf

      //Lista de contatos
      If lLstCont
        aLstCont := aClone(ListaClis(oResponse["items"][nx]["u5_codcont"]))
        If !Empty(aLstCont)
          oResponse["items"][nx]["contas"] := AClone(aLstCont)
        EndIf
      EndIf
    Next nx
  EndIf

End Sequence

ErrorBlock(oException)

// Verifica errorBlock
If lRet
  // Verifica execução da query
  If oDataBase:lOk
      self:SetResponse(oResponse:toJson())
  Else
    oResponse['code'] := 2 // oDataBase:GetCode()
    oResponse['status'] := 400
    oResponse['message'] := 'Não foi possível realizar o filtro dos registros!'
    oResponse['detailedMessage'] := oDataBase:GetMessage()
    lRet := .F.
  EndIf
Else
  oResponse['code'] := 001
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil  
oResponse:DeActivate()
oResponse := nil  
aFields := nil
Return lRet

/*/{Protheus.doc} GET 
/ api/crm/contas/v1/contatos
Retorna um Contato especifico

@param	id    		, caracter, Codigo do Contato que deve ser retornado
@param	fields		, caracter, Campos que serão retornados no GET

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ItemContatos PATHPARAM id WSRECEIVE fields WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Default self:fields   := _SU5PERMZ
Default self:id       := ''
Default self:order    := 'U5_FILIAL,U5_CODCONT'

Begin Sequence

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .F. ) 
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SU5PERMZ, ',')
  for nx := 1 to Len(aFields)
    oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'SU5' ) + " SU5 "
  cQuery += " WHERE #QueryWhere#"

  cWhere := " U5_FILIAL = '"+ FWxFilial('SU5') +"' AND U5_CODCONT = '" + self:id + "' AND SU5.D_E_L_E_T_ = ' '"    

  oDataBase:SetQuery( cQuery )
  oDataBase:SetWhere( cWhere )
  oDataBase:SetOrder( self:order )
  
  //Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
  If oDataBase:Execute()
    // Gera o arquivo Json com o retorno da Query
    oDataBase:FillGetResponse()
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  // Verifica execução da query
  If oDataBase:lOk
      self:SetResponse(oDataBase:getJSONResponse())
  Else
    oResponse['code'] := 2 // oDataBase:GetCode()
    oResponse['status'] := 400
    oResponse['message'] := 'Não foi possível realizar o filtro dos registros!'
    oResponse['detailedMessage'] := oDataBase:GetMessage()
    lRet := .F.
  EndIf

Else
  oResponse['code'] := 001
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil
aFields := nil
Return lRet

/*/{Protheus.doc} PUT 
/ api/crm/contas/v1/contatos
Altera um Contato

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		07/06/2021
@version	1.0
/*/
WSMETHOD PUT Contatos PATHPARAM id WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oBody       := JsonObject():New()
Local oDataBase   := JsonObject():New()
Local cBody       := self:GetContent()

Local cErroAuto   := ''
Local cErrBody    := ''
Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })


Begin Sequence

  If !Empty(cErrBody := oBody:fromJson(cBody))
    lRet := .F.
    oResponse['code'] := 4
    oResponse['status'] := 400
    oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
    oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody
  Else

    // Busca conta através do código
    DbSelectArea("SU5")
    SU5->(DBSetOrder(1)) //U5_FILIAL+U5_CODCONT+U5_IDEXC

    If !SU5->(DbSeek(xFilial("SU5")+self:id))
      lRet := .F.
      oResponse['code'] := 2
      oResponse['status'] := 400
      oResponse['message'] := 'O Contato ' + self:id + ' não existe em nossa base.'
      oResponse['detailedMessage'] := 'Certifique-se de que o id enviado é de um contato.'
    Else
      oBody := TCSUppAtrb(oBody)
      oBody['U5_CODCONT'] := SU5->U5_CODCONT
      oDataBase := U_TCSSU5Alt(oBody, @cErroAuto)

      If !Empty(cErroAuto)
        lRet := .F.
        oResponse['code'] := 5
        oResponse['status'] := 400
        oResponse['message'] := 'Não foi possível alterar o contato em nossa base.'
        oResponse['detailedMessage'] := cErroAuto
      EndIf
    EndIf
    
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil 
oBody:DeActivate()
oBody := nil 
aFields := nil
Return lRet

/*/{Protheus.doc} POST 
/ api/crm/contas/v1/contatos
Inclui um novo Contato

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		07/06/2021
@version	1.0
/*/
WSMETHOD POST Contatos WSSERVICE Contas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oBody       := JsonObject():New()
Local oDataBase   := JsonObject():New()
Local cBody       := self:GetContent()

Local cErroAuto   := ''
Local cErrBody    := ''
Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })


Begin Sequence

  If !Empty(cErrBody := oBody:fromJson(cBody))
    lRet := .F.
    oResponse['code'] := 4
    oResponse['status'] := 400
    oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
    oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody
  Else
    oBody := TCSUppAtrb(oBody)
    oDataBase := U_TCSSU5Inc(oBody, @cErroAuto)

    If !Empty(cErroAuto)
      lRet := .F.
      oResponse['code'] := 5
      oResponse['status'] := 400
      oResponse['message'] := 'Não foi possível incluir o contato em nossa base.'
      oResponse['detailedMessage'] := cErroAuto
    EndIf

    If lRet .And. !Empty(oBody['CODIGO_CONTA']) .And. !Empty(oBody['LOJA_CONTA']) .And. !Empty(oDataBase['U5_CODCONT'])
      If U_TCSAC8Inc(oBody['CODIGO_CONTA'], oBody['LOJA_CONTA'], oDataBase['U5_CODCONT'], @cErroAuto)
        oDataBase['CODIGO_CONTA'] := oBody['CODIGO_CONTA']
        oDataBase['LOJA_CONTA'] := oBody['LOJA_CONTA']
      Else
        lRet := .F.
        oResponse['code'] := 6
        oResponse['status'] := 400
        oResponse['message'] := 'Não foi possível associar o novo contato à conta informada.'
        oResponse['detailedMessage'] := cErroAuto
      EndIf
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
EndIf

If !lRet
  SetRestFault( oResponse['code'],;
                U_EspecMsg(oResponse['message']),;
                .T.,;
                oResponse['status'],;
                U_EspecMsg(oResponse['detailedMessage']);
              )
EndIf

oDataBase:DeActivate()
oDataBase := nil
oResponse:DeActivate()
oResponse := nil 
oBody:DeActivate()
oBody := nil
aFields := nil
Return lRet


/*/{Protheus.doc} TCSVldAtrb
Valida se todos os atributos existem no objeto

@param	oObject		    , object , Objeto tipo JsonObject
@param	cAtributos    , string , atributos separados pr virgula

@return lRet          , logico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		08/10/2020
@version	1.0
/*/
Static Function TCSVldAtrb(oObject, cAtributos)
Local lRet		:= .T.
Local nx      := 0
Local aAtributos  := {}

Default oObject := nil
Default cAtributos := ''

if ValType(oObject) == nil .Or. Empty(cAtributos)
  return .f.
endif

aAtributos := StrToKArr2(cAtributos, ',')

for nx := 1 to Len(aAtributos)
  If Empty(oObject[aAtributos[nx]])
    lRet := .F.
    Exit
  EndIf
next

aAtributos := nil
Return lRet

/*/{Protheus.doc} TCSXXXNum
Rotina para retornar o Proximo código de inicializador padrão
@return cProxNum	, caracter	, Código do inicializador padrão.
@author		Squad Faturamento/CRM
@since		03/12/2020
@version	1.0
/*/
User Function TCSXXXNum(cTab, cCampo)
Local cProxNum := GETSX8NUM(cTab,cCampo)
  While (cTab)->( DbSeek( xFilial(cTab)+cProxNum ) )
    ConfirmSX8()
    cProxNum := GetSXeNum(cTab,cCampo)
  Enddo
Return cProxNum

/*/{Protheus.doc} ListaCont
    Retorna array de objetos json de contato de uma determinada entidade
    @type  Static Function
    @author user
    @since 08/04/2021
    @param cEntidade, caractere, Entidade dos contatos
    @param cChave, caractere, Chave de pesquisa dos contatos
    @return aRet, array, Array de objetos json de contato
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ListaCont(cEntidade, cChaveCont)

  Local aRet        := {}
  Local cAliasCont  := GetNextAlias()
  Local aArea       := GetArea()

  Default cEntidade   := ''
  Default cChaveCont  := ''

  If Select(cAliasCont) > 0
    (cAliasCont)->(DbCloseArea())
  EndIf

  BeginSql Alias cAliasCont

    SELECT U5_CODCONT, U5_CONTAT, U5_EMAIL
      FROM %Table:SU5% SU5
      INNER JOIN %Table:AC8% AC8
        ON AC8_FILIAL = %xFilial:AC8%
        AND AC8_ENTIDA = %exp:cEntidade%
        AND AC8_CODENT = %exp:cChaveCont%
        AND AC8_CODCON = U5_CODCONT
        AND AC8.%NotDel%
      WHERE U5_FILIAL = %xFilial:SU5%
        AND SU5.%NotDel%

  EndSql
    
  While !(cAliasCont)->(Eof())

    aAdd(aRet,JsonObject():New())

    aRet[Len(aRet)]["u5_codcont"] := AllTrim((cAliasCont)->U5_CODCONT)
    aRet[Len(aRet)]["u5_contat"]  := AllTrim((cAliasCont)->U5_CONTAT)
    aRet[Len(aRet)]["u5_email"]   := AllTrim((cAliasCont)->U5_EMAIL)

    (cAliasCont)->(DbSkip())

  EndDo

  (cAliasCont)->(DbCloseArea())

  RestArea(aArea)

Return aRet

/*/{Protheus.doc} VldCposCli
    Retorna lista de campos com tratamentos específicos (gets de cliente)
    @type  Static Function
    @author user
    @since 08/04/2021
    @param cFields, caractere, lista original de campos
    @param lUserLGA, lógico, identifica se tem o campo A1_USERLGA nos fields - passado por referência
    @param lLstCont, lógico, identifica se tem campos de contato nos fields - passado por referência
    @return cRet, caractere, lista modificada de campos
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function VldCposCli(cFields, lUserLGA, lLstCont)

  Local aFields := {}
  Local nX      := 0

  aFields := StrToKArr2(cFields, ',')

  //Trata campos de contato
  While (nx := aScan(aFields, { |_x| Left(Upper(_x),3) == 'U5_' } )) > 0

      lLstCont := .T.
      aDel(aFields, nx)
      aSize(aFields, Len(aFields)-1)

  EndDo

  //Trata campo de alteração
  If (nx := aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'A1_USERLGA' } )) > 0

    lUserLGA := .T.
    aDel(aFields, nx)
    aSize(aFields, Len(aFields)-1)

  EndIf

  //Campo loja é obrigatório para utilização posterior
  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'A1_LOJA' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'A1_LOJA'

  EndIf

  //Campo código é obrigatório para utilização posterior
  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'A1_COD' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'A1_COD'

  EndIf

  cFields := ''

  for nx := 1 To Len(aFields)

    cFields += aFields[nx] + ','

  next nx
  
  cFields := Left(cFields,Len(cFields)-1) //Retira ultima virgula

Return cFields

/*/{Protheus.doc} TCSSU5Inc
Inclui um novo Contato

@param	oContato		, object, Objeto JsonObject() com as propriedades que serão inclusas no contato
Campos obrigatorios neste objeto:
U5_CONTAT,U5_EMAIL

@param	cErro      , string , Variavel para receber via referencia, possiveis erros

@return oResult	, object, Retorna o registro incluido na base

@author		Jose Camilo
@since		07/06/2021
@version	1.0
/*/
User Function TCSSU5Inc(oContato, cErro)

Local aExecAuto   := {}
Local aFields     := {}
Local nx          := 0
Local oResult     := JsonObject():New()
Local cCmpObrig   := GetMv('TI_S56SU51',,'U5_CONTAT,U5_EMAIL')

Default oContato  := nil
Default cErro     := ''

Private lMsErroAuto	:= .F.

If ValType(oContato) == nil
  cErro := 'Não foram enviadas informações sobre o contato'
  Return nil
EndIf

// Campos obrigatórios
If !TCSVldAtrb(oContato, cCmpObrig)
  cErro := 'As seguintes propriedades são obrigatórias: ' + cCmpObrig
  Return nil
EndIf

aFields := oContato:GetNames()
for nx := 1 to Len(aFields)
  If aFields[nx] $ _SU5PERMZ
    // Campos que precisam de tratamentos
    If TamSX3(aFields[nx])[3] == 'D'
      oContato[aFields[nx]] := StoD(oContato[aFields[nx]])
    EndIf

    AAdd( aExecAuto, {aFields[nx], oContato[aFields[nx]], nil})
  EndIf
next

Tmka070(aExecAuto,3,NIL,NIL,.T.)

cErro := U_SrvXGetMostraErro()
If !lMsErroAuto .And. Empty(cErro)
  aFields := StrToKArr2(_SU5PERMZ, ',')
  
  for nx := 1 to Len(aFields)
    oResult[aFields[nx]] := SU5->&(aFields[nx])
  next
EndIf

aExecAuto := nil
aFields := nil
Return oResult

/*/{Protheus.doc} TCSAC8Inc
Inclui um relacionamento entre Contato e Conta

@param	

@param cEntidade  , string , Entidade que será relacionada ao contato (SA1, SUS ou ACH)
@param cCodigo  , string , Código da Entidade
@param cLoja  , string , Loja da Entidade
@param cContato , string , Código do contato que será relacionada a entidade
@param cErro  , string , Parametro para recuperar a mensagem de erro

@return lógico, lógico, Retorna se o relacionamento foi realizado

@author		Jose Camilo
@since		07/06/2021
@version	1.0
/*/
User Function TCSAC8Inc(cCodigo, cLoja, cContato, cErro)

Local cEntidade   := ''
Local cChave      := ''

Default cErro     := ''
Default cCodigo   := ''
Default cLoja     := ''
Default cContato  := ''

If Empty(cContato)
  cErro := 'Para associar um contato a uma conta, é necessário enviar um código de contato'
  Return .F.
EndIf

If Empty(cCodigo) .Or. Empty(cLoja)
  cErro := 'Para associar um contato a uma conta, é necessário enviar código e loja de uma conta'
  Return .F.
EndIf

DbSelectArea("SA1")
SA1->(DBSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA        
DbSelectArea("SUS")
SUS->(DBSetOrder(1)) //US_FILIAL+US_COD+US_LOJA        
DbSelectArea("ACH")
ACH->(DBSetOrder(1)) //ACH_FILIAL+ACH_CODIGO+ACH_LOJA  

If SA1->(DbSeek(xFilial("SA1")+Padr(cCodigo,TamSx3('A1_COD')[1])+Padr(cLoja,TamSx3('A1_LOJA')[1])))
  cEntidade := 'SA1'
  cChave := SA1->A1_COD+SA1->A1_LOJA
ElseIf SUS->(DbSeek(xFilial("SUS")+Padr(cCodigo,TamSx3('US_COD')[1])+Padr(cLoja,TamSx3('US_LOJA')[1])))
  cEntidade := 'SUS'
  cChave := SUS->US_COD+SUS->US_LOJA
ElseIf ACH->(DbSeek(xFilial("ACH")+Padr(cCodigo,TamSx3('ACH_CODIGO')[1])+Padr(cLoja,TamSx3('ACH_LOJA')[1])))
  cEntidade := 'ACH'
  cChave := ACH->ACH_CODIGO+ACH->ACH_LOJA
Else
  cErro := 'O código e loja de conta ' + cCodigo+cLoja + ' não foi encontrado na base para fazer o relacionamento com o contato.'
  Return .F.
EndIf

RecLock('AC8',.T.)
AC8->AC8_FILIAL	:= xFilial('AC8')
AC8->AC8_FILENT	:= xFilial(cEntidade)
AC8->AC8_ENTIDA	:= cEntidade
AC8->AC8_CODENT	:= cChave
AC8->AC8_CODCON	:= cContato
AC8->(MsUnlock())

Return .T.

/*/{Protheus.doc} TCSSU5Alt
Altera um Contato

@param	oContato		, object, Objeto JsonObject() com as propriedades que serão alteradas no contato
Campos obrigatorios neste objeto:
U5_CODCONT

@param	cErro      , string , Variavel para receber via referencia, possiveis erros

@return oResult	, object, Retorna o registro incluido na base

@author		Jose Camilo
@since		07/06/2021
@version	1.0
/*/
User Function TCSSU5Alt(oContato, cErro)

Local aExecAuto   := {}
Local aFields     := {}
Local nx          := 0
Local oResult     := JsonObject():New()
Local cCmpObrig   := 'U5_CODCONT'

Default oContato  := nil
Default cErro     := ''

Private lMsErroAuto	:= .F.

If ValType(oContato) == nil
  cErro := 'Não foram enviadas informações sobre o contato'
  Return nil
EndIf

// Campos obrigatórios
If !TCSVldAtrb(oContato, cCmpObrig)
  cErro := 'As seguintes propriedades são obrigatórias: ' + cCmpObrig
  Return nil
EndIf

aFields := oContato:GetNames()
for nx := 1 to Len(aFields)
  If aFields[nx] $ _SU5PERMZ
    // Campos que precisam de tratamentos
    If TamSX3(aFields[nx])[3] == 'D'
      oContato[aFields[nx]] := StoD(oContato[aFields[nx]])
    EndIf

    AAdd( aExecAuto, {aFields[nx], oContato[aFields[nx]], nil})
  EndIf
next

Tmka070(aExecAuto,4,NIL,NIL,.T.)

cErro := U_SrvXGetMostraErro()
If !lMsErroAuto .And. Empty(cErro)
  aFields := StrToKArr2(_SU5PERMZ, ',')
  
  for nx := 1 to Len(aFields)
    oResult[aFields[nx]] := SU5->&(aFields[nx])
  next
EndIf

aExecAuto := nil
aFields := nil
Return oResult

/*/{Protheus.doc} VldCposSU5
    Retorna lista de campos com tratamentos específicos (gets de prospects)
    @type  Static Function
    @author user
    @since 08/04/2021
    @param cFields, caractere, lista original de campos
    @param lUserLGA, lógico, identifica se tem o campo A1_USERLGA nos fields - passado por referência
    @param lLstCont, lógico, identifica se tem campos de contato nos fields - passado por referência
    @return cRet, caractere, lista modificada de campos
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function VldCposSU5(cFields, lUserLGA, lLstCont)

  Local aFields := {}
  Local nX      := 0

  Default cFields := ''
  Default lUserLGA := .F.
  Default lLstCont := .F.

  aFields := StrToKArr2(cFields, ',')

  //Trata campos de contato
  While (nx := aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'CONTAS' } )) > 0

      lLstCont := .T.
      aDel(aFields, nx)
      aSize(aFields, Len(aFields)-1)

  EndDo

  //Trata campo de alteração
  If (nx := aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'U5_USERLGA' } )) > 0

    lUserLGA := .T.
    aDel(aFields, nx)
    aSize(aFields, Len(aFields)-1)

  EndIf

  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'U5_CODCONT' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'U5_CODCONT'

  EndIf

  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'U5_CONTAT' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'U5_CONTAT'

  EndIf

  cFields := ''

  for nx := 1 To Len(aFields)

    cFields += aFields[nx] + ','

  next nx
  
  cFields := Left(cFields,Len(cFields)-1) //Retira ultima virgula

Return cFields

/*/{Protheus.doc} ListaClis
    Retorna array de objetos json de contato de uma determinada entidade
    @type  Static Function
    @author user
    @since 08/04/2021
    @param cEntidade, caractere, Entidade dos contatos
    @param cChave, caractere, Chave de pesquisa dos contatos
    @return aRet, array, Array de objetos json de contato
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ListaClis(cChaveCont)

  Local aRet        := {}
  Local cAliasCont  := GetNextAlias()
  Local aArea       := GetArea()

  Default cChaveCont  := ''

  If Select(cAliasCont) > 0
    (cAliasCont)->(DbCloseArea())
  EndIf

  BeginSql Alias cAliasCont

    SELECT U5_CODCONT, A1_COD, A1_LOJA, US_COD, US_LOJA, ACH_CODIGO, ACH_LOJA
      FROM %Table:SU5% SU5
      INNER JOIN %Table:AC8% AC8
        ON AC8_FILIAL = %xFilial:AC8%
        AND AC8_CODCON = U5_CODCONT
        AND AC8.%NotDel%
      LEFT JOIN %Table:SA1% SA1
        ON A1_FILIAL = %xFilial:SA1%
        AND A1_COD || A1_LOJA = AC8_CODENT
        AND SA1.%NotDel%
        AND AC8_ENTIDA = 'SA1'
      LEFT JOIN %Table:SUS% SUS
        ON US_FILIAL = %xFilial:SUS%
        AND US_COD || US_LOJA = AC8_CODENT
        AND SUS.%NotDel%
        AND AC8_ENTIDA = 'SUS'
      LEFT JOIN %Table:ACH% ACH
        ON ACH_FILIAL = %xFilial:ACH%
        AND ACH_CODIGO || ACH_LOJA = AC8_CODENT
        AND ACH.%NotDel%      
        AND AC8_ENTIDA = 'ACH'
      WHERE U5_FILIAL = %xFilial:SU5%
        AND U5_CODCONT = %exp:cChaveCont%
        AND SU5.%NotDel%

  EndSql
    
  While !(cAliasCont)->(Eof())

    If !Empty((cAliasCont)->A1_COD)
      aAdd(aRet,JsonObject():New())

      aRet[Len(aRet)]["entidade"] := 'SA1'
      aRet[Len(aRet)]["codigo"] := AllTrim((cAliasCont)->A1_COD)
      aRet[Len(aRet)]["loja"] := AllTrim((cAliasCont)->A1_LOJA)
    EndIf

    If !Empty((cAliasCont)->US_COD)
      aAdd(aRet,JsonObject():New())

      aRet[Len(aRet)]["entidade"] := 'SUS'
      aRet[Len(aRet)]["codigo"] := AllTrim((cAliasCont)->US_COD)
      aRet[Len(aRet)]["loja"] := AllTrim((cAliasCont)->US_LOJA)
    EndIf

    If !Empty((cAliasCont)->ACH_CODIGO)
      aAdd(aRet,JsonObject():New())

      aRet[Len(aRet)]["entidade"] := 'ACH'
      aRet[Len(aRet)]["codigo"] := AllTrim((cAliasCont)->ACH_CODIGO)
      aRet[Len(aRet)]["loja"] := AllTrim((cAliasCont)->ACH_LOJA)
    EndIf

    (cAliasCont)->(DbSkip())

  EndDo

  (cAliasCont)->(DbCloseArea())

  RestArea(aArea)

Return aRet

/*/{Protheus.doc} VldCposSUS
    Retorna lista de campos com tratamentos específicos (gets de prospects)
    @type  Static Function
    @author user
    @since 08/04/2021
    @param cFields, caractere, lista original de campos
    @param lUserLGA, lógico, identifica se tem o campo A1_USERLGA nos fields - passado por referência
    @param lLstCont, lógico, identifica se tem campos de contato nos fields - passado por referência
    @return cRet, caractere, lista modificada de campos
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function VldCposSUS(cFields, lUserLGA, lLstCont)

  Local aFields := {}
  Local nX      := 0

  Default cFields := ''
  Default lUserLGA := .F.
  Default lLstCont := .F.

  aFields := StrToKArr2(cFields, ',')

  //Trata campos de contato
  If (nx := aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'CONTATOS' } )) > 0

      lLstCont := .T.
      aDel(aFields, nx)
      aSize(aFields, Len(aFields)-1)

  EndIf

  //Trata campo de alteração
  If (nx := aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'US_USERLGA' } )) > 0

    lUserLGA := .T.
    aDel(aFields, nx)
    aSize(aFields, Len(aFields)-1)

  EndIf

  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'US_LOJA' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'US_LOJA'

  EndIf

  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'US_COD' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'US_COD'

  EndIf

  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'US_NOME' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'US_NOME'

  EndIf

  cFields := ''

  for nx := 1 To Len(aFields)

    cFields += aFields[nx] + ','

  next nx
  
  cFields := Left(cFields,Len(cFields)-1) //Retira ultima virgula

Return cFields

/*/{Protheus.doc} VldCposACH
    Retorna lista de campos com tratamentos específicos (gets de suspects)
    @type  Static Function
    @author user
    @since 08/04/2021
    @param cFields, caractere, lista original de campos
    @param lUserLGA, lógico, identifica se tem o campo A1_USERLGA nos fields - passado por referência
    @param lLstCont, lógico, identifica se tem campos de contato nos fields - passado por referência
    @return cRet, caractere, lista modificada de campos
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function VldCposACH(cFields, lUserLGA, lLstCont)

  Local aFields := {}
  Local nX      := 0

  Default cFields := ''
  Default lUserLGA := .F.
  Default lLstCont := .F.

  aFields := StrToKArr2(cFields, ',')

  //Trata campos de contato
  If (nx := aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'CONTATOS' } )) > 0

      lLstCont := .T.
      aDel(aFields, nx)
      aSize(aFields, Len(aFields)-1)

  EndIf

  //Trata campo de alteração
  If (nx := aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'ACH_USERGA' } )) > 0

    lUserLGA := .T.
    aDel(aFields, nx)
    aSize(aFields, Len(aFields)-1)

  EndIf

  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'ACH_LOJA' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'ACH_LOJA'

  EndIf

  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'ACH_CODIGO' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'ACH_CODIGO'

  EndIf

  If aScan(aFields, { |_x| AllTrim(Upper(_x)) == 'ACH_RAZAO' }) <= 0

    aSize(aFields,Len(aFields)+1)
    aIns(aFields,1)
    aFields[1] := 'ACH_RAZAO'

  EndIf

  cFields := ''

  for nx := 1 To Len(aFields)

    cFields += aFields[nx] + ','

  next nx
  
  cFields := Left(cFields,Len(cFields)-1) //Retira ultima virgula

Return cFields


/*/{Protheus.doc} GET 
/api/crm/contas/v1/validainclead/{cpfcnpj}
Valida a inclusão de um lead

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		alexandre.bueno
@since		14/06/2021
@version	1.0
/*/
WSMETHOD GET ValidaIncLead WSSERVICE Contas

  Local lRet			  := .T.
  Local oResponse   := JsonObject():New()
  Local aHelp       := {}
  Local cEntidade   := ""
  Local cDescEnt    := ""
  Local cSegmento   := ""
  Local aAuxTerr    := {}
  Local aTerritory  := {}
  Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })
  Local cErroBlk    := ''

  //Parâmetros via Header
  Local cCpfCnpj    := AllTrim(httpHeader('integration-cnpj'))
  Local cTipoLead   := AllTrim(httpHeader('integration-tipoLead'))
  Local cCodVend    := AllTrim(httpHeader('integration-codVend'))
  Local cCEP        := AllTrim(httpHeader('integration-cep'))
  Local cCNAE       := AllTrim(httpHeader('integration-cnae'))
  Local nValFat     := Val(AllTrim(httpHeader('integration-valfat')))
  Local cPais       := AllTrim(httpHeader('integration-pais'))

  Begin Sequence

    //Verifica envio de parâmetros obrigatórios comuns
    If Empty(cCpfCnpj)

      oResponse['code'] := 1
      oResponse['status'] := 400
      oResponse['message'] := 'CPF/CNPJ do lead não foi informado!'
      oResponse['detailedMessage'] := 'Informe o CPF/CNPJ do lead no parâmetro integration-cnpj do header da chamada'
      lRet  := .F.

    //Verifica envio do parâmetro de tipo de lead
    ElseIf Empty(cTipoLead)

      oResponse['code'] := 1
      oResponse['status'] := 400
      oResponse['message'] := 'Tipo do lead não foi informado!'
      oResponse['detailedMessage'] := 'Informe o tipo do lead no parâmetro integration-tipoLead do  header da chamada (1=suspect, 2=prospect)'
      lRet  := .F.

    //Verifica envio do parâmetro de tipo de lead
    ElseIf Empty(cCodVend)

      oResponse['code'] := 1
      oResponse['status'] := 400
      oResponse['message'] := 'Código do vendedor não foi informado!'
      oResponse['detailedMessage'] := 'Informe o código do vendedor no parâmetro integration-codVend do header da chamada'
      lRet  := .F.

    //Se passar CNAE verifica se está correto
    Else
    
      If Empty(cCNAE)

        oResponse['code'] := 1
        oResponse['status'] := 400
        oResponse['message'] := 'Código do CNAE não foi informado!'
        oResponse['detailedMessage'] := 'Informe o código do CNAE no parâmetro integration-cnae do header da chamada'
        lRet  := .F.

      Else

        cCNAE  := AllTrim(cCNAE)

        CC3->(DbSetOrder(1))
        If CC3->(DbSeek(xFilial('CC3') + cCNAE))

          cSegmento := CC3->CC3_CODSEG

        Else

          oResponse['code'] := 1
          oResponse['status'] := 400
          oResponse['message'] := 'CNAE informado não existe!'
          oResponse['detailedMessage'] := 'O código CNAE informado (' + cCNAE + ') não existe na base de dados do Protheus.'
          lRet  := .F.

        EndIf

      EndIf

    EndIf

    //Verifica envio de parâmetros obrigatórios para suspect
    If cTipoLead == "1"

      If Empty(cCEP)

        oResponse['code'] := 1
        oResponse['status'] := 400
        oResponse['message'] := 'Código do CEP não foi informado!'
        oResponse['detailedMessage'] := 'O CEP é obrigatório para validação de suspects. Informe o código do CEP no parâmetro integration-cep do header da chamada'
        lRet  := .F.

      //Verifica envio do parâmetro de tipo de lead
      ElseIf Empty(cPais)

        oResponse['code'] := 1
        oResponse['status'] := 400
        oResponse['message'] := 'Código do país não foi informado!'
        oResponse['detailedMessage'] := 'O país é obrigatório para validação de suspects. Informe o código do país no parâmetro integration-pais do header da chamada'
        lRet  := .F.

      //Verifica envio do parâmetro de tipo de lead
      ElseIf nValFat <= 0

        oResponse['code'] := 1
        oResponse['status'] := 400
        oResponse['message'] := 'Valor de faturamento inválido!'
        oResponse['detailedMessage'] := 'O faturamento é obrigatório para validação de suspects. Informe um valor de faturamento anual válido (positivo e maior que zero) no parâmetro integration-valfat do header da chamada.'
        lRet  := .F.

      EndIf

    EndIf

    //Verifica se o ledd já existe na base
    If lRet

      cCpfCnpj := AllTrim(cCpfCnpj)
      cCpfCnpj := StrTran(cCpfCnpj,'.','')
      cCpfCnpj := StrTran(cCpfCnpj,'-','')
      cCpfCnpj := StrTran(cCpfCnpj,'/','')

      cCodVend  := AllTrim(cCodVend)
      cCEP  := AllTrim(cCEP)

      SA1->(DBSetOrder(3))

      If SA1->(Dbseek(xFilial('SA1') + cCpfCnpj))

        oResponse['code'] := 1
        oResponse['status'] := 400
        oResponse['message'] := 'CPF/CNPJ do lead já existe no cadastro de clientes!'
        oResponse['detailedMessage'] := 'Não é permitido incluir leads que já existam no Protheus.'
        lRet := .F.

      Else

        SUS->(DBSetOrder(4))

        If SUS->(Dbseek(xFilial('SUS') + cCpfCnpj))

          oResponse['code'] := 1
          oResponse['status'] := 400
          oResponse['message'] := 'CPF/CNPJ do lead já existe no cadastro de prospects!'
          oResponse['detailedMessage'] := 'Não é permitido incluir leads que já existam no Protheus.'
          lRet := .F.

        Else

          ACH->(DBSetOrder(2))

          If ACH->(Dbseek(xFilial('ACH') + cCpfCnpj))

            oResponse['code'] := 1
            oResponse['status'] := 400
            oResponse['message'] := 'CPF/CNPJ do lead já existe no cadastro de suspects!'
            oResponse['detailedMessage'] := 'Não é permitido incluir leads que já existam no Protheus.'
            lRet := .F.

          EndIf

        EndIf

      EndIf

    EndIf

    If lRet //Lead novo - valida vendedor

      SA3->(DbSetOrder(1))

      If !SA3->(DbSeek(xFilial('SA3') + cCodVend))

            oResponse['code'] := 1
            oResponse['status'] := 400
            oResponse['message'] := 'Vendedor não cadastrado!'
            oResponse['detailedMessage'] := 'O código de vendedor informado não existe no Protheus.'
            lRet := .F.

      Else

        //Bloqueio
        If SA3->A3_MSBLQL == '1'

            oResponse['code'] := 1
            oResponse['status'] := 400
            oResponse['message'] := 'Vendedor bloqueado!'
            oResponse['detailedMessage'] := 'O código de vendedor informado está bloqueado no Protheus.'
            lRet := .F.

        Else

          //Estrutura
          AZS->(DbSetOrder(4))

          If !AZS->(DbSeek(xFilial('AZS') + cCodVend))

            oResponse['code'] := 1
            oResponse['status'] := 400
            oResponse['message'] := 'Vendedor não está na estrutura de vendas!'
            oResponse['detailedMessage'] := 'O código de vendedor informado não está na estrutura de vendas no Protheus.'
            lRet := .F.
    
          Else

            //Seta papel de vendas
            CRMXSetPaper(AZS->AZS_CODUSR+AZS->AZS_SEQUEN+AZS->AZS_PAPEL)

          EndIf

        EndIf

      EndIf

    EndIf

    If lRet //Lead novo e vendedor válido - validações adicionais do CRM

      If cTipoLead == "1" //Suspect

        cEntidade := "ACH"
        cDescEnt  := "suspect"

      Else

        cEntidade := "SUS"
        cDescEnt  := "prospect"

      EndIf

      //Verifica limite de quantidade do vendedor
      If !(lRet := U_TCRMX25L(cEntidade, cDescEnt, aHelp))

        oResponse['code'] := 1
        oResponse['status'] := 400
        oResponse['message'] := 'Vendedor excedeu limite de contas!'
        oResponse['detailedMessage'] := If(!Empty(aHelp),aHelp[1],'Vendedor excedeu limite de contas!')
        lRet := .F.

      //Próximas validações dependem do CNAE/Segmento
      ElseIf !Empty(cSegmento)

        //Verifica segmento do cliente
        If !(lRet := U_TCRMX008(cEntidade, "", "", cCodVend, cSegmento))

          oResponse['code'] := 1
          oResponse['status'] := 400
          oResponse['message'] := 'Vendedor x segmento inválido!'
          oResponse['detailedMessage'] := 'O vendedor informado não tem permissão para atuar neste segmento !'
          lRet := .F.

        ElseIf cTipoLead == "1"  //Validação de rodízio só é exigida para suspect 

          M->ACH_CGC    := cCpfCnpj
          M->ACH_CNAE   := cCNAE
          M->ACH_CODSEG := cSegmento
          M->ACH_FATANU := nValFat
          M->ACH_PAIS   := cPais

          aAuxTerr := CRMA690EvalTerritory("TMKA341","ACH",.F.,.F.)

          If (Len(aAuxTerr) > 0 .And. !Empty(aAuxTerr[2]))
            // Realiza chamada como simulação
            aTerritory := CRMA690CasterTerritory("TMKA341", "ACH", ""/*aAuxTerr[2]*/,, .T.)

            If Len(aTerritory) > 1 .And. ValType(aTerritory[2]) == "C"

              If !(lRet := U_TMKA341T(aTerritory[2], SA3->A3_UNIDAD, SA3->A3_COD,cPais))

                oResponse['code'] := 1
                oResponse['status'] := 400
                oResponse['message'] := 'Regra de rodízio.'
                oResponse['detailedMessage'] := 'O vendedor não tem permissão para vender no território ' + aTerritory[2] + '.'
                lRet := .F.

              EndIf

            EndIf

          Endif

        EndIf

      EndIf

    EndIf

  End Sequence

  ErrorBlock(oException)

  If !Empty(cErroBlk)

    oResponse['code'] := 2
    oResponse['status'] := 500
    oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
    oResponse['detailedMessage'] := cErroBlk

  EndIf

  //Retorno
  If lRet

    oResponse['code'] := 0
    oResponse['message'] := 'Lead liberado para inclusão.'

    self:SetResponse(oResponse:toJson())

  Else

    SetRestFault( oResponse['code'],;
                  oResponse['message'],;
                  .T.,;
                  oResponse['status'],;
                  oResponse['detailedMessage'];
                )

  EndIf

  oResponse:DeActivate()
  oResponse := nil

Return lRet

/*/{Protheus.doc} POST 
/api/crm/contas/v1/validacoes/emails
Valida um ou mais e-mails

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		alexandre.bueno
@since		17/06/2021
@version	1.0
/*/
WSMETHOD POST ValidaEmail WSSERVICE Contas

  Local lRet			  := .T.
  Local oResponse   := JsonObject():New()
  Local oBody       := JsonObject():New()
  Local cBody       := self:GetContent()
  Local nLoop, nx   := 0
  Local cMensagem   := ""
  Local cEmailsInv  := ""
  Local lVldMail    := .T.
  Local cStatusVal  := GetMv("TI_SFTMSTV",,"VALIDO;PENDENTE;LIMITADO;DESCONHECIDO;INCERTO") //Status de retorno SafetyMail considerados válidos 
  Local aDominBlk   := StrTokArr2(GetMv("TI_DOMIBLK",,"@totvs;@totvspartners;@fluig;@fluigpartners"),";") //Domínios que não são permitidos

  Local aNames      := {}
  Local cErrBody    := ''
  Local cErroBlk    := ''
  Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

  Begin Sequence

    //Valida JSON enviado
    If !Empty(cErrBody := oBody:fromJson(cBody))  

      lRet := .F.
      oResponse['code'] := 1
      oResponse['status'] := 400
      oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
      oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody

    Else

      aNames := oBody:GetNames()

      //Valida estrutura do JSON
      If aScan(aNames, "emails") <= 0

        lRet := .F.
        oResponse['code'] := 2
        oResponse['status'] := 400
        oResponse['message'] := 'Atributo "emails" inválido.'
        oResponse['detailedMessage'] := 'O atributo "emails" não foi informado ou não é um array. Verifique o conteúdo do JSON.'

      ElseIf Empty(oBody['emails'])

        lRet := .F.
        oResponse['code'] := 3
        oResponse['status'] := 400
        oResponse['message'] := 'Atributo "emails" vazio.'
        oResponse['detailedMessage'] := 'O atributo "emails" não possui e-mails a serem validados.'

      EndIf

    EndIf

    If lRet

      oResponse['emails'] := {}

      //Validação dos e-mails
      For nLoop := 1 To Len(oBody['emails'])
        lVldMail := .T.
        cMensagem := ''

        aAdd(oResponse['emails'], JsonObject():New())

        // Validação interna de formato
        If !isEmail(oBody["emails"][nLoop])
          lVldMail := .F.
          cMensagem := 'Formato de E-mail inválido'
        EndIf
        
        // Validação interna de dominios
        If lVldMail
          for nx := 1 to Len(aDominBlk)
            If aDominBlk[nx] $ oBody["emails"][nLoop]
              lVldMail := .F.
              cMensagem := 'E-mail com domínio '+aDominBlk[nx]+' não é permitido'
            EndIf
          next
        EndIf

        // Validação com SafetyMail
        If lVldMail
          lVldMail := U_TCRM56SM(oBody["emails"][nLoop], @cMensagem)
          lVldMail := lVldMail .And. Upper(AllTrim(cMensagem)) $ cStatusVal
        EndIf

        //Montagem do retorno
        oResponse['emails'][Len(oResponse['emails'])]["email"] := oBody["emails"][nLoop]
        oResponse['emails'][Len(oResponse['emails'])]["message"] := cMensagem
        oResponse['emails'][Len(oResponse['emails'])]["valid"] := lVldMail

        //Acrescenta lista de e-mails inválidos se necessário
        If !lVldMail
          cEmailsInv += oBody["emails"][nLoop] + ", "
        EndIf

      Next nLoop

      cEmailsInv := AllTrim(cEmailsInv)

      If Right(cEmailsInv,1) == ','
        cEmailsInv := Left(cEmailsInv, Len(cEmailsInv) - 1)
      EndIf

      //Mensagem de retorno
      If Empty(cEmailsInv)

        oResponse['message'] := U_EspecMsg("Email(s) válido(s)")

      Else

        oResponse['message'] := U_EspecMsg("O(s) email(s) " + cEmailsInv + If(At(',',cEmailsInv) <= 0," é ", " são ") + "inválido(s).")

      EndIf

    EndIf

  End Sequence

  ErrorBlock(oException)

  //Retorno Ok
  If lRet
    
    self:SetResponse( oResponse:toJson() )
  
  //Erro de programa
  ElseIf !Empty(cErroBlk)
    oResponse['code'] := 1
    oResponse['status'] := 500
    oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
    oResponse['detailedMessage'] := cErroBlk
  EndIf

  //Erro de regra do WS
  If !lRet
    SetRestFault( oResponse['code'],;
                  U_EspecMsg(oResponse['message']),;
                  .T.,;
                  oResponse['status'],;
                  U_EspecMsg(oResponse['detailedMessage']);
                )
  EndIf

  oResponse:DeActivate()
  oResponse := nil 
  oBody:DeActivate()
  oBody := nil

Return lRet

/*/{Protheus.doc} TCRM56SM
Faz consulta de e-mail no SafetyMail 

@param cEmail, caractere, e-mail a ser validado
@param cMensagem, caractere, mensagem de retorno do serviço SafetyMail (passada por referência)
@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		alexandre.bueno
@since		17/06/2021
@version	1.0
/*/
User Function TCRM56SM(cEmail, cMensagem)

  Local lRet          := .T.
  Local cEmail64      := ""
  Local cSFTMURL      := GetMv("TI_SFTMURL",,"https://optin.safetymails.com/main/safetyrt") //ULR da SafetyMail, inclusive o comanto safetyrt
  Local cSFTMAPIKey	  := GetMv("TI_SFTMAPI",,"df439e44949ef060790d7a4945f6132716884c18") // API Key da SafetyMail
  Local cSFTMTktOri		:= GetMv("TI_SFTMTKT",,"934ff191e39ef69522d1768b4b8366d9758d8b71") //Ticket Origem da SafetyMail
  Local aHeader       := {}
  Local oJsonRet      := JsonObject():New()
  Local cErrJson      := ""
  Local aNames        := {}
  Local oRest

  If Right(cSFTMURL,1) == '/'
    cSFTMURL := Left(cSFTMURL, Len(cSFTMURL) - 1)
  EndIf

  //Passa para base64 antes do envio
  cEmail64  := Encode64( cEmail )

  AAdd(aHeader, 'Content-Type:application/json')
  AAdd(aHeader, 'accept: */*')

  oRest:= FWREST():New( cSFTMURL )
  oRest:SetPath('/' + cSFTMAPIKey + '/' + cSFTMTktOri + '/' + cEmail64)

  If (lRet := oRest:Get(aHeader))

    //Validação de formato de retorno 
    If !Empty(cErrJson := oJsonRet:fromJson(oRest:GetResult()))

      lRet := .F.
      cMensagem := "Retorno inválido do Safety Mail"

    Else

      //Validação de estrutura do JSON
      aNames := oJsonRet:GetNames()

      If aScan(aNames, "StatusEmail") <= 0

        lRet := .F.
        cMensagem := "Retorno inválido do Safety Mail"

      Else //Retorno com formato correto

        cMensagem := oJsonRet['StatusEmail']

      EndIf

    EndIf

  Else //Erro no momento do GET

    cMensagem := oRest:oResponseH:cStatusCode + " / " + oRest:GetLastError()

  EndIf

Return lRet
