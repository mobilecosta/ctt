#INCLUDE "TOTVS.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validação do campo PD6_PROPOS
@author Wagner Mobile Costa
@version P12
@since 28/10/2016
@return lReturn,Logico,Indica se a proposta pode ser incluida
/*/
//-----------------------------------------------------------------------------
User Function TCTTV008

Local lRet := .T.

BeginSQL Alias "PD6QRY"
	SELECT PD6_FILIAL, PD6_PROPOS
	  FROM %table:PD6%
	 WHERE %notDel% AND PD6_FILIAL Between %Exp:' '% AND %Exp:'ZZZZZZZZZZ'%  AND PD6_PROPOS = %Exp:M->PD6_PROPOS%
	   AND PD6_FILIAL <> %Exp:xFilial("PD6")%
EndSql

If ! Empty(PD6QRY->PD6_PROPOS)
   Help(,, "PD6_PROPOS",, "Esta proposta já foi incluida na filial [" + PD6QRY->PD6_FILIAL + "] !", 1, 0)
   lRet := .F.
EndIf

PD6QRY->(DbCloseArea())

Return lRet