#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Valid
Validagco do campo PD6_PROPOS integrado com a consulta TCTTC004

@author Wagner Mobile Costa
@version P12
@since 09/04/2015
@return = lRet = Retorna se a digitagco do campo esta valida
/*/
//-----------------------------------------------------------------------------
User Function TCTTV003

Local lRet   := .T., aArea := GetArea(), cPD7_FILPRO := cFiltro := ""
Local oModel := FWModelActive(), oModelPD7
Local nLine  := 0
Local nPos	 := 0
Local nPD6_SLDHS  := 0 
Local nPD3_QTDHOR := PD3->PD3_QTDHOR

oModelPD7 	  := oModel:GetModel("PD7")
nLine         := oModelPD7:nLine
cPD7_FILPRO   := oModelPD7:GetValue("PD7_FILPRO")
M->PD7_ALUNO  := oModelPD7:GetValue("PD7_ALUNO")
M->PD7_PROPOS := oModelPD7:GetValue("PD7_PROPOS")

If ! Empty(cPD7_FILPRO)
	cFiltro += "PD6.PD6_FILIAL = '" + cPD7_FILPRO + "'"
EndIf
cFiltro += " AND PD6.PD6_PROPOS = '" + M->PD7_PROPOS + "'"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,U_TCTTQPD6(cFiltro)), "PD6QRY" )
TCSetField("PD6QRY","PD6_DTINI" , "D",08,00)
TCSetField("PD6QRY","PD6_DTFIM" , "D",08,00)

If Empty(PD6QRY->PD6_PROPOS)
   	Help(,, "REGNOIS")
   	lRet := .F.
EndIf 

dbSelectArea("PD6")
dbSetOrder(1)
dbSeek(xFilial("PD6")+PD6QRY->PD6_PROPOS)

//Valida a data de expiracao da proposta
If !Empty(PD6->PD6_DTFIM) .And. PD6->PD6_DTFIM < dDatabase
   Help(,, "PD7_PROPOS",, "Proposta expirou em:"+DTOC(PD6->PD6_DTFIM)+" [" + M->PD7_PROPOS + "]", 1, 0)
   lRet := .F.
EndIf   
         
If PD6->PD6_TIPO <> '2'  //Proposta diferente de recorrente
   nPD6_SLDHS  := PD6->PD6_SLDHS

   If lRet .And. Empty(cPD7_FILPRO)
   	  oModelPD7:SetValue('PD7_FILPRO', PD6->PD6_FILIAL)
   EndIf

   If lRet
	  For nPos := 1 To oModelPD7:Length()
		oModelPD7:GoLine( nPos )
	
		If oModelPD7:GetValue("PD7_ALUNO") == M->PD7_ALUNO
			nPD3_QTDHOR -= oModelPD7:GetValue("PD7_HORAS")
		EndIf
		
		If nPos == nLine .Or. oModelPD7:IsDeleted() .Or. oModelPD7:IsInserted() .Or. oModelPD7:GetValue("PD7_PROPOS") <> M->PD7_PROPOS
			Loop
		EndIf
		
		If 	PD7->(DbSeek(xFilial() + PD3->PD3_TURMA + oModelPD7:GetValue("PD7_ALUNO") + oModelPD7:GetValue("PD7_PROPOS"))) .And.;
			PD7->PD7_HORAS <> oModelPD7:GetValue("PD7_HORAS") .And. oModelPD7:GetValue("PD7_CONFIR") <> 6 .And. oModelPD7:GetValue("PD7_CONFIR") <> 7
			nPD6_SLDHS -= oModelPD7:GetValue("PD7_HORAS")
		EndIf
	 Next
   EndIf

   If nPD6_SLDHS < 0
	  nPD6_SLDHS := 0
   EndIf

   If nPD3_QTDHOR < 0
	  nPD3_QTDHOR := 0
   EndIf

   nPD6_SLDHS := If(nPD3_QTDHOR > nPD6_SLDHS, nPD6_SLDHS, nPD3_QTDHOR)
   PD6QRY->(DbCloseArea())
Else
   nPD6_SLDHS  := PD6QRY->PD6_SLDHS

   If lRet .And. Empty(cPD7_FILPRO)
   	  oModelPD7:SetValue('PD7_FILPRO', PD6QRY->PD6_FILIAL)
   EndIf

   If lRet
	  For nPos := 1 To oModelPD7:Length()
		oModelPD7:GoLine( nPos )
	
		If oModelPD7:GetValue("PD7_ALUNO") == M->PD7_ALUNO
			nPD3_QTDHOR -= oModelPD7:GetValue("PD7_HORAS")
		EndIf
		
		If nPos == nLine .Or. oModelPD7:IsDeleted() .Or. oModelPD7:IsInserted() .Or. oModelPD7:GetValue("PD7_PROPOS") <> M->PD7_PROPOS
			Loop
		EndIf
		
		If 	PD7->(DbSeek(xFilial() + PD3->PD3_TURMA + oModelPD7:GetValue("PD7_ALUNO") + oModelPD7:GetValue("PD7_PROPOS"))) .And.;
			PD7->PD7_HORAS <> oModelPD7:GetValue("PD7_HORAS") .And. oModelPD7:GetValue("PD7_CONFIR") <> 6 .And. oModelPD7:GetValue("PD7_CONFIR") <> 7 .And.;
			PD3->PD3_DTINI >= PD6QRY->PD6_DTINI .And. PD3->PD3_DTINI <= PD6QRY->PD6_DTFIM 
			nPD6_SLDHS -= oModelPD7:GetValue("PD7_HORAS")
		EndIf
	 Next
   EndIf

   If nPD6_SLDHS < 0
	  nPD6_SLDHS := 0
   EndIf

   If nPD3_QTDHOR < 0
	  nPD3_QTDHOR := 0
   EndIf

   nPD6_SLDHS := If(nPD3_QTDHOR > nPD6_SLDHS, nPD6_SLDHS, nPD3_QTDHOR)
   PD6QRY->(DbCloseArea())
EndIf

If lRet
   oModelPD7:GoLine( nLine )
   oModelPD7:SetValue('PD7_HORAS', 0)
   If oModelPD7:GetValue("PD7_CONFIR") $ '1,3,5'
     oModelPD7:SetValue('PD7_HORAS', nPD6_SLDHS)
   EndIf
EndIf

RestArea(aArea)

Return lRet
