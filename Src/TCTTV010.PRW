#INCLUDE "TOTVS.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validação do campo PD7_TURMAR
@author Fabio Veiga Oliva
@version P12
@since 13/12/2019
@return lReturn,Logico,Indica se a turma é valida
/*/
//-----------------------------------------------------------------------------
User Function TCTTV010

Local lRet := .T.
Local aArea    := GetArea()
Local aAreaPD3 := PD3->(GetArea())
                                     
dbSelectArea("PD3")
dbSetOrder(1)
If !Empty(M->PD7_TURMAR) .And. !dbSeek(xFilial("PD3")+M->PD7_TURMAR)
   Help(,, "PD7_TURMAR",, "Turma não encontrada [" + M->PD7_TURMAR + "] !", 1, 0)
   lRet := .F.
EndIf 

RestArea(aAreaPD3)
RestArea(aArea)
Return lRet

