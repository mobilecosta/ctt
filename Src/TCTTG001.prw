#Include "Protheus.ch"
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Gatilho para preenchimento do campo PD9_QTDHRS

@author Wagner Mobile Costa
@version P12
@since 16/04/2015
/*/
//-----------------------------------------------------------------------------

User Function TCTTG001()

Local nPD9_QTDHRS := M->PD9_QTDE

oModel := FWModelActive()
oModelPD9 := oModel:GetModel("PD9")
nPD9_QTDHRS := Posicione("PDM", 1, xFilial("PDM") + oModelPD9:GetValue("PD9_CURSO"), "PDM_QTDHOR")
nPD9_QTDHRS := nPD9_QTDHRS * M->PD9_QTDE

Return If(nPD9_QTDHRS > 999, 999, nPD9_QTDHRS)

User Function TCTTHOR()

Local nPD9_QTDHRS
Local nPD9_VlrUn

oModel := FWModelActive()
oModelPD9 := oModel:GetModel("PD9")
nPD9_QTDHRS := Posicione("PDM", 1, xFilial("PDM") + oModelPD9:GetValue("PD9_CURSO"), "PDM_QTDHOR")
nPD9_VlrUn  := Posicione("PDM", 1, xFilial("PDM") + oModelPD9:GetValue("PD9_CURSO"), "PDM_VALOR")
nPD9_QTDHRS := nPD9_QTDHRS * M->PD9_QTDE

oModel := FWModelActive()
oModelPD6 := oModel:GetModel( 'PD6' )
oModelPD6:SetValue("PD6_HORAS", nPD9_QTDHRS)
oModelPD6:SetValue("PD6_VALOR", M->PD9_QTDE*nPD9_VlrUn)


Return(.T.)
