#include 'protheus.ch'

/*/{Protheus.doc} tcrmx158
Retorno de dados de assinatura - Proposta
@type function
@author eder.oliveira
@since 11/10/2018
@version 1.0
@param ${param}, ${param_type}, ${param_descr}
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
user function tcrmx159
Local aArea         := {}
Local cEmpresa      := ParamIxb[1]
Local cProposta     := ParamIxb[2]
Local cChave        := cEmpresa+cProposta
Local cOperacao     := Iif(POR->POR_CODIGO=='000013','1','2')
Local aAssinantes   := {}
Local oJSon         := NIL
Local cPathLink     := GetMV("TI_URLREST",,"http://172.24.52.10:8048/")
Local cServico      := "ts034assinatura/"
Local cBuffer       := ""
Local cNewPath		:= GetMV("TI_PATHADI",,"\system\word\assinaturaDigital\")
Local cNewFile		:= cChave+".pdf"
Local nPos          := 0
Local oItem         := NIL
Local oCliente      := NIL
Local aJson         := {}

If (nHdl := FOpen(cNewPath+cNewFile)) > -1
    nTamanho := FSEEK(nHdl, 0, 2)
    FSEEK(nHdl, 0)

    FRead( nHdl, @cBuffer,nTamanho)
    FClose(nHDL)
EndIf

dbSelectArea("ADY")
ADY->(dbSetOrder(1))
If !ADY->(dbSeek(xFilial("ADY")+cProposta))
    Return oJSon
EndIf

oJson := JsonUtil():New()
oItem := JsonUtil():New()
oCliente := JsonUtil():New()

oItem:PutVal("empresa"      , cEmpresa)
oItem:PutVal("proposta"     , cproposta)
oItem:PutVal("oportunidade" , ADY->ADY_OPORTU)

oCliente:PutVal("codigo"    , ADY->ADY_CODIGO)
oCliente:PutVal("loja"      , ADY->ADY_LOJA)
oCliente:PutVal("tipo"      , ADY->ADY_ENTIDA)

If ADY->ADY_ENTIDA == "1"
    oCliente:PutVal("razao"     , u_EspecMsg(Posicione("SA1",1,xFilial("SA1")+ADY->ADY_CODIGO+ADY->ADY_LOJA,"A1_NOME") ))
Else
    oCliente:PutVal("razao"     , u_EspecMsg(Posicione("SUS",1,xFilial("SUS")+ADY->ADY_CODIGO+ADY->ADY_LOJA,"US_NOME") ))
EndIf

oItem:PutVal("cliente"      , oCliente )
oItem:PutVal("md5"          , Iif(cOperacao=='1'.And.!Empty(cBuffer),MD5(cBuffer, 2 ),""))
oItem:PutVal("link"         , Iif(cOperacao=='1'.And.!Empty(cBuffer),cPathLink+cServico+cNewFile,""))
oItem:PutVal("validade"     , Iif(cOperacao=='1'.And.!Empty(cBuffer),ADY->ADY_XVALID,""))

If cOperacao=='1'

    dbSelectArea("PP3")
    dbSetORder(1)
    dbSeek(xFilial("PP3")+cProposta)
    Do While !PP3->(EoF()) .and. PP3->(PP3_FILIAL+PP3_PROPOS)==xFilial("PP3")+cProposta

        aAdd(aAssinantes,JsonUtil():New())
        nPos := Len(aAssinantes)

        aAssinantes[nPos]:Putval('nome',u_EspecMsg(Alltrim(PP3->PP3_NOME)))
        aAssinantes[nPos]:Putval('cnpj_cpf',Transform(PP3->PP3_CGC,Iif(Len(Alltrim(PP3->PP3_CGC))==11,'@R 999.999.999-99','@R 99.999.999/9999-99')))
        aAssinantes[nPos]:Putval('email',Alltrim(PP3->PP3_EMAIL))
        aAssinantes[nPos]:Putval('telefone',Alltrim(PP3->PP3_TEL))
        aAssinantes[nPos]:Putval('tipo',PP3->PP3_TPASSI)
        PP3->(dbSkip())

    EndDo

EndIf

oItem:PutVal("assinantes",aAssinantes)

aadd(aJson, oItem)

oJson:PutArray(aJson)

Return(oJson)

//-----------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} EspecMsg
Tratamento de caracteres especiais
@param Nenhum 
@return Nehhum
@author jose camilo
@since 15/05/2018
/*/
//-----------------------------------------------------------------------------------------------------------------------------------------------------
User Function EspecMsg(cTexto)
Default cTexto := ""
cTexto := strtran(cTexto, CHR(1), "")   //
cTexto := strtran(cTexto, CHR(2), "")   //
cTexto := strtran(cTexto, CHR(3), "")   //
cTexto := strtran(cTexto, CHR(4), "")   //
cTexto := strtran(cTexto, CHR(7), "")   //
cTexto := strtran(cTexto, CHR(8), "")   //
cTexto := strtran(cTexto, CHR(9), "")   // TAB
cTexto := strtran(cTexto, CHR(10), "")   //
cTexto := strtran(cTexto, CHR(11), "")  //
cTexto := strtran(cTexto, CHR(12), "")  //
cTexto := strtran(cTexto, CHR(13), "")   //
cTexto := strtran(cTexto, CHR(14), "")  //
cTexto := strtran(cTexto, CHR(15), "")  //
cTexto := strtran(cTexto, CHR(16), "")  //
cTexto := strtran(cTexto, CHR(17), "")  //
cTexto := strtran(cTexto, CHR(18), "")  //
cTexto := strtran(cTexto, CHR(19), "")  //
cTexto := strtran(cTexto, CHR(20), "")  //
cTexto := strtran(cTexto, CHR(21), "")  //
cTexto := strtran(cTexto, CHR(22), "")  //
cTexto := strtran(cTexto, CHR(23), "")  //
cTexto := strtran(cTexto, CHR(24), "")  //
cTexto := strtran(cTexto, CHR(25), "")  //
cTexto := strtran(cTexto, CHR(26), "")  //
cTexto := strtran(cTexto, CHR(27), "")  //
cTexto := strtran(cTexto, CHR(28), "")  //
cTexto := strtran(cTexto, CHR(29), "")  //
cTexto := strtran(cTexto, CHR(30), "")  //
cTexto := strtran(cTexto, CHR(31), "")  //
cTexto := strtran(cTexto, CHR(34), "")  //
cTexto := strtran(cTexto, CHR(127), "") //
cTexto := strtran(cTexto, CHR(128), "") //
cTexto := strtran(cTexto, CHR(131), "") //
cTexto := strtran(cTexto, CHR(132), "") //
cTexto := strtran(cTexto, CHR(133), "") //
cTexto := strtran(cTexto, CHR(134), "") //
cTexto := strtran(cTexto, CHR(135), "") //
cTexto := strtran(cTexto, CHR(137), "") //
cTexto := strtran(cTexto, CHR(138), "") //
cTexto := strtran(cTexto, CHR(139), "") //
cTexto := strtran(cTexto, CHR(140), "") //
cTexto := strtran(cTexto, CHR(142), "") //
cTexto := strtran(cTexto, CHR(145), "") //
cTexto := strtran(cTexto, CHR(146), "") //
cTexto := strtran(cTexto, CHR(147), "") //
cTexto := strtran(cTexto, CHR(148), "") //
cTexto := strtran(cTexto, CHR(149), "") //
cTexto := strtran(cTexto, CHR(152), "") //
cTexto := strtran(cTexto, CHR(153), "") //
cTexto := strtran(cTexto, CHR(154), "") //
cTexto := strtran(cTexto, CHR(155), "") //
cTexto := strtran(cTexto, CHR(156), "") //
cTexto := strtran(cTexto, CHR(158), "") //
cTexto := strtran(cTexto, CHR(159), "") //
cTexto := strtran(cTexto, CHR(161), "") //
cTexto := strtran(cTexto, CHR(162), "") //
cTexto := strtran(cTexto, CHR(163), "") //
cTexto := strtran(cTexto, CHR(164), "") //
cTexto := strtran(cTexto, CHR(165), "") //
cTexto := strtran(cTexto, CHR(166), "") //
cTexto := strtran(cTexto, CHR(167), "") //
cTexto := strtran(cTexto, CHR(169), "") //
cTexto := strtran(cTexto, CHR(171), "") //
cTexto := strtran(cTexto, CHR(172), "") //
cTexto := strtran(cTexto, CHR(173), "") //
cTexto := strtran(cTexto, CHR(175), "") //
cTexto := strtran(cTexto, CHR(176), "") //
cTexto := strtran(cTexto, CHR(177), "") //
cTexto := strtran(cTexto, CHR(178), "") //
cTexto := strtran(cTexto, CHR(179), "") //
cTexto := strtran(cTexto, CHR(181), "") //
cTexto := strtran(cTexto, CHR(182), "") //
cTexto := strtran(cTexto, CHR(183), "") //
cTexto := strtran(cTexto, CHR(184), "") //
cTexto := strtran(cTexto, CHR(185), "") //
cTexto := strtran(cTexto, CHR(187), "") //
cTexto := strtran(cTexto, CHR(188), "") //
cTexto := strtran(cTexto, CHR(189), "") //
cTexto := strtran(cTexto, CHR(190), "") //
cTexto := strtran(cTexto, CHR(198), "") //
cTexto := strtran(cTexto, CHR(208), "") //
cTexto := strtran(cTexto, CHR(215), "") //
cTexto := strtran(cTexto, CHR(216), "") //
cTexto := strtran(cTexto, CHR(221), "") //
cTexto := strtran(cTexto, CHR(222), "") //
cTexto := strtran(cTexto, CHR(223), "") //
cTexto := strtran(cTexto, CHR(230), "") //
cTexto := strtran(cTexto, CHR(248), "") //
cTexto := strtran(cTexto, CHR(253), "") //
cTexto := strtran(cTexto, CHR(254), "") //
cTexto := strtran(cTexto, CHR(255), "") //
cTexto := alltrim(cTexto) //
cTexto := EncodeUTF8(cTexto) //
Return cTexto
