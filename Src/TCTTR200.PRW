#INCLUDE "TCTTR160.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
      
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina de impressão do histórico da recorrencia da Proposta

@author Fabio Veiga Oliva
@version P12
@since 24/01/2020
/*/
//-----------------------------------------------------------------------------
USER FUNCTION TCTTR200()

//Declaracao de variaveis
Private oDlg    := NIL 
Private cTitulo := STR0001 //"Impressao"
Private oFont0 := Tfont():New ( "Calibri" 			  ,  0,20 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private oFont1 := Tfont():New ( "Calibri" 			  ,  0,12 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private oFont2 := Tfont():New ( "Calibri" 			  ,  0,20 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .T./*ITALICO*/    )
Private oFont3 := Tfont():New ( "Calibri" 			  ,  0,14 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private oFont4 := Tfont():New ( "Courier New" 		  ,  0,12 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )

Private cAcesso  := SPACE(10)

Private oPrn    := NIL
Private aVetPD9 := {}

If PD6->PD6_TIPO == '2' //Recorrente
   dbSelectArea("PGE")
   dbSetOrder(1)
   If dbSeek(PD6->PD6_FILIAL+PD6->PD6_PROPOS)
      While !Eof() .And. PGE->PGE_FILIAL+PGE->PGE_PROPOS == PD6->PD6_FILIAL+PD6->PD6_PROPOS
        IF PGE->PGE_TIPO == "I"
           cDescr := " "+Dtoc(Posicione("PGD",1,PGE->PGE_FILIAL+PGE->PGE_PROPOS+PGE->PGE_PERIOD,"PGD_DTINI"))+" a "+Dtoc(PGD->PGD_DTFIM)
        Else
           cDescr := ""
        EndIf   

		AADD(aVetPD9,{PGE->PGE_PERIOD, Dtoc(PGE->PGE_DATA), Alltrim(PGE->PGE_DESCR)+cDescr, TRANSFORM(PGE->PGE_HORAS,"@e 99999") })
        dbSkip()
      EndDo
   EndIf
Else
   Help(,, "PD6_TIPO",, "Esta proposta não é do tipo recorrente!", 1, 0)
   Return
EndIf   

oPrn := TMSPrinter():New(cTitulo)
oPrn:SetPaperSize(9)

oPrn:SetLandscape()

Prep_obj()
Monta_interface()

Return


*------------------------------------------------------------------------------------------------------*
Static Function Monta_interface()
*------------------------------------------------------------------------------------------------------*
* Monta interface com o usuario
*------------------------------------------------------------------------------------------------------*

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY STR0002+alltrim(PD6->PD6_PROPOS)+STR0003 OF oDlg PIXEL Size 150,010  COLOR CLR_HBLUE //"Esse relatório exibe o histórico da proposta "###","
@ 030,017 SAY STR0004 OF oDlg PIXEL Size 150,010 COLOR CLR_HBLUE //"contendo cursos comprados e executados.        "

@  6,167 BUTTON STR0005 SIZE 036,012 ACTION oPrn:Print()   OF oDlg PIXEL //"&Imprime"
@ 28,167 BUTTON "&Setup"   SIZE 036,012 ACTION oPrn:Setup()   OF oDlg PIXEL
@ 49,167 BUTTON "Pre&view" SIZE 036,012 ACTION oPrn:Preview() OF oDlg PIXEL
@ 70,167 BUTTON STR0006    SIZE 036,012 ACTION  oDlg:End()  OF oDlg PIXEL //"Sai&r"


ACTIVATE MSDIALOG oDlg CENTERED

Return

*------------------------------------------------------------------------------------------------------*
Static Function Prep_obj()
*------------------------------------------------------------------------------------------------------*

Local nI := 1
Local nCC:= 0
Local _aDesPerio

Private nlin := 100
Private npos := 200
Private nTotComp := 0
Private nTotExec := 0

oPrn:StartPage()

U_TCTTRCAB()

oPrn:SayBitmap( 060,060, 'LOGOTIPO.jpg',360, 360, , .T. )

npos := 500
oPrn:Say(  nlin, npos , "Controle de recorrencia da proposta:"+alltrim(PD6->PD6_PROPOS)  ,oFont0) //"Histórico da Proposta: "
nlin+=100

oPrn:Say(  nlin, npos ,  TCTR160CLI(),oFont1) 
nlin+=350
npos := 100

oPrn:Say(  nlin, npos , "[Recorrencia]"  ,oFont2) 
nlin+=100
oPrn:Say(  nlin, npos , 'Periodo'  ,oFont3) //"Curso"
npos+=300
oPrn:Say(  nlin, npos, 'Data'  ,oFont3) //"QTDE"
npos+=300
oPrn:Say(  nlin, npos , 'Ocorrencia'  ,oFont3) //"Valor"
npos+=1000
oPrn:Say(  nlin, npos , Space(3)+'Horas'  ,oFont3) //"Valor"
npos :=100
nlin+=60

For nI:=1 to len(aVetPD9)
	nCC++
	If nCC=20
		Quebra()
		nCC:=0
	EndIf
	oPrn:Say(  nlin, npos , aVetPD9[nI][1]  ,oFont1)
	npos+=300
	oPrn:Say(  nlin, npos , aVetPD9[nI][2]  ,oFont1)
	npos+=300
	oPrn:Say(  nlin, npos , aVetPD9[nI][3]  ,oFont1)
	npos+=1000
	oPrn:Say(  nlin, npos , aVetPD9[nI][4]  ,oFont4)

	nlin += 60
	npos := 100
	
Next nI

oPrn:EndPage()

oPrn:End()

Return

Static Function Quebra
nlin := 100
npos := 200

oPrn:EndPage()
oPrn:StartPage()

U_TCTTRCAB()

npos := 500
oPrn:Say(  nlin, npos , STR0007+alltrim(PD6->PD6_PROPOS)  ,oFont0) //"Histórico da Proposta: "
nlin+=100
oPrn:Say(  nlin, npos , TCTR160CLI(),oFont1)
nlin+=350
npos := 100

oPrn:Say(  nlin, npos , "[Recorrencia]"  ,oFont2) 
nlin+=100
oPrn:Say(  nlin, npos , 'Periodo'  ,oFont3) //"Curso"
npos+=1100
oPrn:Say(  nlin, npos, 'Data'  ,oFont3) //"QTDE"
npos+=400
oPrn:Say(  nlin, npos , 'Ocorrencia'  ,oFont3) //"Valor"
npos :=100
nlin+=6

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Retorna os dados do prospect/cliente da propsta 

@author Wagner Mobile Costa
@version P12
@return cTexto,Caractere,Código + Nome do Cliente/Prospect
@since 04/09/2016
/*/
//-----------------------------------------------------------------------------
Static Function TCTR160CLI()

Local cReturn := ""
Local cCodigo := PD6->(PD6_CLIENT + PD6_LOJA)
Local cEntida := "SA1"

If ! Empty(PD6->PD6_PROSPE)
	cEntida := "SUS"
	cReturn += STR0011+PD6->(PD6_PROSPE+ "/"+PD6_LOJPRO) //"Cod. Prospect/Loja: "###"/"
	cCodigo := PD6->(PD6_PROSPE + PD6_LOJPRO)
Else
	cReturn += STR0008+PD6->(PD6_CLIENT+ "/"+PD6_LOJA) //"Cod. Cliente/Loja: "###"/"
EndIf

cReturn += STR0010+ ALLTRIM(POSICIONE(cEntida,1,xFilial(cEntida)+cCodigo,Right(cEntida, 2) + "_NOME")) //"           Razão Social: "
			
Return cReturn


