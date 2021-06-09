#INCLUDE "TOTVS.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validação do campo PD6_TPOPRO
@author Fabio Veiga Oliva
@version P12
@since 13/12/2019
@return lReturn,Logico,Indica se o subtipo é valida pois para efeito de historico foi mantido no combo o 2=E-learning
/*/
//-----------------------------------------------------------------------------
User Function TCTTV011

Local lRet := .T.
If M->PD6_TPOPRO == '2'
   Help(,, "PD6_TPOPRO",, "O Subtipo E-learning foi descontinuado, escolha outro subtipo!", 1, 0)
   lRet := .F.
EndIf 
If M->PD6_TPOPRO == '6' .And. M->PD6_TIPO <> "2"
   Help(,, "PD6_TPOPRO",, "O Subtipo 6-N.A. só pode ser usado em propostas tipo 2-Recorrente!", 1, 0)
   lRet := .F.
EndIf                                           
If M->PD6_TPOPRO <> '6' .And. M->PD6_TIPO == "2"
   Help(,, "PD6_TPOPRO",, "Quando o tipo da proposta for 2-Recorrente o SubTipo só pode ser 6-N.A.!", 1, 0)
   lRet := .F.
EndIf                                           

Return lRet          

