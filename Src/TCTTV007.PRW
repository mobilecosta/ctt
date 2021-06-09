#INCLUDE "TCTTV007.ch"
#INCLUDE "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validação do campo PDF_PROF
@author Fabio José Batista
@version P12
@since 19/05/2015
@return .T.
/*/
//-----------------------------------------------------------------------------
User Function TCTTV007

Local oModel := FWModelActive(), oModelPDI
Local nLine  := 0
Local nPosPDI := nRegPDI := 0
Local lOk    := .F.

oModelPDI := oModel:GetModel("PDI")  // Aba de datas
nRegPDI   := oModelPDI:Length()

For nLine := 1 To oModelPDI:Length()
   oModelPDI:GoLine( nLine )

   If oModelPDI:GetValue("PDI_PROF") == M->PDF_PROF//Pegando o codigo e o nome do Professor com o comando GetValue
      lOK := .T.
   EndIf
Next
If !lOk
   Help(,, STR0001,, STR0002, 1, 0)             //"PDF_PROF"###"Professor preenchido não existe na aba [Datas]"
endif

Return lOk