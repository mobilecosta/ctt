#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Valid
Validação do campo PD3_CURSO e atualização dos campos PD3_NOME, PD3_NOMECUR, 
                   PD3_QTDHOR e PD3_IMAGEM

@author Wagner Mobile Costa
@version P12
@since 08/04/2015
@return = lRet = Retorna se a digitação do campo está valida
/*/
//-----------------------------------------------------------------------------
User Function TCTTV002

Local lRet := .T., aArea := GetArea(), oModel, oModelPD3, oStru

DbSelectArea("PDM")
DbSetOrder(1)
If ! DbSeek(xFilial() + M->PD3_CURSO)
   Help(,, "REGNOIS")
   lRet := .F.
EndIf

If lRet
   oModel := FWModelActive()
   oModelPD3 := oModel:GetModel("PD3")
   oStru := oModelPD3:GetStruct()
   oStru:SetProperty( 'PD3_NOME',   MODEL_FIELD_WHEN, .T.)
   oStru:SetProperty( 'PD3_QTDHOR', MODEL_FIELD_WHEN, .T.)
   
   oModelPD3:LoadValue('PD3_NOME',   PDM->PDM_NOME)
   oModelPD3:LoadValue('PD3_NOMECR', PDM->PDM_NOME)
   M->PD3_QTDHOR := PDM->PDM_QTDHOR
   oModelPD3:LoadValue('PD3_QTDHOR', M->PD3_QTDHOR)
   oModelPD3:LoadValue('PD3_IMAGEM', PDM->PDM_IMAGE)
   oModelPD3:LoadValue('PD3_VERSAO', PDM->PDM_VERSAO)

   oStru:SetProperty( 'PD3_NOME',   MODEL_FIELD_WHEN, { || U_TCTTW001() })
   oStru:SetProperty( 'PD3_QTDHOR', MODEL_FIELD_WHEN, { || U_TCTTW001() })
EndIf

RestArea(aArea)

Return lRet