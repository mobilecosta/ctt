#Include 'TOTVS.ch'

Static cPD6_FILIAL := ""

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Consuilta padrão para seleção da proposta a partir do campo PDL_ALUNO

@author Wagner Mobile Costa
@version P12
@since 08/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTC004()

Local lRet 	  := .F., nRetorno := 0, cQuery := ""
Local aFields := { "PD6_FILIAL", "PD6_PROPOS", "PD6_CLIENT", "PD6_LOJA", "A1_NOME", "PD6_HORAS", "PD6_SLDHS" }

If ! Empty(PDL->PDL_PROSPE)
	cQuery += "AND PD6.PD6_PROSPE = '" + PDL->PDL_PROSPE + "' "
	cQuery += "AND PD6.PD6_LOJPRO = '" + PDL->PDL_LOJPRO + "' "
	aFields[3] := "PD6_PROSPE"
	aFields[4] := "PD6_LOJPRO"
	aFields[5] := "US_NOME"
Else
	cQuery += "AND PD6.PD6_CLIENT = '" + PDL->PDL_CLIENT + "' "
	cQuery += "AND PD6.PD6_LOJA = '" + PDL->PDL_LOJA + "' "
EndIf

If JurF3Qry(U_TCTTQPD6(cQuery), "PD6QRY", "RECNO", @nRetorno,, aFields)
	PD6->(DbGoto(nRetorno))
	
	cPD6_FILIAL := PD6->PD6_FILIAL
	lRet := .T.
EndIf

Return lRet

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Consuilta padrão para seleção da proposta a partir do campo PDL_ALUNO

@author Wagner Mobile Costa
@version P12
@since 09/04/2015
@return = Query para utilização nas funções U_TCTTC004 e U_TCTTV003
/*/
//-----------------------------------------------------------------------------
User Function TCTTQPD6(cFilter)

Local cQuery := ""
Local oModel, oModelPD7, aArea := GetArea()
Local cPD7_CONFIR := ""

oModel := FWModelActive()
oModelPD7 := oModel:GetModel("PD7")
DbSelectArea("PDL")
DbSetOrder(1)
DbSeek(xFilial() + oModelPD7:GetValue("PD7_ALUNO"))

If ! Empty(PDL->PDL_PROSPE)
	cQuery += "SELECT PD6.PD6_FILIAL, PD6.PD6_PROPOS, PD6.PD6_PROSPE, PD6.PD6_LOJPRO, SUS.US_NOME, "
Else
	cQuery += "SELECT PD6.PD6_FILIAL, PD6.PD6_PROPOS, PD6.PD6_CLIENT, PD6.PD6_LOJA, SA1.A1_NOME, "
EndIf
cQuery +=        "PD6.PD6_HORAS, PD6.PD6_SLDHS, PD6.R_E_C_N_O_ AS RECNO, PD6_DTINI, PD6_DTFIM, PD6_TIPO "
cQuery +=   "FROM " + RetSqlName("PD6") + " PD6 "
If Empty(PDL->PDL_CLIENT)
	cQuery += "JOIN " + RetSqlName("SUS") + " SUS ON SUS.US_FILIAL = '" + xFilial("SUS") + "' "
	cQuery +=  "AND SUS.US_COD = PD6.PD6_PROSPE AND SUS.US_LOJA = PD6.PD6_LOJPRO  "
	cQuery +=  "AND SUS.D_E_L_E_T_ = ' ' "
	cQuery +=  "WHERE "
	If At("PD6_FILIAL", cFilter) == 0
		If ! Empty(cPD6_FILIAL)
			cQuery += "PD6.PD6_FILIAL = '" + cPD6_FILIAL + "'"
		Else
			cQuery += "PD6.PD6_FILIAL BETWEEN '" + Repl(" ", Len(PD6->PD6_FILIAL)) + "' AND '" + Repl("Z", Len(PD6->PD6_FILIAL)) + "'"
		EndIf
	EndIf
	cQuery += cFilter
	cQuery +=  "AND PD6.PD6_PROSPE = '" + PDL->PDL_PROSPE + "' AND PD6.PD6_LOJPRO = '" + PDL->PDL_LOJPRO + "' "
Else
	cQuery += "JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cQuery +=  "AND SA1.A1_COD = PD6.PD6_CLIENT AND SA1.A1_LOJA = PD6.PD6_LOJA  "
	cQuery +=  "AND SA1.D_E_L_E_T_ = ' ' "
	cQuery +=  "WHERE "
	If At("PD6_FILIAL", cFilter) == 0
		If ! Empty(cPD6_FILIAL)
			cQuery += "PD6.PD6_FILIAL = '" + cPD6_FILIAL + "'"
		Else
			cQuery += "PD6.PD6_FILIAL BETWEEN '" + Repl(" ", Len(PD6->PD6_FILIAL)) + "' AND '" + Repl("Z", Len(PD6->PD6_FILIAL)) + "'"
		EndIf
	EndIf
	cQuery += cFilter
	cQuery +=  "AND PD6.PD6_CLIENT = '" + PDL->PDL_CLIENT + "' AND PD6.PD6_LOJA = '" + PDL->PDL_LOJA + "' "
EndIf 



cPD7_CONFIR := oModelPD7:GetValue("PD7_CONFIR")
If oModelPD7:IsInserted()
	cQuery += " AND PD6.PD6_STATUS <> '4'"
	If Empty(cPD7_CONFIR) .Or. cPD7_CONFIR = "1" .Or. cPD7_CONFIR = "3" .Or. cPD7_CONFIR = "5" .Or. cPD7_CONFIR = "6" 
		cQuery += " AND PD6.PD6_SLDHS > 0"
	EndIf
EndIf

cQuery += " AND PD6.D_E_L_E_T_ = ' '"
 
cPD6_FILIAL := ""

RestArea(aArea)

Return cQuery