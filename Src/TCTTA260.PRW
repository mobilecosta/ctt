#INCLUDE "TOTVS.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Envio de email de expiracao de proposta
@author Fabio Veiga Oliva
@version P12
@since 19/12/2019
@return lReturn,Logico,Indica se a turma é valida
/*/
//-----------------------------------------------------------------------------
User Function TCTTA260
Local nOpcao		:= 0
Local oDlg
Local aSays			:= {}
Local aButtons		:= {}
Local lEnd			:= .F.
cCadastro := "Envio de email de expiracao de proposta"

Aadd(aSays,"Este programa tem o objetivo de enviar email sobre expiracao de proposta")

Aadd(aButtons, { 01,.T.,{|o| nOpcao:=1, o:oWnd:End()}})
Aadd(aButtons, { 02,.T.,{|o| o:oWnd:End()}})

FormBatch(cCadastro,aSays,aButtons,,,465)

If nOpcao == 1
	Processa({|| U_TCTTJ261() },"Analisando propostas a expirar...")
EndIf

Return(Nil)

User Function TCTTJ260(aParam)
Local cFUNCDE := "Função TCTTJ260 - Analise de propostas a expirar"
MV_PAR60 := "JOB"
dDataBase := MsDate()
//--------------------------------------------------------------------
// Seta o ambiente para execução através do JOB
//--------------------------------------------------------------------
RpcClearEnv()
RpcSetType(3) // nao usar licença

If(!RpcSetEnv(aParam[1], aParam[2], "", "", "CTT",,{"SM0","PD6","PD7","PD3"}))
	// Conout("------------------------------------------------------------ ---------")
	// Conout("- ERRO NA CHAMADA  ===>> Inicio - " + cFUNCDE )
	// Conout("-   " + dtoc(dDataBase) + " - " + Time() + " - Empresa/Filial: " + aParam[1] + "/" + aParam[2] )
	// Conout("----------------------------------------------------------------------")
else
	// Conout("----------------------------------------------------------------------")
	// Conout("-    ===>> Inicio - " + cFUNCDE )
	// Conout("-   " + dtoc(dDataBase) + " - " + Time() + " - Empresa/Filial: " + aParam[1] + "/" + aParam[2] )
	// Conout("----------------------------------------------------------------------")
	
	//--------------------------------------------------
	// Chama a funcao de processamento
	//--------------------------------------------------
	U_TCTTJ261()
	RpcClearEnv()
	//--------------------------------------------------
	
	// Conout("----------------------------------------------------------------------")
	// Conout("- ===>> Finalização - " + cFUNCDE )
	// Conout("-   " + dtoc(dDataBase) + " - " + Time() + " - Empresa/Filial: " + aParam[1] + "/" + aParam[2] )
	// Conout("----------------------------------------------------------------------")
	
EndIf
Return


User Function TCTTJ261()
Local cEOL 	:= "</br>"                                  
Local dDtFim := dDatabase+15  
Local cEMail := AllTrim(SuperGetMV("TI_CT260P",,"wanderlon.milagre@totvs.com.br"))
//Local cEmail := "fabio.oliva@totvspartners.com.br"

If Select("QUERY") <> 0
	dbSelectArea("QUERY")
	DbCloseArea()
Endif

cQuery  := "SELECT PD6.PD6_FILIAL, PD6.PD6_PROPOS, PD6.PD6_DTFIM"
cQuery	+= " FROM " + RETSQLNAME("PD6") + " PD6 "
cQuery  += " WHERE PD6.PD6_DTFIM >= '" + Dtos(dDatabase) +"' AND PD6.PD6_DTFIM <= '" + Dtos(dDtFim) +"' AND PD6.D_E_L_E_T_ = ' ' "
cQuery  += " AND PD6.PD6_DTAVIS = '' "
cQuery  += " ORDER BY PD6.PD6_PROPOS "

cQuery	:= ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"QUERY",.F.,.T.)
TcSetField ("QUERY","PD6_DTFIM","D",8,0)

DbSelectArea("QUERY")
dbGotop()

While !QUERY->(EOF())
	cAssunto := "Proposta:"+QUERY->PD6_PROPOS+" irá expirar"
	
	cMSG := cEOL+cEOL
	cMSG += "A proposta "+QUERY->PD6_PROPOS+" irá expirar em "+Dtoc(QUERY->PD6_DTFIM)
	cMSG += cEOL+cEOL
	
	cMSG+="</font><br><br><center><img src='http://www.totvs.com/image/company_logo?img_id=10209&t=1368996682280'></img></center><br><br></td></tr><tr bgcolor='#6CA6CD'><td align='center'><Font face='Trebuchet ms'>CTT - Centro de Treinamento TOTVS - " + SM0->M0_FILIAL + "</font></td></tr></table></body></html>"
	
	cMsgMail := "<html><head><title>"+cAssunto+"</title></head><body><table><tr bgcolor='#6CA6CD'><td align='center'><Font face='Trebuchet ms'>"+cAssunto+"</font></td></tr><tr><td><Font face='Trebuchet ms'>"+cEOL+cEOL+'Olá , '+cEOL+cEOL+cMsg
	
	If (lOk := U_xSendMail(cEMail,cAssunto,cMsgMail,, IsBlind(),,,.T.))

	    cComp := PD6->PD6_PROPOS + DTOS(Date())+"_"+StrTran(TIME(), ":", "")
	    U_TCTXLOGM(	"PD6", PD6->PD6_PROPOS , cAssunto, cEMail, cMsgMail,;
				"\temp\tctta133_" + cComp + ".htm", lOk)

		dbSelectArea("PD6")
		dbSetOrder(1)
		If dbSeek(QUERY->PD6_FILIAL+QUERY->PD6_PROPOS)
			RecLock("PD6",.F.)
			PD6->PD6_DTAVIS := dDatabase
			MsUnlock()
		EndIf
	EndIf
	DbSelectArea("QUERY")
	dbSkip()
EndDo
dbCloseArea()
Return

