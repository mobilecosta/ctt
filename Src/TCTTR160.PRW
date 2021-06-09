#INCLUDE "TCTTR160.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
      
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina de impressco do histsrico da Proposta

@author Fabio Josi Batista
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
USER FUNCTION TCTTR160()

//Declaracao de variaveis
Private oDlg    := NIL 
Private cTitulo := STR0001 //"Impressao"
Private oFont0 := Tfont():New ( "Calibri" 			  ,  0,20 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private oFont1 := Tfont():New ( "Calibri" 			  ,  0,12 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private oFont2 := Tfont():New ( "Calibri" 			  ,  0,20 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .T./*ITALICO*/    )
Private oFont3 := Tfont():New ( "Calibri" 			  ,  0,14 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )

Private cAcesso  := SPACE(10)

Private oPrn    := NIL
Private nSaldoProp:= 0                                     
Private aVetPD7 := {}
Private aVetPD9 := {}

DbSelectArea("PD9")
DbSetOrder(1)
If Dbseek(xFilial("PD9")+ PD6->PD6_PROPOS)  
	While !PD9->(EOF()) .AND. PD6->PD6_PROPOS == PD9->PD9_PROPOS .AND. PD9->PD9_FILIAL == PD6->PD6_FILIAL 
		AADD(aVetPD9,{PD9->PD9_CURSO, PD9->PD9_QTDE, PD9->PD9_VALOR, PD9->PD9_QTDHRS})
		nSaldoProp+=PD9->PD9_QTDHRS
		PD9->(DbSkip())
	Enddo
Endif
DbCloseArea("PD9")

If Select("QUERY") <> 0
	DbCloseArea("QUERY")
Endif

cQuery  := "SELECT PD7.PD7_FILIAL, PD3.PD3_TURMA, PD3.PD3_NOME, PDL.PDL_NOME, PD3.PD3_QTDHOR, "
cQuery	+=        "PD3.PD3_DTINI, PD7.PD7_CONFIR, PD7.PD7_HORAS, PD3.PD3_STATUS, PD7.PD7_PERIOD  "
cQuery	+=  "FROM " + RETSQLNAME("PD7") + " PD7 "
cQuery  +=  "JOIN " + RetSqlName ("PD3") +" PD3 ON PD3_FILIAL = PD7_FILIAL AND PD3_TURMA = PD7_TURMA AND PD3.D_E_L_E_T_ = ' ' "
cQuery  +=  "JOIN " + RetSqlName ("PDL") +" PDL ON PDL.PDL_FILIAL = '"+ xFilial("PDL")+"' AND PDL.PDL_ALUNO = PD7.PD7_ALUNO AND PDL.D_E_L_E_T_ = ' ' "
cQuery  += "WHERE PD7.PD7_FILPRO = '" + PD6->PD6_FILIAL +"' AND PD7.PD7_PROPOS = '" + PD6->PD6_PROPOS +"' AND PD7.D_E_L_E_T_ = ' ' "
cQuery  += " AND PD7.PD7_CONFIR <> '6' AND PD7.PD7_CONFIR <> '7' "
cQuery  += "ORDER BY PD7.PD7_FILIAL, PD7.PD7_ALUNO "
     
cQuery	:= ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"QUERY",.F.,.T.)
TcSetField ("QUERY","PD3_DTINI","D",8,0)

DbSelectArea("QUERY")

While !QUERY->(EOF())
	AADD(aVetPD7,{QUERY->PDL_NOME,QUERY->PD3_NOME,cValToChar(QUERY->PD7_HORAS),;
	     			dtoc(QUERY->PD3_DTINI),QUERY->PD7_CONFIR,QUERY->PD7_FILIAL,QUERY->PD3_STATUS,QUERY->PD7_PERIOD})
		nSaldoProp -= QUERY->PD7_HORAS


	QUERY->(DbSkip())
Enddo

DbSelectArea("QUERY")
DbCloseArea()

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

@ 015,017 SAY STR0002+alltrim(PD6->PD6_PROPOS)+STR0003 OF oDlg PIXEL Size 150,010  COLOR CLR_HBLUE //"Esse relatsrio exibe o histsrico da proposta "###","
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
oPrn:Say(  nlin, npos , STR0007+alltrim(PD6->PD6_PROPOS)  ,oFont0) //"Histsrico da Proposta: "
nlin+=100

oPrn:Say(  nlin, npos ,  TCTR160CLI(aVetPD7),oFont1) 
nlin+=350
npos := 100

oPrn:Say(  nlin, npos , STR0016  ,oFont2) //"[Cursos Comprados]"
nlin+=100
oPrn:Say(  nlin, npos , STR0017  ,oFont3) //"Curso"
npos+=1100
oPrn:Say(  nlin, npos, STR0018  ,oFont3) //"QTDE"
npos+=400
oPrn:Say(  nlin, npos , STR0019  ,oFont3) //"Valor"
npos+=400
oPrn:Say(  nlin, npos , STR0020  ,oFont3) //"Valor Tot."
npos+=400
oPrn:Say(  nlin, npos , STR0021  ,oFont3) //"QTDE Hs"
npos :=100
nlin+=60

For nI:=1 to len(aVetPD9)
	nTotComp+=aVetPD9[nI][4]
	nCC++
	If nCC=20
		Quebra()
		nCC:=0
	EndIf
	oPrn:Say(  nlin, npos , aVetPD9[nI][1]  ,oFont1)
	npos+=1100
	oPrn:Say(  nlin, npos , alltrim(cValToChar(aVetPD9[nI][2]))  ,oFont1)
	npos+=400
	oPrn:Say(  nlin, npos , "R$ "+ Transform(aVetPD9[nI][3],"@E 999,999.99")  ,oFont1)
	npos+=400
	oPrn:Say(  nlin, npos , "R$ "+ Transform(aVetPD9[nI][2]*aVetPD9[nI][3],"@E 999,999.99")  ,oFont1)
	npos+=400
	oPrn:Say(  nlin, npos , alltrim(cValToChar(aVetPD9[nI][4]))  ,oFont1)
	nlin += 60
	npos := 100
	
Next nI
oPrn:Say(  nlin, 2400 , alltrim(cValToChar(nTotComp))+STR0015  ,oFont3) //"hs"
nlin += 60
npos := 100

nI := 1

nlin+=100

_aDesPerio	:= RetSx3Box(POSICIONE("SX3", 2, "PD7_CONFIR", "X3CBOX()"),,, 1)

oPrn:Say(  nlin, npos , STR0022  ,oFont2) //"[Cursos Executados]"
nlin+=100
oPrn:Say(  nlin, npos , STR0023  ,oFont3) //"Aluno"
npos+=800
oPrn:Say(  nlin, npos , STR0024  ,oFont3) //"Filial"
npos+=450
oPrn:Say(  nlin, npos , STR0017  ,oFont3) //"Curso"
npos+=750
oPrn:Say(  nlin, npos , STR0025  ,oFont3) //"Horas"
npos+=200
oPrn:Say(  nlin, npos , STR0026  ,oFont3) //"Dt.Inicio"
npos+=250
oPrn:Say(  nlin, npos , STR0027  ,oFont3) //"Status"
npos+=300
oPrn:Say(  nlin, npos , STR0028  ,oFont3) //"Nota Aluno"
npos+=300
oPrn:Say(  nlin, npos , STR0029  ,oFont3) //"Av.Aluno"
npos := 100
nlin+=60
For nI:=1 to len(aVetPD7)
	If aVetPD7[nI][5] $ "1,3,5"
		nTotExec+=val(aVetPD7[nI][3])
	EndIf
	nCC++
	If nCC=20
		Quebra()
		nCC:=0
	EndIf
	oPrn:Say(  nlin, npos , aVetPD7[nI][1]  ,oFont1)
	npos+=800
	oPrn:Say(  nlin, npos , POSICIONE("SM0", 1, cEmpAnt + aVetPD7[nI][6],"M0_FILIAL")  ,oFont1)
	npos+=450
	
	oPrn:Say(  nlin, npos , aVetPD7[nI][2]  ,oFont1)
	npos+=750
	oPrn:Say(  nlin, npos , IIf(aVetPD7[nI][7] <> 'C',aVetPD7[nI][3],"0") ,oFont1)
	npos+=200
	oPrn:Say(  nlin, npos , aVetPD7[nI][4]  ,oFont1)
	npos+=250
	oPrn:Say(  nlin, npos , Alltrim(_aDesPerio[Ascan(_aDesPerio,{ |x| x[2] = aVetPD7[nI][5] })][3])  ,oFont1)
	npos+=400
	oPrn:Say(  nlin, npos , ""  ,oFont1)
	npos+=350
	oPrn:Say(  nlin, npos , ""  ,oFont1)
	
	nlin += 60
	npos := 100
Next nI

oPrn:Say(  nlin, 1950 , alltrim(cValToChar(nTotExec))+STR0030  ,oFont3) //"hs confirmadas"
nlin += 60
npos := 100

nI := 1

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
oPrn:Say(  nlin, npos , STR0007+alltrim(PD6->PD6_PROPOS)  ,oFont0) //"Histsrico da Proposta: "
nlin+=100
oPrn:Say(  nlin, npos , TCTR160CLI(aVetPD7),oFont1)
nlin+=350
npos := 100

oPrn:Say(  nlin, npos , STR0022  ,oFont2) //"[Cursos Executados]"
nlin+=100
oPrn:Say(  nlin, npos , STR0023  ,oFont3) //"Aluno"
npos+=800
oPrn:Say(  nlin, npos , STR0024  ,oFont3) //"Filial"
npos+=450
oPrn:Say(  nlin, npos , STR0017  ,oFont3) //"Curso"
npos+=750
oPrn:Say(  nlin, npos , STR0025  ,oFont3) //"Horas"
npos+=200
oPrn:Say(  nlin, npos , STR0026  ,oFont3) //"Dt.Inmcio"
npos+=250
oPrn:Say(  nlin, npos , STR0027  ,oFont3) //"Status"
npos+=300
oPrn:Say(  nlin, npos , STR0028  ,oFont3) //"Nota Aluno"
npos+=300
oPrn:Say(  nlin, npos , STR0029  ,oFont3) //"Av.Aluno"
npos := 100
nlin+=6

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Retorna os dados do prospect/cliente da propsta 

@author Wagner Mobile Costa
@version P12
@return cTexto,Caractere,Csdigo + Nome do Cliente/Prospect
@since 04/09/2016
/*/
//-----------------------------------------------------------------------------
Static Function TCTR160CLI(aVetPD7)

Local cReturn := ""
Local cCodigo := PD6->(PD6_CLIENT + PD6_LOJA)
Local cEntida := "SA1"
Local nSldProp := 0
Local nSldP		:= 0
Local nSldTot	:= PD6->PD6_SLDPRO
Local nSldAcum	:= PD6->PD6_SLDREC
Local nI

For nI:= 1 To Len(aVetPD7)
	If aVetPD7[nI][5] $ "1,3,5" .And. aVetPD7[nI][8] == PD6->PD6_PERIOD
		nSldP+=val(aVetPD7[nI][3])
	EndIf
Next nI

DbSelectArea("PD9")
DbSetOrder(1)
If Dbseek(xFilial("PD9")+ PD6->PD6_PROPOS)  
	While !PD9->(EOF()) .AND. PD6->PD6_PROPOS == PD9->PD9_PROPOS .AND. PD9->PD9_FILIAL == PD6->PD6_FILIAL 
		 PD9->PD9_QTDHRS
		nSldProp+=PD9->PD9_QTDHRS
		PD9->(DbSkip())
	Enddo
Endif

If ! Empty(PD6->PD6_PROSPE)
	cEntida := "SUS"
	cReturn += STR0011+PD6->(PD6_PROSPE+ "/"+PD6_LOJPRO) //"Cod. Prospect/Loja: "###"/"
	cCodigo := PD6->(PD6_PROSPE + PD6_LOJPRO)
Else
	cReturn += STR0008+PD6->(PD6_CLIENT+ "/"+PD6_LOJA) //"Cod. Cliente/Loja: "###"/"
EndIf
 
cReturn += STR0010+ ALLTRIM(POSICIONE(cEntida,1,xFilial(cEntida)+cCodigo,Right(cEntida, 2) + "_NOME")) //"           Razco Social: "
			
cReturn += STR0012+Transform(PD6->PD6_VALOR,"@E 999,999.99")+STR0014+cValToChar(nSldAcum-nSldP)+STR0015+Space(6)+; //"       Valor:  R$ "
			"Saldo Total da Proposta: "+cValToChar(nSldTot)+STR0015+Space(6)  

Return cReturn

