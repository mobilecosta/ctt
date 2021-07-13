#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

Static _SA3PERMA := GetMv('TI_CPPSA3A',,'A3_FILIAL,A3_COD,A3_NOME,A3_END,A3_BAIRRO,A3_MUN,A3_EST,A3_CEP,A3_DDDTEL,A3_TEL,A3_MSBLQL,A3_CGC,A3_EMAIL,A3_UNIDAD,A3_CARGO,A3_XGAR,A3_XAGN,A3_XCC,A3_XLOGIN') // Campos permitidos para retorno SA3
Static _SA3PERMB := GetMv('TI_CPPSA3B',,'') // Campos permitidos para retorno SA3
Static _ADKPERMA := GetMv('TI_CPPADKA',,'ADK_FILIAL,ADK_COD,ADK_NOME,ADK_CNPJ,ADK_TIPO,ADK_RESP,ADK_END,ADK_BAIRRO,ADK_MUN,ADK_EST,ADK_PAIS,ADK_CEP,ADK_DDI,ADK_DDD,ADK_TEL,ADK_EMAIL,ADK_XDAR,ADK_XSUPER,ADK_MSBLQL,ADK_XPROPR,ADK_XTPEXC,ADK_XCODAN,ADK_XTGARE') // Campos permitidos para retorno ADK
Static _ADKPERMB := GetMv('TI_CPPADKB',,'') // Campos permitidos para retorno ADK
Static _SA2PERMA := GetMv('TI_CPPSA2A',,'A2_COD,A2_LOJA,A2_NOME,A2_NREDUZ,A2_END,A2_EST,A2_TIPO,A2_CGC,A2_PAIS,A2_CONTA,A2_PAIS,A2_COD_MUN,A2_CEP,A2_DDI,A2_DDD,A2_TEL') // Campos permitidos para retorno SA2
Static _SA2PERMB := GetMv('TI_CPPSA2B',,'') // Campos permitidos para retorno SA2

Static _SA3PERMZ := AllTrim(_SA3PERMA) + ',' + AllTrim(_SA3PERMB)
Static _ADKPERMZ := AllTrim(_ADKPERMA) + ',' + AllTrim(_ADKPERMB)
Static _SA2PERMZ := AllTrim(_SA2PERMA) + ',' + AllTrim(_SA2PERMB)

/*/{Protheus.doc} TCRMS064
Dummy Function
@author Jose Camilo
@since 02/06/2021
@version 1.0
/*/
User Function TCRMS064()
return .T.

/*/{Protheus.doc} Vendas

API de integração em Vendas

@param	fields	, Campos, separados por virgula, que serão retornados nos objetos Ex: /?fields=regra,tipo,valor
@param	filter	, Filtro para busca, no modo chave=valor ou no padrão oData Ex:  /?regra=000039&tipo=1 ou /?filter=regra eq '000039'
@param	order		, Campos para ordenação da busca, separados por virgula  Ex: /?order=regra,tipo
@param	page		, Número da página que deve retornar
@param	pageSize	, Número de registros por páginas

@author		Jose Camilo
@since		29/09/2020
/*/
WSRESTFUL Vendas DESCRIPTION 'Integração em Vendas'

  WSDATA fields     AS STRING	OPTIONAL
	WSDATA order			AS STRING	OPTIONAL
	WSDATA page				AS INTEGER	OPTIONAL
	WSDATA pageSize   AS INTEGER	OPTIONAL
	WSDATA id	        AS STRING	OPTIONAL
  WSDATA filter     AS STRING	OPTIONAL
  WSDATA ano        AS INTEGER	OPTIONAL
  WSDATA dateUpdate AS INTEGER	OPTIONAL
 
  WSMETHOD GET ListVendedores ;
    DESCRIPTION 'Lista de Vendedores' ;
    WSSYNTAX '/api/crm/vendas/v1/vendedores/?{fields, order, page, pageSize, filter}' ;
    PATH '/api/crm/vendas/v1/vendedores' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON
  
  WSMETHOD POST Vendedor ;
    DESCRIPTION 'Grava Vendedor' ;
    WSSYNTAX '/api/crm/vendas/v1/vendedores' ;
    PATH '/api/crm/vendas/v1/vendedores' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

	WSMETHOD GET ItemVendedores ;
    DESCRIPTION 'Devolve um Vendedor específico' ;
    WSSYNTAX '/api/crm/vendas/v1/vendedores/{id}/?{fields}' ;
    PATH '/api/crm/vendas/v1/vendedores/{id}'	;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON
  
  WSMETHOD GET ListUnidades ;
    DESCRIPTION 'Lista de Unidades' ;
    WSSYNTAX '/api/crm/vendas/v1/unidades/?{fields, order, page, pageSize, filter}' ;
    PATH '/api/crm/vendas/v1/unidades' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD PUT Unidades ;
    DESCRIPTION 'Altera uma Unidade' ;
    WSSYNTAX '/api/crm/vendas/v1/unidades/{id}/?{body}' ;
    PATH '/api/crm/vendas/v1/unidades/{id}' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD POST Unidades ;
    DESCRIPTION 'Inclui uma nova Unidade' ;
    WSSYNTAX '/api/crm/vendas/v1/unidades/?{body}' ;
    PATH '/api/crm/vendas/v1/unidades' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

	WSMETHOD GET ItemUnidades ;
    DESCRIPTION 'Devolve uma Unidade específica' ;
    WSSYNTAX '/api/crm/vendas/v1/unidades/{id}/?{fields}' ;
    PATH '/api/crm/vendas/v1/unidades/{id}'	;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON
 
  WSMETHOD POST Distribuicao;
    DESCRIPTION 'Distribuicao da conta por rodizio para o territorio vencedor' ;
    WSSYNTAX '/api/crm/vendas/v1/distribuicao/' ;
    PATH '/api/crm/vendas/v1/distribuicao';
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD POST Fornecedor;
    DESCRIPTION 'Inclui um novo fornecedor' ;
    WSSYNTAX '/api/crm/vendas/v1/fornecedores' ;
    PATH '/api/crm/vendas/v1/fornecedores';
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

  WSMETHOD GET ListMetasAno ;
    DESCRIPTION 'Lista Metas de Vendas do CRM por ano' ;
    WSSYNTAX '/api/crm/vendas/v1/metas/{ano}/?{page,pageSize,dateUpdate}' ;
    PATH '/api/crm/vendas/v1/metas/{ano}'	;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

ENDWSRESTFUL

/*/{Protheus.doc} GET
  / api/crm/vendas/v1/vendedores
Retorna todos os Vendedores

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
WSMETHOD GET ListVendedores WSRECEIVE fields, order, page, pageSize, filter  WSSERVICE Vendas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Local cHeadMigra  := Lower(AllTrim(httpHeader('integration-migration')))

Default self:fields   := 'A3_COD,A3_NOME,A3_EMAIL'
Default self:order    := 'A3_FILIAL,A3_COD'
Default self:page     := 1
Default self:pageSize := 20

If !Empty(cHeadMigra) .And. cHeadMigra == 'true'
  self:pageSize := Iif(self:pageSize > 1000, 1000, self:pageSize)
Else
  self:pageSize := Iif(self:pageSize > 50, 50, self:pageSize)
EndIf

Begin Sequence

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .T. ) 
  oDataBase:setPage(self:page)
  oDataBase:setPageSize(self:pageSize)
  oDataBase:SetOrderQuery(self:order)
  oDataBase:SetUrlFilter(self:aQueryString )
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SA3PERMZ, ',')
  for nx := 1 to Len(aFields)
    oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'SA3' ) + " SA3 "
  cQuery += " WHERE #QueryWhere#"
  cWhere := " A3_FILIAL = '"+ FWxFilial('SA3') +"' AND SA3.D_E_L_E_T_ = ' '"  
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

// Verifica errorBlock
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

/*/{Protheus.doc} POST
  / api/crm/vendas/v1/vendedor
Inclui um Vendedor

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Moisés Osti
@since		08/12/2020
@version	1.0
/*/
WSMETHOD POST Vendedor WSSERVICE Vendas
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
    oDataBase := U_TCSSA3Inc(oBody, @cErroAuto)

    If !Empty(cErroAuto)
      lRet := .F.
      oResponse['code'] := 5
      oResponse['status'] := 400
      oResponse['message'] := 'Não foi possível incluir o vendedor em nossa base.'
      oResponse['detailedMessage'] := cErroAuto
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

/*/{Protheus.doc} GET 
/ api/crm/vendas/v1/vendedores
Retorna um Vendedor especifico

@param	id    		, caracter, Codigo do vendedor que deve ser retornado
@param	fields		, caracter, Campos que serão retornados no GET

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ItemVendedores PATHPARAM id WSRECEIVE fields WSSERVICE Vendas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Default self:fields   := _SA3PERMZ
Default self:id       := ''
Default self:order    := 'A3_FILIAL,A3_COD'

Begin Sequence

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .F. ) 
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SA3PERMZ, ',')
  for nx := 1 to Len(aFields)
    oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'SA3' ) + " SA3 "
  cQuery += " WHERE #QueryWhere#"

  cWhere := " A3_FILIAL = '"+ FWxFilial('SA3') +"' AND A3_COD = '" + self:id + "' AND SA3.D_E_L_E_T_ = ' '"    

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

/*/{Protheus.doc} GET 
/ api/crm/vendas/v1/unidades
Retorna todos os Unidades

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
WSMETHOD GET ListUnidades WSRECEIVE fields, order, page, pageSize, filter  WSSERVICE Vendas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Local cHeadMigra  := Lower(AllTrim(httpHeader('integration-migration')))

Default self:fields   := 'ADK_COD,ADK_NOME,ADK_EMAIL'
Default self:order    := 'ADK_FILIAL,ADK_COD'
Default self:page     := 1
Default self:pageSize := 20

If !Empty(cHeadMigra) .And. cHeadMigra == 'true'
  self:pageSize := Iif(self:pageSize > 1000, 1000, self:pageSize)
Else
  self:pageSize := Iif(self:pageSize > 50, 50, self:pageSize)
EndIf

Begin Sequence

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .T. ) 
  oDataBase:setPage(self:page)
  oDataBase:setPageSize(self:pageSize)
  oDataBase:SetOrderQuery(self:order)
  oDataBase:SetUrlFilter(self:aQueryString )
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_ADKPERMZ, ',')
  for nx := 1 to Len(aFields)
    oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'ADK' ) + " ADK "
  cQuery += " WHERE #QueryWhere#"
  cWhere := " ADK_FILIAL = '"+ FWxFilial('ADK') +"' AND ADK.D_E_L_E_T_ = ' '"  
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

// Verifica errorBlock
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

/*/{Protheus.doc} GET 
/ api/crm/vendas/v1/unidades
Retorna uma Unidade especifica

@param	id    		, caracter, Codigo da unidade que deve ser retornado
@param	fields		, caracter, Campos que serão retornados no GET

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD GET ItemUnidades PATHPARAM id WSRECEIVE fields WSSERVICE Vendas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := nil

Local cWhere  := ''
Local cQuery  := ''

Local aFields := {}
Local nx      := 0

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Default self:fields   := _ADKPERMZ
Default self:id       := ''
Default self:order    := 'ADK_FILIAL,ADK_COD'

Begin Sequence

  // Classe para consulta via Rest
  oDataBase := FWAdapterBaseV2():new( 'GET', .F. ) 
  oDataBase:SetFields( self:fields )  
  
  // Mapa de campos retornaveis
  aFields := StrToKArr2(_ADKPERMZ, ',')
  for nx := 1 to Len(aFields)
    oDataBase:AddMapFields( aFields[nx]   , aFields[nx]  , .T., .F., { aFields[nx]  , TamSX3( aFields[nx] )[3], TamSX3( aFields[nx] )[1], 0 } )
  next

  // Dados da Query
  cQuery := " SELECT #QueryFields#"
  cQuery +=   " FROM " + RetSqlName( 'ADK' ) + " ADK "
  cQuery += " WHERE #QueryWhere#"

  cWhere := " ADK_FILIAL = '"+ FWxFilial('ADK') +"' AND ADK_COD = '" + self:id + "' AND ADK.D_E_L_E_T_ = ' '"    

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

/*/{Protheus.doc} POST 
/api/crm/vendas/v1/distribuicao
Distribuicao da conta por rodizio para o territorio vencedor

@param	body   		, json ,
{
  codigo: string, // codigo da conta que deve ser distribuida
  loja: string // loja da conta que deve ser distribuida
    OU
  cgc: string  // cgc da conta que deve ser distribuida
}

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
WSMETHOD POST Distribuicao WSSERVICE Vendas

Local lRet			  := .T.
Local cBody       := self:getContent()
Local cErrBody    := ''
Local oBody       := JsonObject():New()
Local oResponse   := JsonObject():New()

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Local cErroDis    := ''
Local cEntidade   := ''

self:SetContentType('application/json')

Begin Sequence

  If !Empty(cErrBody := oBody:fromJson(cBody))
    lRet := .F.
    oResponse['code'] := 4
    oResponse['status'] := 400
    oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
    oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody
  Else

    // Busca conta através de Codigo e Loja
    If !Empty(oBody['codigo']) .And. !Empty(oBody['loja'])

      DbSelectArea("SA1")
      SA1->(DBSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA        
      DbSelectArea("SUS")
      SUS->(DBSetOrder(1)) //US_FILIAL+US_COD+US_LOJA        
      DbSelectArea("ACH")
      ACH->(DBSetOrder(1)) //ACH_FILIAL+ACH_CODIGO+ACH_LOJA  

      If SA1->(DbSeek(xFilial("SA1")+Padr(oBody['codigo'],TamSx3('A1_COD')[1])+Padr(oBody['loja'],TamSx3('A1_LOJA')[1])))
        cEntidade := 'SA1'
        cChavePesq := SA1->A1_COD+SA1->A1_LOJA
      ElseIf SUS->(DbSeek(xFilial("SUS")+Padr(oBody['codigo'],TamSx3('US_COD')[1])+Padr(oBody['loja'],TamSx3('US_LOJA')[1])))
        cEntidade := 'SUS'
        cChavePesq := SUS->US_COD+SUS->US_LOJA
      ElseIf ACH->(DbSeek(xFilial("ACH")+Padr(oBody['codigo'],TamSx3('ACH_CODIGO')[1])+Padr(oBody['loja'],TamSx3('ACH_LOJA')[1])))
        cEntidade := 'ACH'
        cChavePesq := ACH->ACH_CODIGO+ACH->ACH_LOJA
      Else
        lRet := .F.
        oResponse['code'] := 5
        oResponse['status'] := 404
        oResponse['message'] := 'Conta ' + oBody['codigo'] + oBody['loja'] + ' não encontrada.'
        oResponse['detailedMessage'] := 'Verifique o conteúdo das propriedades codigo e loja.'
      EndIf

    // Busca conta através de CPF/CNPJ
    ElseIf !Empty(oBody['cgc'])

      DbSelectArea("SA1")
      SA1->(DBSetOrder(3)) //A1_FILIAL+A1_CGC
      DbSelectArea("SUS")
      SUS->(DBSetOrder(4)) //US_FILIAL+US_CGC
      DbSelectArea("ACH")
      ACH->(DBSetOrder(2)) //ACH_FILIAL+ACH_CGC

      If SA1->(DbSeek(xFilial("SA1")+oBody['cgc']))
        cEntidade := 'SA1'
        cChavePesq := SA1->A1_COD+SA1->A1_LOJA
      ElseIf SUS->(DbSeek(xFilial("SUS")+oBody['cgc']))
        cEntidade := 'SUS'
        cChavePesq := SUS->US_COD+SUS->US_LOJA
      ElseIf ACH->(DbSeek(xFilial("ACH")+oBody['cgc']))
        cEntidade := 'ACH'
        cChavePesq := ACH->ACH_CODIGO+ACH->ACH_LOJA
      Else
        lRet := .F.
        oResponse['code'] := 2
        oResponse['status'] := 404
        oResponse['message'] := 'CPF/CNPJ ' + oBody['cgc'] + ' não encontrado.'
        oResponse['detailedMessage'] := 'Certifique-se de que já exista uma conta com o CPF/CNPJ ' + oBody['cgc'] + '.'
      EndIf

    Else
      lRet := .F.
      oResponse['code'] := 3
      oResponse['status'] := 400
      oResponse['message'] := 'Deve ser enviado o codigo e a loja da conta ou, pelo menos cgc com CPF/CNPJ'
      oResponse['detailedMessage'] := 'Verifique se no conteúdo está sendo enviado as propriedades codigo e loja ou cgc.'
    EndIf
  EndIf

  // Realiza a distribuição
  If lRet
    If !(lRet := TCSDistribui(cEntidade, cChavePesq, @cErroDis))
      oResponse['code'] := 6
      oResponse['status'] := 400
      oResponse['message'] := 'Não foi possível realizar a Distribuição da conta.'
      oResponse['detailedMessage'] := cErroDis
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If lRet
  oResponse['entidade'] := cEntidade
  
  // Suspects
  If cEntidade == "ACH"
    oResponse['codigo'] := ACH->ACH_CODIGO
    oResponse['loja'] := ACH->ACH_LOJA
    oResponse['codterritorio'] := ACH->ACH_CODTER
    oResponse['tpmembro'] := ACH->ACH_TPMEM
    oResponse['codmembro'] := ACH->ACH_CODMEM
    oResponse['vendedor'] := ACH->ACH_VEND    
  //Prospects
  ElseIf cEntidade == "SUS"
    oResponse['codigo'] := SUS->US_COD
    oResponse['loja'] := SUS->US_LOJA
    oResponse['codterritorio'] := SUS->US_CODTER
    oResponse['tpmembro'] := SUS->US_TPMEMB
    oResponse['codmembro'] := SUS->US_CODMEMB
    oResponse['vendedor'] := SUS->US_VEND    
  //Clientes
  Else
    oResponse['codigo'] := SA1->A1_COD
    oResponse['loja'] := SA1->A1_LOJA
    oResponse['codterritorio'] := SA1->A1_CODTER
    oResponse['tpmembro'] := SA1->A1_TPMEMB
    oResponse['codmembro'] := SA1->A1_CODMEMB
    oResponse['vendedor'] := SA1->A1_VEND
  EndIf

  self:SetResponse( oResponse:toJson() )

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

oResponse:DeActivate()
oResponse := nil
oBody:DeActivate()
oBody := nil
Return lRet

/*/{Protheus.doc} POST
  / api/crm/vendas/v1/fornecedores
Inclui um Fornecedor

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Moisés Osti
@since		08/12/2020
/*/
WSMETHOD POST Fornecedor WSSERVICE Vendas
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
    oDataBase := U_TCSSA2Inc(oBody, @cErroAuto)

    If !Empty(cErroAuto)
      lRet := .F.
      oResponse['code'] := 5
      oResponse['status'] := 400
      oResponse['message'] := 'Não foi possível incluir o fornecedor em nossa base.'
      oResponse['detailedMessage'] := cErroAuto
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

/*/{Protheus.doc} TCSDistribui
Distribuicao da conta por rodizio para o territorio vencedor

@param	cEntidade		, string , Entidade da conta (SA1,SUS1,ACH)
@param	cChavePesq	, string , Codigo + Loja da conta 
@param	cErro       , string , Variavel para receber via referencia, possiveis erros

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		08/10/2020
@version	1.0
/*/
Static Function TCSDistribui(cEntidade, cChavePesq, cErro)

Local lRet      := .T.
Local aEvalT    := {}
Local aTerritory:= {}
Local aExecAuto := {}
Local cProcess  := ''

Default cEntidade   := ''
Default cChavePesq  := ''
Default cErro       := ''

Private lMsErroAuto	:= .F.

// Define processo por entidade
If cEntidade == 'SA1'
  cProcess	:= 'MATA030'
ElseIf cEntidade == 'SUS'
  cProcess	:= 'TMKA260'
ElseIf cEntidade == 'ACH'
  cProcess	:= 'TMKA341'
EndIf

// Valida se os melhores territorios para a conta
aEvalT := CRMA690EvalTerritory(cProcess,cEntidade,.T.,.F.)
If ValType(aEvalT) != "A"
  aEvalT := {.F.}
EndIf

//Distribui a conta para o territorio e realiza rodizio
If aEvalT[1]
    
  aTerritory 	:= CRMA690CasterTerritory()	
  aEvalT 			:= {aTerritory[1]}
    
  If aEvalT[1]

    // Preenche vendedor caso não venha pela rotina do padrão
    If Empty(aTerritory[5])
      aTerritory[5] := TCSDtVend(aTerritory[3], aTerritory[4], cEntidade)
    EndIf

    // Suspects
    If cEntidade == "ACH"
      aExecAuto := {	{"ACH_CODIGO",Left(cChavePesq, Len(ACH->ACH_CODIGO)),Nil},;
              {"ACH_LOJA"	,Subs(cChavePesq, Len(ACH->ACH_CODIGO) + 1, Len(ACH->ACH_LOJA)),Nil},;
              {"ACH_CODTER",aTerritory[2],Nil},;
              {"ACH_TPMEM",aTerritory[3],Nil},;
              {"ACH_CODMEM",aTerritory[4],Nil},;
              {"ACH_VEND",aTerritory[5],Nil} }

      TMKA341(aExecAuto,4)
      
    // Prospects
    ElseIf cEntidade == "SUS"
      aExecAuto := {	{"US_COD",Left(cChavePesq, Len(SUS->US_COD)),Nil},;
              {"US_LOJA",Subs(cChavePesq, Len(SUS->US_COD) + 1, Len(SUS->US_LOJA)),Nil},;
              {"US_CODTER",aTerritory[2],Nil},;
              {"US_TPMEMB",aTerritory[3],Nil},;
              {"US_CODMEMB",aTerritory[4],Nil},;
              {"US_VEND",aTerritory[5],Nil} }
      
      TMKA260(aExecAuto,4)
    // Clientes
    Else
      aExecAuto := { {"A1_COD",Left(cChavePesq, Len(SA1->A1_COD)),Nil},;
            {"A1_LOJA",Subs(cChavePesq, Len(SA1->A1_COD) + 1, Len(SA1->A1_LOJA)),Nil},;
            {"A1_CODTER",aTerritory[2]	,Nil},;
            {"A1_TPMEMB",aTerritory[3]	,Nil},;
            {"A1_CODMEMB",aTerritory[4]	,Nil},;
            {"A1_VEND",aTerritory[5]	,Nil} }
          
      MATA030(aExecAuto,4)
    EndIf
  
    cErro := U_SrvXGetMostraErro()
    If lMsErroAuto .Or. !Empty(cErro)
      lRet := .F.
    EndIf
  
  Else
    cErro := '[CRMA690CasterTerritory] Não foi possível realizar a distribuição da conta'
    lRet := .F.
  EndIf

Else
  cErro := '[CRMA690EvalTerritory] Não foi possível encontrar um território para a conta'
  lRet := .F.   
Endif

aEvalT := nil
aTerritory := nil
aExecAuto := nil
Return lRet

/*/{Protheus.doc} TCSDtVend
Recupera vendedor para a distribuição, usando os objetos de territorio
Regra retirada do PE CRM690VD

@param	cTypeMember		, string , Tipo de membro
@param	cMember       , string , codigo de membro
@param	cEntidade     , string , tipo da entidade

@return cVendedor     , string, Vendedor responsavel pela conta

@author		Jose Camilo
@since		08/10/2020
@version	1.0
/*/
Static Function TCSDtVend(cTypeMember, cMember, cEntidade)
Local cUsrResp		:= ""
Local cVendedor		:= ""

Default cTypeMember := ''
Default cMember     := ''
Default cEntidade   := ''

If cEntidade == "ACH"	// Suspect
  cUsrResp := GetMV("TI_PAPPOOL")
Else
  If cTypeMember == "1"	//Unidade de venda
    cUsrResp := Posicione("ADK",1,xFilial("ADK")+cMember,"ADK_USRESP")
  ElseIf cTypeMember == "2"	//Usuario do CRM
    cUsrResp := cMember
  ElseIf cTypeMember == "3"	//Equipe de venda
    cUsrResp := Posicione("ACA",1,xFilial("ACA")+cMember,"ACA_USRESP")
  EndIf
EndIf

If !Empty(cUsrResp)
  cVendedor := Posicione("AZS",1,xFilial("AZS")+cUsrResp,"AZS_VEND")
EndIf

Return cVendedor

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

/*/{Protheus.doc} TCSSA3Inc
Inclui um novo Vendedor

@param	oVendedor		, object, Objeto JsonObject() com as propriedades que serão inclusas na conta
Campos obrigatorios neste objeto:
Parâmetro: TI_S56SA31

@param	cErro      , string , Variavel para receber via referencia, possiveis erros

@return oResult	, object, Retorna o registro incluido na base

@author		Jose Camilo
@since		29/09/2020
@version	1.0
/*/
User Function TCSSA3Inc(oVendedor, cErro)

Local aExecAuto   := {}
Local aFields     := {}
Local nx          := 0
Local oResult     := JsonObject():New()
Local cCmpObrig   := GetMv('TI_S56SA31',,'A3_NOME,A3_XAGN,A3_XCC,A3_XLOGIN,A3_UNIDAD,A3_CGC,A3_EMAIL')

Default oVendedor    := nil
Default cErro     := ''

Private lMsErroAuto	:= .F.

If ValType(oVendedor) == nil
  cErro := 'Não foram enviadas informações sobre o vendedor'
  Return nil
EndIf

// Campos obrigatórios
If !TCSVldAtrb(oVendedor, cCmpObrig)
  cErro := 'As seguintes propriedades são obrigatórias: ' + cCmpObrig
  Return nil
EndIf

// Campos informados na API (json)
aFields := oVendedor:GetNames()

// Campo randômico "A3_COD"
AAdd(aExecAuto, { "A3_COD", U_TCSXXXNum( "SA3", "A3_COD" ), Nil } )

for nx := 1 to Len(aFields)

    // Campos que precisam de tratamentos
    If TamSX3(aFields[nx])[3] == 'D'
      oVendedor[aFields[nx]] := StoD(oVendedor[aFields[nx]])
    EndIf

    AAdd( aExecAuto, {aFields[nx], oVendedor[aFields[nx]], nil})
next

MATA040(aExecAuto, 3)

// Verifica se ocorreu erro na rotina automática do padrão
cErro := U_SrvXGetMostraErro()
If !lMsErroAuto .And. Empty(cErro)

  // Mapa de campos retornaveis
  aFields := StrToKArr2(_SA3PERMZ, ',')
  for nx := 1 to Len(aFields)
    oResult[aFields[nx]] := SA3->&(aFields[nx])
  next

Else
  RollBackSX8()
EndIf

aExecAuto := nil
aFields   := nil

Return oResult

/*/{Protheus.doc} PUT 
/api/crm/vendas/v1/unidades/
Altera uma Unidade de Venda
@return lRet	, Lógico, Informa se o processo foi executado com sucesso.
@author		Cristiam Rossi
@since		07/12/2020
@version	1.0
/*/
WSMETHOD PUT Unidades PATHPARAM id WSSERVICE vendas
Local lRet       := .T.
Local oResponse  := JsonObject():New()
Local oBody      := JsonObject():New()
Local oDataBase  := JsonObject():New()
Local cBody      := self:GetContent()
Local cErroAuto  := ''
Local cErrBody   := ''
Local cErroBlk   := ''
Local oException := ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

    Begin Sequence

    If ! Empty(cErrBody := oBody:fromJson(cBody))
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
            oResponse['message'] := 'Deve ser enviado o código para a unidade (ADK_COD)'
            oResponse['detailedMessage'] := 'Verifique se a url está completa com o código da unidade (ADK_COD).'
        Else

            DbSelectArea("ADK")
            ADK->(DBSetOrder(1)) //ADK_FILIAL+ADK_COD

            If ! ADK->(DbSeek(xFilial("ADK")+self:id))
                lRet := .F.
                oResponse['code'] := 2
                oResponse['status'] := 400
                oResponse['message'] := 'A unidade ' + self:id + ' não existe em nossa base (ADK_COD).'
                oResponse['detailedMessage'] := 'Certifique-se de que o id enviado é de uma unidade (ADK_COD).'
            Else
                oBody['ADK_COD'] := ADK->ADK_COD

                oDataBase := U_TCSADKAlt(oBody, @cErroAuto)

                If ! empty(cErroAuto)
                    lRet := .F.
                    oResponse['code'] := 5
                    oResponse['status'] := 400
                    oResponse['message'] := 'Não foi possível alterar a unidade em nossa base.'
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

    If ! lRet
        SetRestFault(   oResponse['code'],;
                        U_EspecMsg(oResponse['message']),;
                        .T.,;
                        oResponse['status'],;
                        U_EspecMsg(oResponse['detailedMessage']);
        )
    EndIf

    oDataBase:DeActivate()
    oResponse:DeActivate()
    oBody:DeActivate()
    oDataBase := nil
    oResponse := nil 
    oBody     := nil 
    aFields   := nil
Return lRet


/*/{Protheus.doc} POST 
/api/crm/vendas/v1/unidades
Inclui uma nova Unidade
@return lRet	, Lógico, Informa se o processo foi executado com sucesso.
@author		Cristiam Rossi
@since		07/12/2020
@version	1.0
/*/
WSMETHOD POST Unidades WSSERVICE Vendas
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
        If Empty(oBody['ADK_CNPJ'])
            lRet := .F.
            oResponse['code'] := 3
            oResponse['status'] := 400
            oResponse['message'] := 'Deve ser enviada a propriedade ADK_CNPJ com o CNPJ da unidade'
            oResponse['detailedMessage'] := 'Verifique se no conteúdo está sendo enviado a propriedade ADK_CNPJ.'
        Else
            DbSelectArea("ADK")
            ADK->(DBSetOrder(3)) //ADK_FILIAL+ADK_CNPJ

            If ADK->(DbSeek(xFilial("ADK")+oBody['ADK_CNPJ']))
                lRet := .F.
                oResponse['code'] := 2
                oResponse['status'] := 400
                oResponse['message'] := 'O CNPJ ' + oBody['ADK_CNPJ'] + ' já existe em nossa base.'
                oResponse['detailedMessage'] := 'Certifique-se de que não exista uma unidade com o CNPJ ' + oBody['ADK_CNPJ'] + '.'
            Else

                oDataBase := U_TCSADKInc(oBody, @cErroAuto)

                If !Empty(cErroAuto)
                    lRet := .F.
                    oResponse['code'] := 5
                    oResponse['status'] := 400
                    oResponse['message'] := 'Não foi possível incluir a unidade em nossa base.'
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

    If ! lRet
        SetRestFault(   oResponse['code'],;
                        U_EspecMsg(oResponse['message']),;
                        .T.,;
                        oResponse['status'],;
                        U_EspecMsg(oResponse['detailedMessage']);
        )
    EndIf

    oDataBase:DeActivate()
    oResponse:DeActivate()
    oBody:DeActivate()
    oDataBase := nil
    oResponse := nil 
    oBody     := nil
    aFields   := nil
Return lRet


/*/{Protheus.doc} TCSADKAlt
Altera uma Unidade
@param   oCanal		, object, Objeto JsonObject() com as propriedades que serão alteradas na unidade
@param   cErro    , string , Variavel para receber via referencia, possiveis erros
@return  oResult	, object, Retorna o registro alterado na base
@author  Cristiam Rossi
@since   08/12/2020
@version 1.0
/*/
User Function TCSADKAlt(oCanal, cErro)
Local   aArea       := getArea()
Local   aFields     := {}
Local   aErro       := {}
Local   nX          := 0
Local   oResult     := JsonObject():New()
Local   oModel
Local   oModelADK
Local   cCmpAlter   := GetMv('TI_S58ADK1',,'ADK_NOME,ADK_CNPJ,ADK_TIPO,ADK_RESP,ADK_END,ADK_BAIRRO,ADK_MUN,ADK_EST,ADK_PAIS,ADK_CEP,ADK_DDI,ADK_DDD,ADK_TEL,ADK_EMAIL,ADK_XDAR,ADK_XSUPER,ADK_MSBLQL') // Campos permitidos para alterar ADK
Default oCanal      := nil
Default cErro       := ''

    If ValType(oCanal) == nil
        cErro := 'Não foram enviadas informações sobre a unidade'
        Return nil
    ElseIf Empty( oCanal['ADK_COD'] )
        cErro := 'Não foram enviadas informações de identificação da unidade'
        Return nil
    EndIf

    oModel := FWLoadModel("FATA510")
    oModel:SetOperation(MODEL_OPERATION_UPDATE)
    oModel:Activate()

    oModelADK := oModel:GetModel("ADKMASTER")

    aFields := oCanal:GetNames()
    for nX := 1 to Len(aFields)
        If aFields[nX] $ cCmpAlter
            // Campos que precisam de tratamentos
            If TamSX3(aFields[nX])[3] == 'D'
                oCanal[aFields[nX]] := StoD(oCanal[aFields[nX]])
            EndIf

            oModelADK:SetValue( aFields[nX], oCanal[aFields[nX]] )
        EndIf
    next

    If oModel:VldData()
        oModel:CommitData()
    Else
        aErro := oModel:GetErrorMessage()

        cErro := "Id do formulário de origem:"+ ' [' + AllToChar( aErro[1] ) + ']' + CRLF
        cErro += "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' + CRLF
        cErro += "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']' + CRLF
        cErro += "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' + CRLF
        cErro += "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' + CRLF
        cErro += "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' + CRLF
        cErro += "Mensagem da solução: " + ' [' + AllToChar( aErro[7] ) + ']' + CRLF
        cErro += "Valor atribuído: " + ' [' + AllToChar( aErro[8] ) + ']' + CRLF
        cErro += "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' + CRLF
    EndIf

    If Empty(cErro)
        aFields := StrToKArr2(_ADKPERMZ, ',')
        for nX := 1 to Len(aFields)
            oResult[aFields[nX]] := ADK->&(aFields[nX])
        next
    EndIf

    oModel:DeActivate()
    oModel:Destroy()
    oModel  := NIL
    aFields := nil
    aErro   := nil
    restArea(aArea)
Return oResult

/*/{Protheus.doc} TCSADKInc
Inclui um novo Canal
@param	oConta		, object, Objeto JsonObject() com as propriedades que serão inclusas na unidade
Campos obrigatorios neste objeto: ver parâmetro TI_S58ADK2
@param	cErro     , string , Variavel para receber via referencia, possiveis erros
@return oResult	  , object, Retorna o registro incluido na base
@author		Cristiam Rossi
@since		09/12/2020
@version	1.0
/*/
User Function TCSADKInc(oCanal, cErro)
Local   aArea       := getArea()
Local   aFields     := {}
Local   aErro       := {}
Local   nX          := 0
Local   oResult     := JsonObject():New()
Local   oModel
Local   oModelADK
Local   cCmpObrig   := GetMv('TI_S58ADK2',,'ADK_NOME,ADK_TIPO,ADK_END,ADK_BAIRRO,ADK_MUN,ADK_EST,ADK_CEP,ADK_DDD,ADK_TEL,ADK_EMAIL,ADK_XPROPR,ADK_XTPEXC,ADK_XCODAN,ADK_XTGARE')
Default oCanal      := nil
Default cErro       := ''

    If ValType(oCanal) == nil
        cErro := 'Não foram enviadas informações sobre a unidade'
        Return nil
    EndIf

    // Campos obrigatórios
    If ! TCSVldAtrb(oCanal, cCmpObrig)
        cErro := 'As seguintes propriedades são obrigatórias: ' + cCmpObrig
        Return nil
    EndIf

    oModel := FWLoadModel("FATA510")
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()

    oModelADK := oModel:GetModel("ADKMASTER")
    oModelADK:SetValue( "ADK_COD", U_TCSXXXNum( "ADK", "ADK_COD" ) )

    aFields := oCanal:GetNames()
    for nX := 1 to Len(aFields)
        If aFields[nX] $ _ADKPERMZ
            // Campos que precisam de tratamentos
            If TamSX3(aFields[nX])[3] == 'D'
                oCanal[aFields[nX]] := StoD(oCanal[aFields[nX]])
            EndIf

            oModelADK:SetValue( aFields[nX], oCanal[aFields[nX]] )
        EndIf
    next

    If oModel:VldData()
        oModel:CommitData()
        ConfirmSX8()
    Else
        aErro := oModel:GetErrorMessage()
        cErro := "Id do formulário de origem:"+ ' [' + AllToChar( aErro[1] ) + ']' + CRLF
        cErro += "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' + CRLF
        cErro += "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']' + CRLF
        cErro += "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' + CRLF
        cErro += "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' + CRLF
        cErro += "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' + CRLF
        cErro += "Mensagem da solução: " + ' [' + AllToChar( aErro[7] ) + ']' + CRLF
        cErro += "Valor atribuído: " + ' [' + AllToChar( aErro[8] ) + ']' + CRLF
        cErro += "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' + CRLF
        RollBackSX8()
    EndIf

    If Empty(cErro)
        aFields := StrToKArr2(_ADKPERMZ, ',')
        for nX := 1 to Len(aFields)
            oResult[aFields[nX]] := ADK->&(aFields[nX])
        next
    EndIf

    oModel:DeActivate()
    oModel:Destroy()
    oModel  := NIL
    aFields := nil
    aErro   := nil
    restArea(aArea)
Return oResult

/*/{Protheus.doc} TCSSA2Inc
Inclui um novo Fornecedor

@param	oFornecedor, object, Objeto JsonObject() com as propriedades que serão inclusas no fornecedor
Campos obrigatorios neste objeto:
Parâmetro: TI_S56SA21

@param	cErro      , string , Variavel para receber via referencia, possiveis erros

@return oResult	, object, Retorna o registro incluido na base

@author		Moisés Osti
@since		07/12/2020
@version	1.0
/*/
User Function TCSSA2Inc(oFornecedor, cErro)

Local aFields     := {}
Local nx          := 0
Local oResult     := JsonObject():New()
Local cCmpObrig   := GetMv('TI_S56SA21',,'A2_NOME,A2_NREDUZ,A2_END,A2_EST,A2_COD_MUN,A2_TIPO,A2_CGC,A2_PAIS,A2_CONTA')
Local oModelSA2   := Nil
Local oMasterSA2  := Nil

Private ALTERA	  := .F.
Private INCLUI	  := .T.

Default oFornecedor := nil
Default cErro       := ''

Private lMsErroAuto	:= .F.

If ValType(oFornecedor) == nil
  cErro := 'Não foram enviadas informações sobre o vendedor'
  Return nil
EndIf

// Campos obrigatórios
If !TCSVldAtrb(oFornecedor, cCmpObrig)
  cErro := 'As seguintes propriedades são obrigatórias: ' + cCmpObrig
  Return nil
EndIf

// Campos informados na API (json)
aFields := oFornecedor:GetNames()

oModelSA2 	:=  FWLoadModel( 'MATA020' )
oModelSA2:SetOperation(MODEL_OPERATION_INSERT)

If oModelSA2:Activate()
  oMasterSA2 := oModelSA2:GetModel("SA2MASTER")

  for nx := 1 to Len(aFields)

      // Campos que precisam de tratamentos
      If TamSX3(aFields[nx])[3] == 'D'
        oFornecedor[aFields[nx]] := StoD(oFornecedor[aFields[nx]])
      EndIf

      If !(oMasterSA2:SetValue(aFields[nx], oFornecedor[aFields[nx]]))
        cErro := TCSErrMod(oModelSA2)
        Exit
      EndIf
  next
Else
  cErro := "Não foi possível ativar model de fornecedor MATA020"
EndIf

// Verifica se não ocorreu erro na ativação ou preenchimento de campos rotina MVC
If Empty(cErro)

  If oModelSA2:VldData() .And. oModelSA2:CommitData()

      // Mapa de campos retornaveis
      aFields := StrToKArr2(_SA2PERMZ, ',')
      for nx := 1 to Len(aFields)
        oResult[aFields[nx]] := SA2->&(aFields[nx])
      next
  else
      cErro := TCSErrMod(oModelSA2)
      RollBackSX8()
  endIf
else
  RollBackSX8()
EndIf

aFields   := nil
oModelSA2:DeActivate()

Return oResult

/*/{Protheus.doc} TCSErrMod
    Retorna erro do model MVC
    @type  Static Function
    @author user
    @since 07/12/2020
    @param param_name, param_type, param_descr
    @return cMsgErro, return_type, Texto do erro gerado no model
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function TCSErrMod(oModel)
Local aErro     := {}
Local cMsgErro  := ''

/*
  [1] ExpC: Id do submodelo de origem
  [2] ExpC: Id do campo de origem
  [3] ExpC: Id do submodelo de erro
  [4] ExpC: Id do campo de erro
  [5] ExpC: Id do erro
  [6] ExpC: mensagem do erro
  [7] ExpC: mensagem da solução
*/

aErro := oModel:GetErrorMessage()

cMsgErro := AllTrim(AllToChar(aErro[6]))
If ! Empty(aErro[4])
    cMsgErro += " - Campo: " + aErro[4]
EndIf

Return cMsgErro

/*/{Protheus.doc} GET
  /api/crm/vendas/v1/metas/{ano}
Retorna Metas de Vendas do CRM de um Ano

@param	page		, numérico, Número da página inicial da consulta
@param	pageSize	, numérico, Número de registro por páginas
@param	dateUpdate	, data de atualização. Se usado retornará apenas os itens alterados ou criados nesta data

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Jose Camilo
@since		02/06/2021
@version	1.0
/*/
WSMETHOD GET ListMetasAno PATHPARAM ano WSRECEIVE page, pageSize, dateUpdate WSSERVICE Vendas

Local lRet			  := .T.
Local oResponse   := JsonObject():New()
Local oDataBase   := JsonObject():New()
Local aDataBase   := {}

Local cAlias    := GetNextAlias()
Local cAgrServ  := '0101'
Local cQryUpd   := '%%'
Local nOffset   := 0

Local cErroBlk    := ''
Local oException	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

Default self:page     := 1
Default self:pageSize := 20

self:pageSize := Iif(self:pageSize > 1000, 1000, self:pageSize)
nOffset	:= ( self:page - 1 ) * self:pageSize

If self:ano < 2000 .Or. self:ano > 2100
  oResponse['code'] := 002 
  oResponse['status'] := 400
  oResponse['message'] := 'Ano para pesquisa inválido. O ano deve ser entre 2000 e 2100'
  oResponse['detailedMessage'] := 'O ano de pesquisa é enviado na URL do serviço /api/crm/vendas/v1/metas/{ano} e deve ser entre 2000 e 2100'
  lRet := .F.
Else
  self:ano := AllTrim(Str(self:ano))
EndIf

If !Empty(self:dateUpdate)
  If self:dateUpdate < 20000000 .Or. self:dateUpdate > 21000000
    oResponse['code'] := 003 
    oResponse['status'] := 400
    oResponse['message'] := 'Data de Atualização para pesquisa inválido. A Data de Atualização deve ser entre os anos 2000 e 2100'
    oResponse['detailedMessage'] := 'A Data de Atualização de pesquisa é enviado como parâmetro na URL do serviço ?dateUpdate=YYYYMMDD e deve ser entre os anos 2000 e 2100'
    lRet := .F.
  Else
    self:dateUpdate := AllTrim(Str(self:dateUpdate))
    cQryUpd := '' +;
    " AND ( " +;
    "  TO_CHAR(TO_DATE('19960101', 'YYYYMMDD')+((ASCII(SUBSTR(CT_USERLGA,12,1))-50)*100+(ASCII(SUBSTR(CT_USERLGA,16,1))-50))) = '" + self:dateUpdate + "' " +;
    "  OR " +;
    "  TO_CHAR(TO_DATE('19960101', 'YYYYMMDD')+((ASCII(SUBSTR(CT_USERLGI,12,1))-50)*100+(ASCII(SUBSTR(CT_USERLGI,16,1))-50))) = '" + self:dateUpdate + "' " +;
    " ) "
    cQryUpd := '%'+cQryUpd+'%'
  EndIf
EndIf

If lRet
  Begin Sequence

    BeginSQL Alias cAlias

    SELECT
      NV_META
      ,CT_XAGRUP
      ,CD_PRODUTO
      ,DT_META
      ,CD_UNIDADE_ATENDIMENTO
      ,CD_UNIDADE_VENDA
      ,CD_ESN
      ,CD_GSN
      ,CD_DSN
      ,EMAIL_META
      ,DS_SEGMENTO
      ,DS_MACRO_SEGMENTO
      ,DS_AGRUPAMENTO_META
      ,CASE WHEN PCN_MODPRO = '1' THEN (VL_META/21.82)
      ELSE VL_META
      END AS VL_META_PRODUCAO
      ,DS_LINHA_RECEITA

      FROM (

      SELECT 	
        'Unidade'			NV_META
        ,CT_XAGRUP		CT_XAGRUP
        ,CT_DATA			DT_META
        ,CT_XUNIDAD		CD_UNIDADE_ATENDIMENTO
        ,ADK_XSUPER		CD_UNIDADE_VENDA
        ,'-1'				  CD_ESN
        ,'-1'				  CD_GSN
        ,'-1'				  CD_DSN
        ,' '          EMAIL_META
        ,AOV_DESSEG 	DS_SEGMENTO
        ,CASE
          WHEN AOV_XAGRUP = '1'    THEN 'PRODUCTS'
          WHEN AOV_XAGRUP = '2'    THEN 'SERVICES'
          WHEN AOV_XAGRUP = '3'    THEN 'SMALL'
          WHEN AOV_XAGRUP = '4'    THEN 'SUPPLYCHAIN'
          WHEN AOV_XAGRUP = '5'    THEN 'CONSUMER'
          WHEN AOV_XAGRUP = '6'    THEN 'HEALTHCARE'
          WHEN AOV_XAGRUP = '7'    THEN 'FINANCIAL SERVICES'
          WHEN AOV_XAGRUP = '8'    THEN 'MERCADO INTERNACIONAL'
          WHEN AOV_XAGRUP IS NULL  THEN 'NAO INFORMADO'
        END DS_MACRO_SEGMENTO
        ,PCI_DESCRI  		DS_AGRUPAMENTO_META
        ,PCN_MODPRO
        ,SUM(COALESCE(CT_VALOR,0)) VL_META

      FROM %Table:SCT% SCT

      LEFT JOIN %Table:AOV% AOV ON AOV_FILIAL = %Exp:xFilial('AOV')% AND CT_XCODSEG = AOV_CODSEG AND AOV.%NotDel%

      LEFT JOIN %Table:ADK% ADK ON ADK_FILIAL = %Exp:xFilial('ADK')% AND ADK_COD = SCT.CT_XUNIDAD AND AOV.%NotDel%

      LEFT JOIN %Table:PCJ% PCJ ON PCJ_FILIAL = %Exp:xFilial('PCJ')% AND PCJ_PICPAD = CT_XAGRUP AND PCJ.%NotDel%

      LEFT JOIN %Table:PCI% PCI ON PCI_FILIAL = %Exp:xFilial('PCI')% AND PCJ.PCJ_PICMET = PCI.PCI_CODIGO AND PCI.%NotDel%

      LEFT JOIN %Table:PCN% PCN ON PCN_FILIAL = %Exp:xFilial('PCN')% 
      AND PCN.PCN_CODMET = PCI.PCI_CODIGO 
      AND TO_DATE(CT_DATA,'YYYYMMDD') BETWEEN TO_DATE(PCN.PCN_VIGDE,'YYYYMMDD') AND TO_DATE(PCN.PCN_VIGATE,'YYYYMMDD')
      AND PCN.%NotDel%

      WHERE
      SUBSTR(CT_DATA,1,4) = %Exp:self:ano%
      AND CT_XAGRUP  <> ' '
      AND CT_XUNIDAD <> ' '
      AND ( CT_VEND = ' ' OR CT_XCODSUP = ' ' )
      AND CT_XAGRUP <> %Exp:cAgrServ%
      AND SCT.%NotDel%
      %Exp:cQryUpd%

      GROUP BY 
      CT_XAGRUP
      ,CT_DATA
      ,CT_XUNIDAD
      ,ADK_XSUPER
      ,AOV_DESSEG
      ,AOV_XAGRUP
      ,PCI_DESCRI
      ,PCN_MODPRO

      UNION ALL

      SELECT 	
        'DSN'				  NV_META
        ,CT_XAGRUP		CT_XAGRUP
        ,CT_DATA			DT_META
        ,CT_XUNIDAD		CD_UNIDADE_ATENDIMENTO
        ,ADK_XSUPER		CD_UNIDADE_VENDA
        ,'-1'				  CD_ESN
        ,'-1'				  CD_GSN
        ,A3_COD				CD_DSN
        ,A3_EMAIL     EMAIL_META
        ,AOV_DESSEG 	DS_SEGMENTO
        ,CASE
          WHEN AOV_XAGRUP = '1'    THEN 'PRODUCTS'
          WHEN AOV_XAGRUP = '2'    THEN 'SERVICES'
          WHEN AOV_XAGRUP = '3'    THEN 'SMALL'
          WHEN AOV_XAGRUP = '4'    THEN 'SUPPLYCHAIN'
          WHEN AOV_XAGRUP = '5'    THEN 'CONSUMER'
          WHEN AOV_XAGRUP = '6'    THEN 'HEALTHCARE'
          WHEN AOV_XAGRUP = '7'    THEN 'FINANCIAL SERVICES'
          WHEN AOV_XAGRUP = '8'    THEN 'MERCADO INTERNACIONAL'
          WHEN AOV_XAGRUP IS NULL  THEN 'NAO INFORMADO'
        END DS_MACRO_SEGMENTO
        ,PCI_DESCRI  		DS_AGRUPAMENTO_META
        ,PCN_MODPRO
        ,SUM(COALESCE(CT_VALOR,0)) VL_META

      FROM %Table:SCT% SCT

      INNER JOIN %Table:SA3% SA3 ON A3_FILIAL = %Exp:xFilial('A3_')% AND A3_COD = CT_VEND AND A3_CARGO = '000001' AND SA3.%NotDel%

      LEFT JOIN %Table:AOV% AOV ON AOV_FILIAL = %Exp:xFilial('AOV')% AND CT_XCODSEG = AOV_CODSEG AND AOV.%NotDel%

      LEFT JOIN %Table:ADK% ADK ON ADK_FILIAL = %Exp:xFilial('ADK')% AND ADK_COD = SCT.CT_XUNIDAD AND AOV.%NotDel%

      LEFT JOIN %Table:PCJ% PCJ ON PCJ_FILIAL = %Exp:xFilial('PCJ')% AND PCJ_PICPAD = CT_XAGRUP AND PCJ.%NotDel%

      LEFT JOIN %Table:PCI% PCI ON PCI_FILIAL = %Exp:xFilial('PCI')% AND PCJ.PCJ_PICMET = PCI.PCI_CODIGO AND PCI.%NotDel%

      LEFT JOIN %Table:PCN% PCN ON PCN_FILIAL = %Exp:xFilial('PCN')% 
      AND PCN.PCN_CODMET = PCI.PCI_CODIGO 
      AND TO_DATE(CT_DATA,'YYYYMMDD') BETWEEN TO_DATE(PCN.PCN_VIGDE,'YYYYMMDD') AND TO_DATE(PCN.PCN_VIGATE,'YYYYMMDD')
      AND PCN.%NotDel%

      WHERE
      SUBSTR(CT_DATA,1,4) = %Exp:self:ano%
      AND CT_XAGRUP  <> ' '
      AND CT_XAGRUP <> %Exp:cAgrServ%
      AND SCT.%NotDel%
      %Exp:cQryUpd%

      GROUP BY 
      CT_XAGRUP
      ,CT_DATA
      ,CT_XUNIDAD
      ,ADK_XSUPER
      ,A3_COD
      ,A3_EMAIL
      ,AOV_DESSEG
      ,AOV_XAGRUP
      ,PCI_DESCRI
      ,PCN_MODPRO

      UNION ALL

      SELECT 	
        'GSN'				  NV_META
        ,CT_XAGRUP		CT_XAGRUP
        ,CT_DATA			DT_META
        ,CT_XUNIDAD		CD_UNIDADE_ATENDIMENTO
        ,ADK_XSUPER		CD_UNIDADE_VENDA
        ,'-1'				  CD_ESN
        ,A3_COD				CD_GSN
        ,CT_XCODSUP		CD_DSN
        ,A3_EMAIL     EMAIL_META
        ,AOV_DESSEG 	DS_SEGMENTO
        ,CASE
          WHEN AOV_XAGRUP = '1'    THEN 'PRODUCTS'
          WHEN AOV_XAGRUP = '2'    THEN 'SERVICES'
          WHEN AOV_XAGRUP = '3'    THEN 'SMALL'
          WHEN AOV_XAGRUP = '4'    THEN 'SUPPLYCHAIN'
          WHEN AOV_XAGRUP = '5'    THEN 'CONSUMER'
          WHEN AOV_XAGRUP = '6'    THEN 'HEALTHCARE'
          WHEN AOV_XAGRUP = '7'    THEN 'FINANCIAL SERVICES'
          WHEN AOV_XAGRUP = '8'    THEN 'MERCADO INTERNACIONAL'
          WHEN AOV_XAGRUP IS NULL  THEN 'NAO INFORMADO'
        END DS_MACRO_SEGMENTO
        ,PCI_DESCRI  		DS_AGRUPAMENTO_META
        ,PCN_MODPRO
        ,SUM(COALESCE(CT_VALOR,0)) VL_META

      FROM %Table:SCT% SCT

      INNER JOIN %Table:SA3% SA3 ON A3_FILIAL = %Exp:xFilial('A3_')% AND A3_COD = CT_VEND AND A3_CARGO IN ('000002','000255') AND SA3.%NotDel%

      LEFT JOIN %Table:AOV% AOV ON AOV_FILIAL = %Exp:xFilial('AOV')% AND CT_XCODSEG = AOV_CODSEG AND AOV.%NotDel%

      LEFT JOIN %Table:ADK% ADK ON ADK_FILIAL = %Exp:xFilial('ADK')% AND ADK_COD = SCT.CT_XUNIDAD AND AOV.%NotDel%

      LEFT JOIN %Table:PCJ% PCJ ON PCJ_FILIAL = %Exp:xFilial('PCJ')% AND PCJ_PICPAD = CT_XAGRUP AND PCJ.%NotDel%

      LEFT JOIN %Table:PCI% PCI ON PCI_FILIAL = %Exp:xFilial('PCI')% AND PCJ.PCJ_PICMET = PCI.PCI_CODIGO AND PCI.%NotDel%

      LEFT JOIN %Table:PCN% PCN ON PCN_FILIAL = %Exp:xFilial('PCN')% AND PCN.PCN_CODMET = PCI.PCI_CODIGO 
      AND TO_DATE(CT_DATA,'YYYYMMDD') BETWEEN TO_DATE(PCN.PCN_VIGDE,'YYYYMMDD') AND TO_DATE(PCN.PCN_VIGATE,'YYYYMMDD')
      AND PCN.%NotDel%

      WHERE
      SUBSTR(CT_DATA,1,4) = %Exp:self:ano%
      AND CT_XAGRUP  <> ' '
      AND CT_XAGRUP <> %Exp:cAgrServ%
      AND SCT.%NotDel%
      %Exp:cQryUpd%


      GROUP BY 
      CT_XAGRUP
      ,CT_DATA
      ,CT_XUNIDAD
      ,ADK_XSUPER
      ,A3_COD
      ,A3_EMAIL
      ,AOV_DESSEG
      ,AOV_XAGRUP
      ,PCI_DESCRI
      ,CT_XCODSUP
      ,PCN_MODPRO

      UNION ALL

      SELECT 	
        'ESN'				  NV_META
        ,CT_XAGRUP		CT_XAGRUP
        ,CT_DATA			DT_META
        ,CT_XUNIDAD		CD_UNIDADE_ATENDIMENTO
        ,ADK_XSUPER		CD_UNIDADE_VENDA
        ,A3_COD				CD_ESN
        ,CT_XCODSUP		CD_GSN
        ,HRQ.DSN			CD_DSN
        ,A3_EMAIL     EMAIL_META
        ,AOV_DESSEG 	DS_SEGMENTO
        ,CASE
          WHEN AOV_XAGRUP = '1'    THEN 'PRODUCTS'
          WHEN AOV_XAGRUP = '2'    THEN 'SERVICES'
          WHEN AOV_XAGRUP = '3'    THEN 'SMALL'
          WHEN AOV_XAGRUP = '4'    THEN 'SUPPLYCHAIN'
          WHEN AOV_XAGRUP = '5'    THEN 'CONSUMER'
          WHEN AOV_XAGRUP = '6'    THEN 'HEALTHCARE'
          WHEN AOV_XAGRUP = '7'    THEN 'FINANCIAL SERVICES'
          WHEN AOV_XAGRUP = '8'    THEN 'MERCADO INTERNACIONAL'
          WHEN AOV_XAGRUP IS NULL  THEN 'NAO INFORMADO'
        END DS_MACRO_SEGMENTO
        ,PCI_DESCRI  		DS_AGRUPAMENTO_META
        ,PCN_MODPRO
        ,SUM(COALESCE(CT_VALOR,0)) VL_META

      FROM %Table:SCT% SCT

      INNER JOIN %Table:SA3% SA3 ON A3_FILIAL = %Exp:xFilial('A3_')% AND A3_COD = CT_VEND AND A3_CARGO = '000003' AND A3_XAGN <> 'COP'  AND
      SA3.%NotDel%

      LEFT JOIN %Table:AOV% AOV ON AOV_FILIAL = %Exp:xFilial('AOV')% AND CT_XCODSEG = AOV_CODSEG AND AOV.%NotDel%

      LEFT JOIN %Table:ADK% ADK ON ADK_FILIAL = %Exp:xFilial('ADK')% AND ADK_COD = SCT.CT_XUNIDAD AND AOV.%NotDel%

      LEFT JOIN %Table:PCJ% PCJ ON PCJ_FILIAL = %Exp:xFilial('PCJ')% AND PCJ_PICPAD = CT_XAGRUP AND PCJ.%NotDel%

      LEFT JOIN %Table:PCI% PCI ON PCI_FILIAL = %Exp:xFilial('PCI')% AND PCJ.PCJ_PICMET = PCI.PCI_CODIGO AND PCI.%NotDel%

      LEFT JOIN %Table:PCN% PCN ON PCN_FILIAL = %Exp:xFilial('PCN')% AND PCN.PCN_CODMET = PCI.PCI_CODIGO 
      AND TO_DATE(CT_DATA,'YYYYMMDD') BETWEEN TO_DATE(PCN.PCN_VIGDE,'YYYYMMDD') AND TO_DATE(PCN.PCN_VIGATE,'YYYYMMDD')
      AND PCN.%NotDel%

            
      LEFT JOIN
      (
        SELECT DISTINCT  TRIM(CT_XUNIDAD) CD_UNIDADE
                ,CT_VEND ESN
                ,CASE WHEN SUBSTR(CT_XCODSUP,1,1) = ' ' THEN '-2' ELSE CT_XCODSUP END GSN
                ,DSN
        FROM %Table:SCT% SCT
        INNER JOIN %Table:SA3% SA3EX ON SA3EX.A3_FILIAL = %Exp:xFilial('SA3')% AND SA3EX.A3_COD = CT_VEND AND SA3EX.A3_CARGO = '000003' AND SA3EX.%NotDel% AND A3_XAGN <> 'COP'
        LEFT JOIN (
              SELECT DISTINCT  CASE WHEN SUBSTR(CT_XCODSUP,1,1) = ' ' THEN '-2' ELSE CT_XCODSUP END DSN
                      ,CT_VEND AS GSN
              FROM %Table:SCT% SCT
              INNER JOIN %Table:SA3% SA3  ON SA3.A3_FILIAL = %Exp:xFilial('SA3')% AND SA3.A3_COD = CT_VEND AND SA3.A3_CARGO IN ('000002','000255') AND SA3.%NotDel%
              INNER JOIN %Table:SA3% SA3V ON SA3V.A3_FILIAL = %Exp:xFilial('SA3')% AND SA3V.A3_COD = CT_XCODSUP AND SA3V.A3_CARGO = '000001' AND SA3V.%NotDel%

              WHERE 
              SCT.%NotDel% 
              AND CT_VEND <> ' '
              AND SUBSTR(CT_DATA,1,4) = %Exp:self:ano%
              AND CT_XAGRUP <> %Exp:cAgrServ%
              AND CT_XAGRUP <> ' ') GSN
                ON SCT.CT_XCODSUP = GSN.GSN
        WHERE 
        SCT.%NotDel% 
        AND CT_VEND <> ' '
        AND SUBSTR(CT_DATA,1,4) = %Exp:self:ano%
        AND CT_XAGRUP <> %Exp:cAgrServ%
        AND CT_XAGRUP <> ' '
      ) HRQ ON HRQ.ESN = CT_VEND AND HRQ.GSN = CT_XCODSUP AND HRQ.CD_UNIDADE = SCT.CT_XUNIDAD

      WHERE
      SUBSTR(CT_DATA,1,4) = %Exp:self:ano%
      AND CT_XAGRUP  <> ' '
      AND CT_XAGRUP <> %Exp:cAgrServ%
      AND SCT.%NotDel%
      %Exp:cQryUpd%

      GROUP BY 
      CT_XAGRUP
      ,CT_DATA
      ,CT_XUNIDAD
      ,ADK_XSUPER
      ,A3_COD
      ,A3_EMAIL
      ,CT_XCODSUP
      ,DSN
      ,AOV_DESSEG
      ,AOV_XAGRUP
      ,PCI_DESCRI
      ,PCN_MODPRO

      ) X

      LEFT JOIN (
        SELECT * FROM (
          SELECT 	 A.B1_COD AS CD_PRODUTO
              ,D.PLG_RELAC6 AS DS_LINHA_RECEITA
              ,B.BM_GRUPO
              ,B.BM_XLINREC
              ,ROW_NUMBER() OVER ( PARTITION BY B.BM_XLINREC ORDER BY  A.B1_COD ) AS ID
            FROM ( SELECT B1_COD, B1_GRUPO FROM %Table:SB1% A WHERE %NotDel% )  A
            LEFT OUTER JOIN ( SELECT BM_GRUPO,BM_XLINREC,BM_XGRPREC FROM %Table:SBM% B WHERE %NotDel% ) B ON A.B1_GRUPO=B.BM_GRUPO
            LEFT OUTER JOIN ( SELECT PCJ_PICMET,PCJ_PICPAD FROM %Table:PCJ% C WHERE %NotDel% ) C ON C.PCJ_PICPAD = B.BM_XLINREC
            LEFT OUTER JOIN ( SELECT PLG_RELAC6,PLG_TPLINK,PLG_DSCMAN FROM %Table:PLG% D WHERE %NotDel% ) D ON D.PLG_TPLINK = '000134'
            AND D.PLG_DSCMAN = C.PCJ_PICMET || (CASE WHEN B.BM_XGRPREC = '1' THEN 'S' WHEN B.BM_XGRPREC = '2' THEN 'N' END)
          ) A WHERE ID =1
        ) PRD ON X.CT_XAGRUP = PRD.BM_XLINREC

      OFFSET %Exp:nOffset% ROWS FETCH NEXT %Exp:self:pageSize% ROWS ONLY 
    EndSQL

    while (cAlias)->(!EOF())
      oDataBase := JsonObject():New()

      oDataBase['NV_META'] := AllTrim((cAlias)->NV_META)
      oDataBase['CD_PRODUTO'] := AllTrim((cAlias)->CD_PRODUTO)
      oDataBase['DT_META'] := AllTrim((cAlias)->DT_META)
      oDataBase['CD_UNIDADE_ATENDIMENTO'] := AllTrim((cAlias)->CD_UNIDADE_ATENDIMENTO)
      oDataBase['CD_UNIDADE_VENDA'] := AllTrim((cAlias)->CD_UNIDADE_VENDA)
      oDataBase['CD_ESN'] := AllTrim((cAlias)->CD_ESN)
      oDataBase['CD_GSN'] := AllTrim((cAlias)->CD_GSN)
      oDataBase['CD_DSN'] := AllTrim((cAlias)->CD_DSN)
      oDataBase['EMAIL_META'] := AllTrim((cAlias)->EMAIL_META)
      oDataBase['DS_SEGMENTO'] := AllTrim((cAlias)->DS_SEGMENTO)
      oDataBase['DS_MACRO_SEGMENTO'] := AllTrim((cAlias)->DS_MACRO_SEGMENTO)
      oDataBase['DS_AGRUPAMENTO_META'] := AllTrim((cAlias)->DS_AGRUPAMENTO_META)
      oDataBase['VL_META_PRODUCAO'] := (cAlias)->VL_META_PRODUCAO
      oDataBase['DS_LINHA_RECEITA'] := AllTrim((cAlias)->DS_LINHA_RECEITA)
      
      AAdd(aDataBase, oDataBase)     
      (cAlias)->(dbSkip())
    end
    (cAlias)->(dbCloseArea())
  End Sequence

  ErrorBlock(oException)

  // Verifica errorBlock
  If lRet
    oResponse['hasNext'] := (self:pageSize == Len(aDataBase))
    oResponse['items'] := aDataBase

    self:SetResponse(oResponse:toJson())
  Else
    oResponse['code'] := 001
    oResponse['status'] := 500
    oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
    oResponse['detailedMessage'] := cErroBlk
  EndIf
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
Return lRet
