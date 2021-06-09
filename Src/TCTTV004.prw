#INCLUDE "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validação do campo PDM_TPOSIS para sequenciar o campo PDM_CURSO

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
@param  cTpoSis - Tipo de Sistema informado
@return cPDM_CURSO - Código do curso
/*/
//-----------------------------------------------------------------------------

User Function TCTTV004()

Local cPDM_CURSO := ""
Local aArea		 := GetArea(), oModel, oModelPDM, oStru
Local cField	 := "%SUBSTRING(PDM_CURSO, 1, 2)%"
Local nLen		 := 8

If Empty(M->PDM_TPOSIS)
   Return .T.
EndIf

cTpoSis := Left(M->PDM_TPOSIS, 1) 
Do Case
	Case M->PDM_TPOSIS == "P"
		cTpoSis := "MP"
	Case M->PDM_TPOSIS == "R"
		cTpoSis := "RM"
	Case M->PDM_TPOSIS == "D"
		cTpoSis := "DT"
	Case M->PDM_TPOSIS == "L"
		cTpoSis := "LG"
EndCase

If Len(cTpoSis) = 1
	cField := "%SUBSTRING(PDM_CURSO, 1, 1)%"
	nLen   := 9
EndIf

BeginSQL Alias "PDMPRX"
	SELECT MAX(PDM_CURSO) AS PDM_CURSO
	  FROM %table:PDM%
	 WHERE %notDel% AND PDM_FILIAL = %Exp:xFilial("PDM")% AND %Exp:cField% = %Exp:cTpoSis%
EndSql

cPDM_CURSO := Subs(PDMPRX->PDM_CURSO,Len(cTpoSis) + 1,nLen)

If Empty(cPDM_CURSO)
	cPDM_CURSO := "0"
Endif

PDMPRX->(DbCloseArea())

oModel := FWModelActive()
oModelPDM := oModel:GetModel("PDM")
oStru := oModelPDM:GetStruct()
oStru:SetProperty( 'PDM_CURSO', MODEL_FIELD_WHEN, .T.)
oModelPDM:LoadValue('PDM_CURSO', cTpoSis + StrZero(Val(cPDM_CURSO) + 1,10 - Len(cTpoSis)))
oStru:SetProperty( 'PDM_CURSO', MODEL_FIELD_WHEN, { || Empty(M->PDM_TPOSIS) })

RestArea(aArea)

Return .T.