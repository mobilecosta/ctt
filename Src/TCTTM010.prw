#Include 'Protheus.ch'

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Envio de e-mail com as respostas da pesquisa de satisfação

@author Wagner Mobile Costa
@version P12
@since 21/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTT010

U_TCTTM010({ {"ZZ", "01" }, "mobile.costa@gmail.com", "000001", "000001", "000001", {}, "CONFIGURADOR" }) 

Return

User Function TCTTM010(aJobs)

Local aDados	:= {}
Local aDepto	:= {}
Local cCorpo	:= ""
Local cCorpo2	:= ""
Local aEmpresa	:= aJobs[1]
Local cMailP	:= aJobs[2]
Local cPesq		:= aJobs[3]
Local cAluno	:= aJobs[4]
Local nNota     := 0 
Local nFor		:= 0 
Local nX 		:= 0
Local lEnvia	:= .F.

PRIVATE cTurma	:= aJobs[5]
PRIVATE aDadosC	:= aJobs[6]
PRIVATE cCurso	:= aJobs[7]
PRIVATE aTipo	:= {}
Private cOque	:= ""
Private aPesq	:= {}

// ConOut("TCTTM010 - Inicio: " + Time())
RPCSetType(3)  // Nao utilizar licensa
RpcSetEnv(aEmpresa[1],aEmpresa[2],,,'FIN','PESQUISA', { "PD4", "PD8", "PDL" })
nNota := GetMv("TI_CTNOTMN")

aDepto := RetSx3Box( Posicione("SX3", 2, "PDH_DEPTO", "X3CBox()" ),,, 1 )

BeginSQL Alias "PD4QRY"
	SELECT PD4.PD4_ITEM, PD4.PD4_FINALI, PD4.PD4_DEPTO, PD4.PD4_ASSUNT, PD5.PD5_PERGUN, PDG.PDG_CONCEI, PD4.PD4_EQUIV, PDG.PDG_NOTAPO,
	       PD4.PD4_PONTUA, PD4.R_E_C_N_O_ AS PD4_RECNO
	  FROM %table:PD4% PD4
	  JOIN %table:PD5% PD5 ON PD5.%notDel% AND PD5.PD5_FILIAL = %Exp:xFilial("PD5")% AND PD5.PD5_PESQ = PD4.PD4_PESQ
	   AND PD5.PD5_ITEM = PD4.PD4_ITEM
	  LEFT JOIN %table:PDG% PDG ON PDG.%notDel% AND PDG.PDG_FILIAL = %Exp:xFilial("PDG")% AND PDG.PDG_PONTUA = PD4.PD4_PONTUA
	   AND PDG.PDG_EQUIV = PD4.PD4_EQUIV
	 WHERE PD4.%notDel% AND PD4.PD4_FILIAL = %Exp:xFilial("PD4")% AND PD4.PD4_PESQ = %Exp:cPesq% AND PD4.PD4_TURMA = %Exp:cTurma%
	   AND PD4.PD4_ALUNO = %Exp:cAluno%
	 ORDER BY PD4_ITEM  
EndSql

WHILE ! PD4QRY->(Eof())
	PD4->(DbGoTo(PD4QRY->PD4_RECNO))
	PD4QRY->(Aadd(aDados, { cPesq,cAluno,cTurma,PD4_DEPTO,PD4_ITEM,PD4_ASSUNT,PD4_PONTUA,PD4->PD4_RESPOS,PD4->PD4_RESPOS}))
	PD4QRY->(Aadd(aPesq,  { cPesq,PD4_ITEM,PD4_FINALI,PD4_DEPTO,PD4_ASSUNT,PD5_PERGUN,;
							StrTran(PD4->PD4_RESPOS,CHR(13)+CHR(10),'<BR>'), PDG_CONCEI, aDepto[val(PD4_DEPTO)][3], PDG_NOTAPO,;
							PD4_EQUIV } ))

	PD4QRY->(DBSKIP())
EndDo
PD4QRY->(DbCloseArea())

IF LEN(aDados)>0
	ASORT(aDados,,,{|Z,X| Z[1]+Z[2]+Z[3]+Z[4]+Z[5]<X[1]+X[2]+X[3]+X[4]+X[5]})
	Asort(aPesq,,,{|z,x| z[1]+z[3]+z[2]< x[1]+x[3]+x[2] })
	
	PDL->(DBSEEK(xFilial("PDL")+cAluno))
	cEmail	:= ALLTRIM(PDL->PDL_EMAIL)
	cAssunto:= "RESPOSTA DA PESQUISA"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³disparo de e-mail para o aluno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cOque	:= "X"	//Todos os departamentos
	cCorpo 	:= Body(cOque,nNota)+"<BR><BR>"
	
	BeginSQL Alias "PDHQRY"
		SELECT PD8.R_E_C_N_O_ AS PD8_RECNO
		  FROM %table:PDH% PDH
		  LEFT JOIN %table:PD8% PD8 ON PD8.%notDel% AND PD8.PD8_FILIAL = %Exp:xFilial("PD8")% AND PD8.PD8_CODIGO = PDH.PDH_TEMPLA
		 WHERE PDH.%notDel% AND PDH.PDH_FILIAL = %Exp:xFilial("PDH")% AND PDH.PDH_DEPTO = %Exp:cOque% AND PDH.PDH_MSBLQL = '2'
		 ORDER BY PDH_CODIGO,PDH_ITEM
	EndSql

	WHILE ! PDHQRY->(Eof())
		PD8->(DbGoto(PDHQRY->PD8_RECNO))

		If ! Empty(PD8->PD8_MSG)
			cCorpo += PD8->PD8_MSG+'<BR>'
		EndIf

		PDHQRY->(DBSKIP())
	EndDo
	PDHQRY->(DbCloseArea())

	cCorpo := STRTRAN(cCorpo,CHR(13)+CHR(10),'<BR>')
	U_xSendMail(cEMail,cAssunto,cCorpo,, IsBlind(),,,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Email para o professor³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cOque	:= "X"	//-- Todos os departamentos
	cCorpo 	:= Body(cOque,nNota)+"<BR><BR>"
	U_xSendMail(cMailP,cAssunto + " - PROFESSOR",cCorpo,, IsBlind(),,,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Email para os departamentos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nFor :=  1 to len(aDepto)
		cOque := aDepto[nFor][2]
		If Empty(cOQue)
			Loop
		EndIf 
		cEmail	:= ""
		cCorpo2	:= ""
		
		lEnvia := .F.
		For nX := 1 to len(aPesq)
			If nFor < 5 .And. cOQue <> aPesq[nX][4]
				Loop
			EndIf  
			
			If (! Empty(aPesq[nX][11]) .And. nNota >= aPesq[nX][10]) .Or. ! Empty(aPesq[nX][7])
				lEnvia := .T.
			EndIf
		Next
		
		If ! lEnvia
			Loop
		EndIf		

		BeginSQL Alias "PDHQRY"
			SELECT PDH.PDH_EMAIL, PD8.R_E_C_N_O_ AS PD8_RECNO
			  FROM %table:PDH% PDH
			  LEFT JOIN %table:PD8% PD8 ON PD8.%notDel% AND PD8.PD8_FILIAL = %Exp:xFilial("PD8")% AND PD8.PD8_CODIGO = PDH.PDH_TEMPLA
			 WHERE PDH.%notDel% AND PDH.PDH_FILIAL = %Exp:xFilial("PDH")% AND PDH.PDH_DEPTO = %Exp:cOque% AND PDH.PDH_MSBLQL = '2'
			 ORDER BY PDH_CODIGO,PDH_ITEM
		EndSql

		WHILE ! PDHQRY->(Eof())
			PD8->(DbGoto(PDHQRY->PD8_RECNO))

			cEmail	+= AllTrim(PDHQRY->PDH_EMAIL)+';'
			If ! Empty(PD8->PD8_MSG)
			   cCorpo2 += PD8->PD8_MSG+'<BR>'
			EndIf
			
			PDHQRY->(DBSKIP())
		EndDo
		PDHQRY->(DbCloseArea())
		
		If ! Empty(cEMail)
			If cOQue == "5"	//-- Aluno
				cOQue := "X"	//-- Todos os departamentos
			EndIf
			cCorpo 	:= Body(cOque,nNota)
			cCorpo  += "<BR><BR>"+cCorpo2
			U_xSendMail(cEmail,cAssunto + " - " + aDepto[nFor][1],cCorpo,, IsBlind(),,,.T.)
		EndIf
	Next nFor
ENDIF
// ConOut("TCTTM010 - Fim: " + Time())

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem do corpo do e-mail da pesquisa de satisfação

@author Wagner Mobile Costa
@version P12
@since 21/04/2015
/*/
//-----------------------------------------------------------------------------
Static Function Body(cDpto, nNota)

Local cFinalid	:= ""
Local nVolta	:= 0
Local cRet 		:= ""
Local aTipo 	:= RetSx3Box( Posicione("SX3", 2, "PD3_PERIOD", "X3CBox()" ),,, 1 )
Local nFor 		:= 0

If Len(aDadosC) = 0
	Return cRet
EndIf

cRet += "<html> "
cRet += "<body>"

cRet += '	<table width="100%" border="0" cellpadding="1" cellspacing="1" style="border-width: 0px; background-color: transparent;">'
if cOque <> 'X'
	cRet += '	   <tr valign="top">'
	cRet += '	   	   <td >'
	cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style:oblique; font-weight:bold;  color: #000000; background-color: transparent; text-decoration: none;">'
	cRet += '			  		CPF / Nome:'
	cRet += '			  </span>'
	cRet += '		   </TD> '
	cRet += '		   <td >'
	cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style: normal; font-weight: normal; color: #000000; background-color: transparent; text-decoration: none;">'
	cRet += ' &nbsp;&nbsp;<B>
	cRet += aDadosC[1][1]+' &nbsp;/&nbsp;'+aDadosC[1][2]
	cRet += '				 </B> </span>'
	cRet += '		   </TD>'
	cRet += '	   </TR>'
	cRet += '	   <tr valign="top">'
	cRet += '	       <td >'
	cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style:oblique; font-weight:bold;  color: #000000; background-color: transparent; text-decoration: none;">'
	cRet += '			  		</span>'
	cRet += '		   </TD> '
	cRet += '		   <td >'
	cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style: normal; font-weight: normal; color: #000000; background-color: transparent; text-decoration: none;"> <B>'
	cRet += aDadosC[1][3]
	cRet += '			</B></span>'
	cRet += '		   </TD>'
	cRet += '	   </TR>'
EndIf
cRet += '	   <tr valign="top">'
cRet += '		   <td >'
cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style:oblique; font-weight:bold;  color: #000000; background-color: transparent; text-decoration: none;">'
cRet += '			  	 Turma: </span>'
cRet += '		   </TD> '
cRet += '		   <td >'
cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style: normal; font-weight: normal; color: #000000; background-color: transparent; text-decoration: none;">'
cRet += '&nbsp;&nbsp; <B>'
cRet += cTurma +' &nbsp;&nbsp;'
cRet += '			 </B></span>       '
cRet += '	       </td>          '
cRet += '	   </TR>             '
cRet += '	   <tr valign="top">'
cRet += '		   <td >'
cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style:oblique; font-weight:bold;  color: #000000; background-color: transparent; text-decoration: none;">'
cRet += '			  		Curso/Professor:</span>  '
cRet += '		   </TD>  '
cRet += '		   <td > '
cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style: normal; font-weight: normal; color: #000000; background-color: transparent; text-decoration: none;">'
cRet += ' &nbsp;&nbsp; <B>'
cRet += cCurso
cRet += '			 </B></span>'
cRet += '	       </td>'
cRet += '	   </TR> '
cRet += '	   <tr valign="top">'
cRet += '		   <td >'
cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style:oblique; font-weight:bold;  color: #000000; background-color: transparent; text-decoration: none;">'
cRet += '			  		Data: </span>  '
cRet += '		   </TD>  '
cRet += '		   <td > '
cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style: normal; font-weight: normal; color: #000000; background-color: transparent; text-decoration: none;">'
cRet += ' &nbsp;&nbsp; <B> '
cRet += aDadosC[1][11]+ ' - '+ aDadosC[1][12]
cRet += '			 </B></span>'
cRet += '	       </td>'
cRet += '	   </TR> '
cRet += '	   <tr valign="top">'
cRet += '		   <td >'
cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style:oblique; font-weight:bold;  color: #000000; background-color: transparent; text-decoration: none;">'
cRet += '			  		Periodo</span>  '
cRet += '		   </TD>  '
cRet += '		   <td > '
cRet += '		   	  <span style=" font-size: 10pt; font-family: "Arial", "Helvetica", sans-serif; font-style: normal; font-weight: normal; color: #000000; background-color: transparent; text-decoration: none;">'
cRet += ' &nbsp;&nbsp; <B>  '
nTipo := aScan(aTipo,{|z| alltrim(z[2]) = alltrim(aDadosC[1][13])})
cRet += aTipo[nTipo][3]
cRet += '			 </B></span>'
cRet += '	       </td>'
cRet += '	   </TR> '
cRet += '	</table>'

cRet += '<div style=" text-align: left; text-indent: 0px; padding: 0px 0px 0px 0px; margin: 0px 0px 0px 0px;"> '
cRet += '<div id="objetos">'
For nFor := 1 to len(aPesq)
	IF cOque == '0' .OR. cOque == 'X' .or. cOque == aPesq[nFor][4]
		IF (nNota >= aPesq[nfor][10] .Or. ! Empty(aPesq[nFor][7])) .OR. cOque == 'X'
			if !(aPesq[nFor][3] $ cFinalid)
				cFinalid += aPesq[nFor][3]+','
				cRet += '<hr align="center" width="100%" size="2" color="#1D197B" />'
				cRet += "<b> "
				cRet += "Pergunta " + strzero(val(aPesq[nFor][3]),2)+'  '+ aPesq[nFor][9]
				cRet += "</b>"
				nVolta := 0
				cRet += "<BR>"
			Endif
			nVolta += 1
			if !Empty(aPesq[nFor][6])
				cRet += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+ aPesq[nFor][3]+'.'+strzero(nVolta,2) +"&nbsp;&nbsp;"+	aPesq[nFor][6]
			Endif
			if aPesq[nFor][5] =='1'
				if alltrim(aPesq[nFor][4]) != cDpto .and. cDpto != '0' .OR. cOque == 'X'
					cRet += aPesq[nFor][8]
				else
					cRet += 'Pontuação '+ aPesq[nfor][8]
				Endif
			Elseif alltrim(aPesq[nFor][4]) == cDpto .or. cDpto == '0' .OR. cOque == 'X'
				cRet += "<br>"
				cRet += 'INFORMAÇÃO DIGITADA: '+ aPesq[nFor][7]
			Endif
			cRet += "<br>"
		ENDIF
	ENDIF
Next nFor
cRet += '<hr align="center" width="100%" size="2" color="#1D197B" />'
cRet += "</div>"
cRet += "</body>"
cRet += "</html>"

return(cRet)
