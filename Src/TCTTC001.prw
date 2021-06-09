#Include 'TOTVS.ch'

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Monta consulta padrão da tabela PGD agrupada pelo campo PDG_PONTUA

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTC001()

Local lRet := .F., nRetorno := 0

cQuery := "SELECT PDG_PONTUA, MIN(PDG_DESCRI) AS PDG_DESCRI, MIN(R_E_C_N_O_) AS RECNO "
cQuery +=   "FROM " + RetSqlName("PDG") + " "
cQuery +=  "WHERE D_E_L_E_T_ = ' ' AND PDG_FILIAL = '" + xFilial("PDG") + "' "
cQuery +=  "GROUP BY PDG_PONTUA"

If JurF3Qry(cQuery, "PDGQRY", "RECNO", @nRetorno,, { "PDG_PONTUA", "PDG_DESCRI" })
	PDG->(DbGoto(nRetorno))
	lRet := .T.
EndIf

Return lRet

