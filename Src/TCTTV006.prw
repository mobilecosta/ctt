#INCLUDE "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Preenchimento do número de horas do periodo a partir do preenchimento da aba Datas (PDI)

@author Wagner Mobile Costa
@version P12
@since 07/05/2015
@return .T.
/*/
//-----------------------------------------------------------------------------
User Function TCTTV006

Local oModel  := FWModelActive(), oModelPDI, oModelPDF
Local dData   := Ctod("")
Local nLine   := 0
Local nPosPDI := 0 
Local nRegPDI := 0
Local nHora   := 0
Local nHorInt := 0
Local oView   := FWViewActive()
Local cHRINI  := cHRFIM := cInter := ""
Local aSaveLines := FWSaveRows()

oModelPDI := oModel:GetModel("PDI")
oModelPDF := oModel:GetModel("PDF")
nRegPDI   := oModelPDI:Length()

//-- Periodos do Curso
For nLine := 1 To oModelPDF:Length()
	oModelPDF:GoLine( nLine )

	If ! oModelPDF:IsDeleted() .And. ! Empty(oModelPDF:GetValue("PDF_DTINI"))
		M->PDF_QTDHOR := 0
		For nPosPDI := 1 To nRegPDI
			oModelPDI:GoLine( nPosPDI )
			If ! oModelPDI:IsDeleted()
			
				dData := oModelPDI:GetValue("PDI_DATA")
				If 	oModelPDI:GetValue("PDI_PROF") == oModelPDF:GetValue("PDF_PROF") .And.;
					dData >= oModelPDF:GetValue("PDF_DTINI") .And.;
				    dData <= oModelPDF:GetValue("PDF_DTFIM")
	
					cHrIni := oModelPDI:GetValue("PDI_HRINI")
					cHrFim := oModelPDI:GetValue("PDI_HRFIM")
					cInter := oModelPDI:GetValue("PDI_INTER")
					nHora := Val(Left(cHrFIM, 2)) - Val(Left(cHrINI, 2))
					nHora += ((Val(Right(cHrFIM, 2)) - Val(Right(cHrINI, 2))) / 60) 
	
					M->PDF_QTDHOR += nHora
	
					nHorInt := Val(Left(cInter, 2))
					nHorInt += ((Val(Right(cInter, 2))) / 60) 
					M->PDF_QTDHOR -= nHorInt
				EndIf
			EndIf
		Next
		oModelPDF:SetValue("PDF_QTDHOR", M->PDF_QTDHOR)
	EndIf
Next nI

FWRestRows( aSaveLines )
If oView <> Nil
	oView:Refresh()
EndIf

Return .T.