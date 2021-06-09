#Include "Protheus.ch"
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validação do campo PDL_CPF-Não permitir duplicidades

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
/*/
//-----------------------------------------------------------------------------

User Function TCTTV001()

Local aArea := GetArea()
Local lRet  := .T.

DbSelectArea("PDL")
DbSetOrder(3)
If DbSeek(xFilial("PDL") + M->PDL_CPF) .And. PDL->PDL_ALUNO <> M->PDL_ALUNO
   Help(,, "PDL_CPF",, "Esse CPF já está cadastrado para o Aluno "+ Alltrim(PDL->PDL_NOME) + " - Cod.: " + Alltrim(PDL->PDL_ALUNO) + ".", 1, 0)
   lRet := .F.
EndIf

RestArea(aArea)

Return lRet
