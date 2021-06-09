#INCLUDE "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Inicialização padrão do campo PDI_NOME

@author Wagner Mobile Costa
@version P12
@param = cTable = Tabela para inicialização do campo
@since 08/05/2015
@return .T.
/*/
//-----------------------------------------------------------------------------
User Function TCTTI001(cTable)

Local oModel := FWModelActive(), oModel, cReturn := ""

oModel := oModel:GetModel(cTable)
M->PD2_PROF := ""
If oModel:nLine > 0
	M->PD2_PROF := Space(Len(PD2->PD2_PROF))
	If cTable == "PDI"
		M->PD2_PROF := M->PD3_PROF
	EndIf
ElseIf ! INCLUI
	M->PD2_PROF := &(cTable + "->" + cTable + "_PROF") 
EndIf

If ! Empty(M->PD2_PROF)
	cReturn := Posicione("PD2",1,XFILIAL("PD2")+M->PD2_PROF,"PD2_NOME")
EndIf

Return cReturn