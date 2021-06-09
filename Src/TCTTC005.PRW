#INCLUDE "TCTTC005.ch"
#INCLUDE "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Consulta Padrão para o compo PDF_PROF
@author Fabio José Batista
@version P12
@since 19/05/2015
@return .T.
/*/
//-----------------------------------------------------------------------------
User Function TCTTC005

Local oModel := FWModelActive(), oModelPDI
Local nLine  := 0
Local nPosPDI := nRegPDI := 0
Local aProf  := {}        
Public cProf	:= ""
 
oModelPDI := oModel:GetModel("PDI")  // Aba de datas
nRegPDI   := oModelPDI:Length()

For nLine := 1 To oModelPDI:Length()
   oModelPDI:GoLine( nLine )
   If ascan(aProf, { |x| x[1] == oModelPDI:GetValue("PDI_PROF")} ) == 0
      Aadd(aProf,{oModelPDI:GetValue("PDI_PROF"),oModelPDI:GetValue("PDI_NOME")})//Pegando o codigo e o nome do Professor com o comando GetValue
   EndIf
Next 

DEFINE MSDIALOG oDlg TITLE STR0001 FROM 000, 000  TO 400, 600 COLORS 0, 16777215 PIXEL //"Escolha Professor"

DEFINE SBUTTON oSButton1 FROM 180, 055 TYPE 02 OF oDlg ENABLE ACTION (cProf:= "",oDlg:end())
DEFINE SBUTTON oSButton2 FROM 179, 178 TYPE 01 OF oDlg ENABLE ACTION (cProf:=aProf[oProf:nAt,1],oDlg:end())
@ 022, 015 LISTBOX oProf Fields HEADER "",STR0002,STR0003 SIZE 264, 139 OF oDlg PIXEL ColSizes 50,50 //"Codigo"###"Nome"
oProf:SetArray(aProf)
oProf:bLine := {|| {aProf[oProf:nAt,1],aProf[oProf:nAt,2]}}//nAt retorna a linha que esta mostrando  

ACTIVATE MSDIALOG oDlg CENTERED

Return .T.