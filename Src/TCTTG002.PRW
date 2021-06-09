#Include "Protheus.ch"
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function TCTTG002
Gatilho para preenchimento do campo PD6_PROPOS
@author Fabio Veiga Oliva
@version P12
@since 16/04/2015
/*/
//-----------------------------------------------------------------------------

User Function TCTTG002()       
Local aArea := GetArea()
oModel := FWModelActive()
oModelPD6 := oModel:GetModel("PD6")
dbSelectArea("ADY")
dbSetOrder(1)
If dbSeek(xFilial("ADY")+M->PD6_PROPOS)
   oModelPD6:SetValue("PD6_NROPOR",ADY->ADY_OPORTU) 
   oModelPD6:SetValue("PD6_CLIENT",ADY->ADY_CODIGO) 
   oModelPD6:SetValue("PD6_LOJA",ADY->ADY_LOJA) 
   oModelPD6:SetValue("PD6_DATA",ADY->ADY_DATA) 
   oModelPD6:SetValue("PD6_CONDPG",ADY->ADY_CONDPG) 
   oModelPD6:SetValue("PD6_DTUPLO",ADY->ADY_DTUPL) 
   oModelPD6:SetValue("PD6_DTFATU",ADY->ADY_DTFAT) 
   oModelPD6:SetValue("PD6_DTFATU",ADY->ADY_DTFAT) 
EndIf
RestArea(aArea)
Return(Readvar())
