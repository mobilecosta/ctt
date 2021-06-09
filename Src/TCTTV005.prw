#INCLUDE "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Preenchimento do código do professor na aba "Datas" e "Periodos" da Turma

@author Wagner Mobile Costa
@version P12
@since 07/05/2015
@return .T.
/*/
//-----------------------------------------------------------------------------
User Function TCTTV005

Local oModel  := FWModelActive(), oModelPDI, oModelPDF
Local nLine   := 0
Local lInclui := oModel:GetModel("PD3"):GetOperation() == 3

oModelPDI := oModel:GetModel("PDI")
oModelPDF := oModel:GetModel("PDF")

//-- Datas do Curso
For nLine := 1 To oModelPDI:Length()
	oModelPDI:GoLine( nLine )

	If ! oModelPDI:IsDeleted()
		//-- Professor
		If Empty(oModelPDI:GetValue("PDI_PROF")) .Or. lInclui
			oModelPDI:SetValue("PDI_PROF", M->PD3_PROF)
		EndIf 

	EndIf
Next nI

//-- Periodos do Curso
For nLine := 1 To oModelPDF:Length()
	oModelPDF:GoLine( nLine )

	If ! oModelPDF:IsDeleted() .And. ! Empty(oModelPDF:GetValue("PDF_DTINI"))
		//-- Professor
		If Empty(oModelPDF:GetValue("PDF_PROF")) .Or. lInclui
			oModelPDF:SetValue("PDF_PROF", M->PD3_PROF)
		EndIf 
	EndIf
Next nI

Return .T.