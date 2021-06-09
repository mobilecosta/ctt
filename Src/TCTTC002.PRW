#INCLUDE "TCTTC002.ch"
#Include 'TOTVS.ch'

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Monta consulta padrão para o relatório TCTTR100

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTC002()

Local oSButton1
Local oSButton2
Private oWBrowse1
Private aWBrowse1 := {}
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
Public cRetx	:= ""
Static oDlg

DEFINE MSDIALOG oDlg TITLE STR0001 FROM 000, 000  TO 400, 600 COLORS 0, 16777215 PIXEL //"SELEÇÃO"

DEFINE SBUTTON oSButton1 FROM 180, 055 TYPE 02 OF oDlg ENABLE ACTION (cRetx:= "",oDlg:end())
DEFINE SBUTTON oSButton2 FROM 179, 178 TYPE 01 OF oDlg ENABLE ACTION (aeval(aWBrowse1,{|z| iif(z[1],cRetx+= z[2]+';',nil)}),oDlg:end())
fWBrowse1()

ACTIVATE MSDIALOG oDlg CENTERED

cRetx := SUBSTR(cRetx,1,LEN(cRetx)-1)
if at(';',cRetx)=0 .and. !empty(cRetx)
	cRetx := cRetx+';'
endif
mv_par08 := cRetx

Return(.T.)


Static Function fWBrowse1()
Aadd(aWBrowse1,{.F.,"1",STR0002}) //"Instrutor"
Aadd(aWBrowse1,{.F.,"2",STR0003}) //"Material-Didatico"
Aadd(aWBrowse1,{.F.,"3",STR0004}) //"Infra-Estrutura"
Aadd(aWBrowse1,{.F.,"4",STR0005}) //"Recepcao"
Aadd(aWBrowse1,{.F.,"5",STR0006}) //"Comercial"
Aadd(aWBrowse1,{.F.,"6",STR0007}) //"Coffe-Break"
Aadd(aWBrowse1,{.F.,"7",STR0008}) //"Diversos"

@ 022, 015 LISTBOX oWBrowse1 Fields HEADER "",STR0009,STR0010 SIZE 264, 139 OF oDlg PIXEL ColSizes 50,50 //"Codigo"###"Descrição"
oWBrowse1:SetArray(aWBrowse1)
oWBrowse1:bLine := {|| {If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),aWBrowse1[oWBrowse1:nAt,2],aWBrowse1[oWBrowse1:nAt,3]}}

oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],oWBrowse1:DrawSelect()}
Return
