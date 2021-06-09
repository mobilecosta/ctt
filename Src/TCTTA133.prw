#INCLUDE "TCTTA133.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"
#Include "AP5MAIL.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina para aprovação envio de e-mail de confirmação da inscrição
@author Fabio José Batista
@version P12
@since 17/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA133()

oMark := FWMarkBrowse():New()
oMark:SetAlias('PD7')
oMark:SetSemaphore(.T.)
oMark:SetDescription(STR0001 + PD3->PD3_TURMA + "-" + AllTrim(PD3->PD3_NOME) + "]") // "Envio de email de confirmação da inscrição ["
oMark:SetFieldMark( 'PD7_EV' )
oMark:SetAllMark( { || oMark:AllMark() } )
oMark:SetMenuDef("TCTTA133")
oMark:SetFilterDefault("PD7_FILIAL = '" + PD3->PD3_FILIAL + "' .AND. PD7_TURMA = '"  + PD3->PD3_TURMA + "' .AND. " +;
                      "(PD7_CONFIR = '1' .OR. PD7_CONFIR = '5' .OR. PD7_CONFIR = '6')") 
oMark:Activate()       
 
Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem do menu da tela de envio de email de confirmação de alocação
@author Fabio José Batista
@version P12
@since 17/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0011   ACTION 'U_TCTT133M' 		 OPERATION 4 ACCESS 0 //"Enviar"

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Envio de email
@author Fabio José Batista
@version P12
@since 17/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTT133M

Local cMsgMail    := cMsg := cAssunto := ''
Local cEOL 	  	  := "</br>"
Local cInstrutor  := ""
Local cMarca      := oMark:Mark()
Local cPerg 	  := "TCTTA130"
Local nEnviados   := 0
Local nErros 	  := 0
Local nAlunos 	  := 0
Local aAlunos	  := {}
Local cTI_CTHRVER := GetMv("TI_CTHRVER")
Local cUsrMail    := AllTrim(UsrRetMail(__cUserId))
Local cEMail 	  := cComp := ""
Local lOk	  := .F.

Private cMensagem := ""

PDL->(DbSetOrder(1))

FWMARKBRW->(DbGoTop())
While ! FWMARKBRW->(EOF())
	PD7->(DbGoTo(Val(FWMARKBRW->RECNO)))

	If PD7->PD7_TURMA == PD3->PD3_TURMA .And. oMark:IsMark(cMarca)
		Aadd(aAlunos, PD7->PD7_ALUNO)
	EndIf

	FWMARKBRW->(DbSkip())
EndDo

If Len(aAlunos) == 0
	MsgInfo(STR0002) //"Nenhum aluno foi selecionado para o envio do e-mail !"
	Return .F.
EndIf

If ! Pergunte(cPerg,.T.)
	Return
EndIf

DbSelectArea("PD8")
DbSetOrder(1)
DbSeek(xFilial("PD8")+MV_PAR01)

If MV_PAR02 == 01
	cAssunto := STR0003 + " - " + PD3->PD3_TURMA + " - " + ALLTRIM(SM0->M0_FILIAL) //"Confirmação de Recebimento Inscrição Curso TOTVS "

	cMSG := STR0012+cEOL+cEOL //"Segue a confirmação de Recebimento Inscrição:"
	cMSG += STR0019+PD3->PD3_NOME+cEOL //"Curso: "
	cMSG += ''+cEOL

	DbSelectArea("PDI")
	DbSetOrder(1)
	DbSeek(xFilial("PDI") + PD3->PD3_TURMA )

	While !PDI->(EOF()) .AND. PDI->PDI_TURMA = PD3->PD3_TURMA
		cMSG += STR0020 + DTOC(PDI->PDI_DATA) + ' (' + FG_CDOW(PDI->PDI_DATA) +; //"Datas: "
		   		STR0021 + TRANSFORM(PDI->PDI_HRINI,"@R 99:99") +; //") - Horário Início: "
		   		STR0022+ TRANSFORM(PDI->PDI_HRFIM,"@R 99:99")+'h' //"h - Horário Fim: "
	   	If ! Empty(PDI->PDI_INTER) .And. PDI->PDI_INTER <> "0000"
			cMsg += " - Intervalo: " + TRANSFORM(PDI->PDI_INTER,"@R 99:99")+'h'
		EndIf
	   	If ! Empty(cTI_CTHRVER)
	      	cMSG += ' (*)'
	   	EndIf
	   	cMSG += cEOL+cEOL
	   	PDI->(DbSkip())
	Enddo
	If ! Empty(cTI_CTHRVER)
	   cMSG += '(*) '+cTI_CTHRVER+cEOL+cEOL
	EndIf
	cMSG += ''+cEOL

	If PD3->PD3_CATEG = "4"
		cMSG += STR0016+cEOL //"Local: NO CLIENTE "
	ElseIf PD3->PD3_CATEG <> "5"

		cMSG += STR0023 + ALLTRIM(SM0->M0_FILIAL) + ' '+cEOL //"Local: TOTVS "
		cMSG += ''+cEOL
		If SM0->M0_CODFIL = '00001000800' .OR. SM0->M0_CODFIL = '00001000100' 
				If SM0->M0_CODFIL = '00001000800'
					cMSG += STR0024 + 'Rua Buenos Aires, 90/ Salas 501 a 507 - Edifício Vicente de Araújo'// "End: "
					cMSG += ' '+cEOL+cEOL
					cMSG += STR0025 + '20.070-020 - ' + SM0->M0_BAIRENT + ' - ' + SM0->M0_CIDENT + ' / ' + SM0->M0_ESTENT + ' '+cEOL //"CEP: "
				Else
					cMSG += STR0024 + 'Avenida Brás Leme, 1000' // "End: "
					cMSG += ' '+cEOL+cEOL
					cMSG += STR0025 + TRANSFORM(SM0->M0_CEPENT, "@R 99.999-999") + ' - ' + SM0->M0_BAIRENT + ' - ' + SM0->M0_CIDENT + ' / ' + SM0->M0_ESTENT + ' '+cEOL //"CEP: "
					cMsg += cEOL+cEOL
					cMsg += ' Estacionamento terceirizado pela empresa Garageinn .'
					cMsg += cEOL
					cMsg += ' E-mail: garageinn.com.br'
					cMsg += cEOL
					cMsg += ' Telefone: (11) 3230-3082'
					cMsg += cEOL
					cMsg += ' Segue valores :'
					cMsg += cEOL
					cMsg += ' R$ 40,00 - 12 horas.'
					cMsg += cEOL
					cMsg += ' R$ 15 ,00 – Primeira Hora'
					cMsg += cEOL
					cMsg += ' R$ 05,00 – Demais horas.'
				EndIf
			Else
				cMSG += STR0024 + ALLTRIM(SM0->M0_ENDENT)
				cComp := POSICIONE("SX5",1,Left(SM0->M0_CODFIL,11)+"ZA" + SM0->M0_CODIGO,"X5_DESCRI") 
				If Empty(cComp)
				   cComp := SM0->M0_COMPENT
				   	cMsg += ' '+cEOL+cEOL //"End.: "
				   cMSG += STR0025 + TRANSFORM(SM0->M0_CEPENT, "@R 99.999-999") + ' - ' + SM0->M0_BAIRENT + ' - ' + SM0->M0_CIDENT + ' / ' + SM0->M0_ESTENT + ' '+cEOL //"CEP: "
				EndIf
				If ! Empty(cComp)
				   cMsg += " - " + cComp
				   cMsg += ' '+cEOL+cEOL //"End.: "
				   cMSG += STR0025 + TRANSFORM(SM0->M0_CEPENT, "@R 99.999-999") + ' - ' + SM0->M0_BAIRENT + ' - ' + SM0->M0_CIDENT + ' / ' + SM0->M0_ESTENT + ' '+cEOL //"CEP: "
				EndIf		
			EndIf
	Endif
			
	cMSG += ''+cEOL+cEOL
	cMSG += STR0026 + TABELA("Z4",ALLTRIM(SM0->M0_ESTCOB)) + ''+cEOL    // SX5 - TELEFONES CONTATO POR ESTADO //"Telefone: "
	cMSG += ''+cEOL
	cMSG += ''+cEOL
	cMSG += STR0006+cEOL //"<font color='red' face='calibri light ms' size='2'><strong>Observações:</strong></font>"
	cMSG += ''+cEOL+cEOL
	cMSG += STR0027+cEOL //"<b>1.	</b>Informamos que a TOTVS Educação Empresarial se reserva ao direito de extinguir e/ou não oferecer o curso contratado pelo cliente, na hipótese de não existência de quórum mínimo de alunos inscritos. A TOTVS Educação Empresarial poderá também, a seu exclusivo critério, caso exista a disponibilidade de vagas, transferir os alunos inscritos para outras datas, conforme calendário vigente, de acordo com o item 10. Cancelamento de Curso, descrito na política de treinamento presencial, enviada previamente pela área comercial."
	cMSG += ''+cEOL+cEOL
	cMSG += STR0028 //"<b>2.	</b>Favor atentar ao seu e-mail, pois enviaremos a confirmação com 03 dias de antecedência a data de realização do treinamento."
	cMSG += ''+cEOL
	cMSG += '<br><br>Qualquer dúvida,  estamos à disposição nos telefones: ' + TABELA("Z4",ALLTRIM(SM0->M0_ESTCOB)) + ' ou pelo e-mail ' + LOWER(TABELA("Z3",ALLTRIM(SM0->M0_ESTCOB))) + ''+cEOL
    If ! Empty(MV_PAR03)
   		cMSG += "<br><br><b>Observação:</b>" + MV_PAR03 +cEOL
	Endif
ELSE
	cAssunto  := ALLTRIM(PD8->PD8_ASSUNT)
	cMSG += PD8->PD8_MSG
EndIf

If SM0->M0_ESTCOB != "SP"
	cMSG:= cMSG+"</font><br><br><center><img src='http://www.totvs.com/image/company_logo?img_id=10209&t=1368996682280'></img></center><br><br></td></tr><tr bgcolor='#6CA6CD'><td align='center'><Font face='calibri light' size='2'>" +;
           STR0013 + SM0->M0_FILIAL + "</font></td></tr></table></body></html>" //"CTT - Centro de Treinamento TOTVS - "
Else
	cMSG:= cMSG+"</font><br><br><center><img src='http://www.totvs.com/image/company_logo?img_id=10209&t=1368996682280'></img></center><br><br></td></tr>"
	cMSG+= STR0008 + SM0->M0_FILIAL + "</font></td></tr><br><center><img src='http://img13.imageshack.us/img13/1762/z80a.png'></img></center><br><br></table></body></html>" //"<center><tr><td align='center'><Font face='calibri light' size='2'>CTT - Endereço Centro de Treinamento TOTVS - "
Endif

For nAlunos := 1 To Len(aAlunos)
	PDL->(DbSeek(xFilial() + aAlunos[nAlunos]))
	cMsgMail := "<html><head><title>"+cAssunto+;
				 "</title></head><body><table><tr bgcolor='#6CA6CD'><td align='center'><Font face='calibri light' size='2'>"+cAssunto+;
				 "</font></td></tr><tr><td><Font face='calibri light' size='2'>"+cEOL+cEOL+STR0018+ALLTRIM(PDL->PDL_NOME)+', '+cEOL+cEOL+cMsg //"Olá "

	cEMail := ALLTRIM(PDL->PDL_EMAIL) + ";" + cUsrMail
	If (lOk := U_xSendMail(cEMail,cAssunto,cMsgMail,, IsBlind(),,,.T.))
		nEnviados ++
	Else
		nErros ++
	EndIf
	cComp := PDL->PDL_ALUNO + DTOS(Date())+"_"+StrTran(TIME(), ":", "")
	U_TCTXLOGM(	"PD3", PD3->PD3_TURMA + cComp, cAssunto, cEMail, cMsgMail,;
				"\temp\tctta133_" + cComp + ".htm", lOk)
Next

cMensagem := ""
If nEnviados > 0
	cMensagem := STR0014 + AllTrim(Str(nEnviados)) + STR0015 //"Foi(ram) enviado(s) "###" email(s) com sucesso !"
EndIf
If nErros > 0
	If ! Empty(cMensagem)
		cMensagem += Chr(13) + Chr(10)
	EndIf
	cMensagem += STR0016 + AllTrim(Str(nErros)) + STR0017 //"Houve erro no envio do(s) "###" email(s) !"
EndIf
MsgInfo(cMensagem)

Return