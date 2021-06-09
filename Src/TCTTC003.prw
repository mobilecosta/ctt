#Include 'TOTVS.ch'

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Monta consulta padrão da tabela PD5 agrupada pelo campo PD5_PESQ

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTC003()

Local lRet := .F., nRetorno := 0

cQuery := "SELECT PD5_PESQ, MIN(PD5_DESCRI) AS PD5_DESCRI, MIN(R_E_C_N_O_) AS RECNO "
cQuery +=   "FROM " + RetSqlName("PD5") + " "
cQuery +=  "WHERE D_E_L_E_T_ = ' ' AND PD5_FILIAL = '" + xFilial("PD5") + "' AND PD5_MSBLQL = '2' "
cQuery +=  "GROUP BY PD5_PESQ"

If JurF3Qry(cQuery, "PD5QRY", "RECNO", @nRetorno,, { "PD5_PESQ", "PD5_DESCRI" })
	PD5->(DbGoto(nRetorno))
	lRet := .T.
EndIf

Return lRet