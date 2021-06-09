#INCLUDE "TCTTA131.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina para impressão do certificado para os alunos
@author Fabio José Batista
@version P12
@since 16/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA131()

oMark := FWMarkBrowse():New()
oMark:SetAlias('PD7')
oMark:SetSemaphore(.T.)
oMark:SetDescription(STR0001 + PD3->PD3_TURMA + "]") // "Imprimir certificado do aluno ["
oMark:SetFieldMark( 'PD7_EV' )
oMark:SetAllMark( { || oMark:AllMark() } )
oMark:SetMenuDef("TCTTA131")
oMark:SetFilterDefault("PD7_FILIAL = '" + PD3->PD3_FILIAL + "' .AND. PD7_TURMA = '"  + PD3->PD3_TURMA + "' .AND. " +;
                      "(PD7_CONFIR = '1' .OR. PD7_CONFIR = '5' .OR. PD7_CONFIR = '6')")
oMark:Activate()

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo do cadastro de Alocação
@author Fabio José Batista
@version P12
@since 16/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

    ADD OPTION aRotina TITLE STR0008   ACTION 'U_TCTT131P' 		 OPERATION 4 ACCESS 0 //"Imprimir certificado"

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Tela para seleção dos alunos da turma que irão ter alteração da alocação aprovada
@author Fabio José Batista
@version P12
@since 16/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------

USER FUNCTION TCTT131P(cAlias,nRec,nOpcX)

//Declaracao de variaveis
Private oDlg    := NIL
Private cTitulo := STR0002 //"Impressao"
Private oFont0 := Tfont():New ( "Times New Roman"	,  0,28 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .T./*ITALICO*/    )
Private oFont1 := Tfont():New ( "Arial" 			,  0,22 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private oFont2 := Tfont():New ( "Calibri" 			,  0,20 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .T./*ITALICO*/    )
Private oFont3 := Tfont():New ( "Calibri" 			,  0,18 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .T./*ITALICO*/    )
Private oFonth := Tfont():New ( "Helvetica Condensed",0,22 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private cAcesso  := Repl(" ",10)
Private lCertNV := .t.

Public oPrn    := NIL

oPrn := TMSPrinter():New(cTitulo)
oPrn:SetPaperSize(9)
oPrn:SetLandscape()

Prep_obj()
Monta_interface()

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Monta interface com o usuario
@author Fabio José Batista
@version P12
@since 16/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
    
Static Function Monta_interface()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

	@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL
	
	@ 015,017 SAY STR0003 OF oDlg PIXEL Size 150,010  COLOR CLR_HBLUE //"Impressão de Certificados"

	@ 06,167 BUTTON STR0004 SIZE 036,012 ACTION oPrn:Print()   OF oDlg PIXEL //"&Imprime"
	@ 28,167 BUTTON STR0009   SIZE 036,012 ACTION oPrn:Setup()   OF oDlg PIXEL //"&Setup"
	@ 49,167 BUTTON STR0010 SIZE 036,012 ACTION oPrn:Preview() OF oDlg PIXEL //"Pre&view"
	@ 70,167 BUTTON STR0005    SIZE 036,012 ACTION oDlg:End()     OF oDlg PIXEL //"Sai&r"

	                                                                                         
ACTIVATE MSDIALOG oDlg CENTERED

Return( NIL )
                

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Impressão do certificado do aluno
@author Fabio José Batista
@version P12
@since 16/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------

Static Function Prep_obj()

Local aArea		:= PD3->(GetArea())
Local nI 		:= 1
Local nlin 		:= 800
Local npos 		:= 0
Local cMarca   	:= oMark:Mark()
Local nX := 0
Local cTexto 	:= ""
Local cEOL 		:= CHR(10)+CHR(13)
Local oDlg
Local oMemo
Local aRecSel 	:={}
Local cCodCurCtr:= ALLTRIM(PD3->PD3_CONTRO)
Local dDtIniCt  := CTOD("")
Local cEstAss	:= TABELA("Z2",SM0->M0_ESTCOB)                    //-- SX5 - RESPONSAVEL ASSINATURA CERTIFICADO POR ESTADO
Local cAssCerNV := GetMv("TI_CTTASS")

PDL->(DbSetOrder(1))
PD7->(DbSetOrder(1))
PD2->(DbSetOrder(1)) 
PD2->(dbSeek(xFilial("PD2")+PD3->PD3_PROF))

FWMARKBRW->(DbGoTop())
While ! FWMARKBRW->(EOF())
	PD7->(DbGoTo(Val(FWMARKBRW->RECNO)))
	If PD7->PD7_TURMA == PD3->PD3_TURMA
		If oMark:IsMark(cMarca)
			PDL->(dbSeek(xFilial("PDL")+PD7->PD7_ALUNO))
			AADD(aRecSel,{PD7->(Recno()),;  // 01
										PD7->PD7_TURMA,; // 02
										PDL->PDL_NOME,; // 03
										PD3->PD3_NOME,; //04
										PD2->PD2_NOME,;  //05
										PD3->PD3_DTINI,; //6
										PD3->PD3_DTFIM,; //7
										PD3->PD3_CONTRO,;//08
									    dDtIniCt,; //09
										PD3->PD3_CTRCUR,;//10
										PD7->PD7_SEGMEN})//11
	
		ENDIF
	EndIf

	FWMARKBRW->(DbSkip())
EndDo

For nI:= 1 to len(aRecSel)
	oPrn:StartPage()
	nPos := U_Centralizar(aRecSel[nI][3],oFont0,-200,oPrn:nHorzRes())  //Função para centralizar....Texto, Fonte, posição Inicial, Posição Final
	oPrn:StartPage()

	oPrn:Say(  nlin, 1250 , Capital(aRecSel[nI][3])  ,oFont0) // Aluno
	nlin+=200
	npos:= 1300

	If lCertNV
		oPrn:Say(  nlin+20, npos - 100 , aRecSel[nI][4]  ,oFonth)    // Curso
		npos:= 1100
		nlin+=160
	Else
		oPrn:Say(  nlin+10, npos -100 , aRecSel[nI][4]  ,oFonth)    // Curso 75
		npos:= 1100
		nlin+=120
	EndIf

	If aRecSel[nI][8] = "S" .AND. EMPTY(ALLTRIM(cCodCurCtr))     //Cpo Controller
		If lCertNV
			oPrn:Say(  nlin+10, npos , DTOC(aRecSel[nI][6]) +"                       "+ALLTRIM(DTOC(aRecSel[nI][7]))  ,oFonth)
			nlin+=160
			npos:= 1050
		Else
			oPrn:Say(  nlin, npos , DTOC(aRecSel[nI][6]) +"                   "+ALLTRIM(DTOC(aRecSel[nI][7]))  ,oFonth)
			nlin+=118
			npos:= 1050
		EndIf

	ElseIf aRecSel[nI][8] = "S" .AND. !EMPTY(ALLTRIM(cCodCurCtr))  //Cpo Controller
		If lCertNV
			oPrn:Say(  nlin+10, npos , ALLTRIM(DTOC(aRecSel[nI][9]))+"                       "+ALLTRIM(DTOC(aRecSel[nI][7]))  ,oFonth)
			nlin+=160
			npos:= 1050
		Else
			oPrn:Say(  nlin, npos , ALLTRIM(DTOC(aRecSel[nI][9]))+"                   "+ALLTRIM(DTOC(aRecSel[nI][7]))  ,oFonth)
			nlin+=118
			npos:= 1050
		EndIf
	ElseIf aRecSel[nI][8] = "S" .AND. !EMPTY(ALLTRIM(cCodCurCtr)) .AND. aRecSel[nI][11] = "N" //Cpo Controller e Segmentado
		If lCertNV
			 oPrn:Say(  nlin+10, npos , ALLTRIM(DTOC(aRecSel[nI][9]))+"                       "+ALLTRIM(DTOC(aRecSel[nI][7]))  ,oFonth)
			 nlin+=160
			 npos:= 1050
		Else
			 oPrn:Say(  nlin, npos , ALLTRIM(DTOC(aRecSel[nI][9]))+"                   "+ALLTRIM(DTOC(aRecSel[nI][7]))  ,oFonth)
			 nlin+=118
			 npos:= 1050
		EndIf
	Else
		If lCertNV
			oPrn:Say(  nlin+10, npos , ALLTRIM(DTOC(aRecSel[nI][6]))+"                       "+ALLTRIM(DTOC(aRecSel[nI][7]))  ,oFonth)  // Data INI - Data FIN
			nlin+=160
			npos:= 1050
		Else
			oPrn:Say(  nlin, npos , ALLTRIM(DTOC(aRecSel[nI][6]))+"                   "+ALLTRIM(DTOC(aRecSel[nI][7]))  ,oFonth)  // Data INI - Data FIN
			nlin+=118
			npos:= 1050
		EndIf

	Endif

	If aRecSel[nI][8] = "S" .AND. aRecSel[nI][11] = "S"  //Cpo Controller e Segmentado
		If lCertNV
	 		oPrn:Say(  nlin+20, npos , cValToChar(PD3->PD3_QTDHOR)+STR0006  ,oFonth) //" horas"
			npos:= 700
			nlin+=300
	    Else
			oPrn:Say(  nlin, npos , cValToChar(PD3->PD3_QTDHOR)+STR0006  ,oFonth) //" horas"
		  	npos:= 1000
			nlin+=240
      	EndIf
	ElseIf aRecSel[nI][8] = "S" .AND. aRecSel[nI][11] = "N"
		If lCertNV
	 		oPrn:Say(  nlin+20, npos , cValToChar(PD3->PD3_QTDHOR)+STR0006  ,oFonth) //" horas"
		   	npos:= 700
		   	nlin+=300
		Else
			oPrn:Say(  nlin, npos , cValToChar(PD3->PD3_QTDHOR)+STR0006  ,oFonth) //" horas"
		   	npos:= 1000
		   	nlin+= 240
		EndIf
	Else
		If lCertNV
			oPrn:Say(  nlin+20, npos , cValToChar(PD3->PD3_QTDHOR)+STR0006  ,oFonth) //" horas"
		   	npos:= 900
		   	nlin+= 300
		Else
			oPrn:Say(  nlin, npos , cValToChar(PD3->PD3_QTDHOR)+STR0006  ,oFonth) //" horas"
		   	npos:= 1000
		   	nlin+=240
    	EndIf
	Endif
	
	If lCertNV
		oPrn:Say(  nlin, npos - 20, Capital(Alltrim(SM0->M0_CIDCOB)) ,oFonth)
		npoDts := npos
		oPrn:Say(  nlin, npoDts +  785 , strzero(day(PD3->PD3_DTFIM),2)  ,oFonth)
	Else	
		oPrn:Say(  nlin, npos - 200 , Capital(Alltrim(SM0->M0_CIDCOB)) ,oFonth)
		npoDts := npos
		oPrn:Say(  nlin, npoDts +  680 , strzero(day(PD3->PD3_DTFIM),2)  ,oFonth)
	EndIf 
		
	If lCertNV
		oPrn:Say(  nlin, npoDts + 1280 , ALLTRIM(MESEXTENSO(MONTH(PD3->PD3_DTFIM))) ,oFonth)
		oPrn:Say(  nlin, npoDts + 1900 , str(year(PD3->PD3_DTFIM))  ,oFonth)
		nlin+=540
	Else
		oPrn:Say(  nlin, npoDts + 1000 , ALLTRIM(MESEXTENSO(MONTH(PD3->PD3_DTFIM))) ,oFonth)
		oPrn:Say(  nlin, npoDts + 1800 , str(year(PD3->PD3_DTFIM))  ,oFonth)	
		nlin+=580
	EndIf
	
	nPos := U_Centralizar(Capital(aRecSel[nI][5]),oFont3,-150,1300)  //Função para centralizar....Texto, Fonte, posição Inicial, Posição Final

	If lCertNV		
		oPrn:Say(  nlin - 30, npos - 142, UPPER(aRecSel[nI][5])  ,oFont3) //Instrutor
	Else
		oPrn:Say(  nlin - 30, npos , UPPER(aRecSel[nI][5])  ,oFont3) //Instrutor
	EndIf
			
	nPos := U_Centralizar(cEstAss,oFont3,-1900,1300)  //Função para centralizar....Texto, Fonte, posição Inicial, Posição Final
	                                                               	
	If lCertNV		
		oPrn:SayBitmap( nlin - 330 , npos + 290, AllTrim(cAssCerNV),760, 330, , .T. )
		oPrn:Say(  nlin - 30, npos + 300 , cEstAss  ,oFont3)
	Else	
		oPrn:SayBitmap( nlin - 330 , npos + 40, AllTrim(cAssCerNV),760, 330, , .T. )
		oPrn:Say(  nlin - 30, npos , cEstAss  ,oFont3)
	EndIf

	oPrn:EndPage()
	nlin := 800
Next nI

oPrn:End()

Return( NIL )