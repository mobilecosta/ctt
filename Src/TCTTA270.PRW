#INCLUDE "TOTVS.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Fechamento diario de proposta recorrente
@author Fabio Veiga Oliva
@version P12
@since 17/01/2020  
@return lReturn,Logico,Indica se a turma é valida
/*/
//-----------------------------------------------------------------------------
User Function TCTTA270
Local nOpcao		:= 0
Local oDlg
Local aSays			:= {}
Local aButtons		:= {}
Local lEnd			:= .F.
cCadastro := "Fechamento diario de propostas recorrentes"

Aadd(aSays,"Este programa tem o objetivo de processar o fechamento diario de propostas recorrentes")

Aadd(aButtons, { 01,.T.,{|o| nOpcao:=1, o:oWnd:End()}})
Aadd(aButtons, { 02,.T.,{|o| o:oWnd:End()}})

FormBatch(cCadastro,aSays,aButtons,,,465)

If nOpcao == 1
	Processa({|| U_TCTTJ271() },"Processando o fechamento diario...")
EndIf

Return(Nil)

User Function TCTTJ270(aParam)
Local cFUNCDE := "Função TCTTJ270 - Processamento diario de propostas recorrentes"
MV_PAR60 := "JOB"
//--------------------------------------------------------------------
// Seta o ambiente para execução através do JOB
//--------------------------------------------------------------------
RpcClearEnv()
RpcSetType(3) // nao usar licença

If(!RpcSetEnv(aParam[1], aParam[2], "", "", "CTT",,{"SM0","PD6","PD7","PD3"}))
	Conout("------------------------------------------------------------ ---------")
	Conout("- ERRO NA CHAMADA  ===>> Inicio - " + cFUNCDE )
	Conout("-   " + dtoc(dDataBase) + " - " + Time() + " - Empresa/Filial: " + aParam[1] + "/" + aParam[2] )
	Conout("----------------------------------------------------------------------")
else
	Conout("----------------------------------------------------------------------")
	Conout("-    ===>> Inicio - " + cFUNCDE )
	Conout("-   " + dtoc(dDataBase) + " - " + Time() + " - Empresa/Filial: " + aParam[1] + "/" + aParam[2] )
	Conout("----------------------------------------------------------------------")
	
	//--------------------------------------------------
	// Chama a funcao de processamento
	//--------------------------------------------------
	U_TCTTJ271()
	RpcClearEnv()
	//--------------------------------------------------
	
	Conout("----------------------------------------------------------------------")
	Conout("- ===>> Finalização - " + cFUNCDE )
	Conout("-   " + dtoc(dDataBase) + " - " + Time() + " - Empresa/Filial: " + aParam[1] + "/" + aParam[2] )
	Conout("----------------------------------------------------------------------")
	
EndIf
Return


User Function TCTTJ271()
Local dDtIni := SuperGetMV("MV_FECHCTT",.F.,dDataBase) //Parametro que controla ate quando foi feito o processamento
Local dDtFim := dDatabase
Local dDtRec := dDatabase
Local cPerAtu
Local cQuery
Local nHoras := 0
Local cAcumul	
Local nVAcumul	:= 0
Local nDifDt
Local nPerAcul	:= ""
Local cCalcPer	:= 1
Local x
Local nCalcPer
Local cTurma
Local dDtTot

cQuery := "SELECT PD6.PD6_FILIAL,PD6.PD6_PROPOS,PD6.PD6_DTINI,PD6.PD6_DTFINA,PD6.PD6_TOTREC,PD6.PD6_NROREC,PD6.PD6_HSRECO,PD6.PD6_SLDHS,PD6.PD6_ACUMUL,PD6.PD6_DATA,PD6.PD6_VENCTO "
cQuery += " FROM " + RetSqlName("PD6") + " PD6 "
cQuery += " WHERE PD6.PD6_TIPO = '2' AND PD6.PD6_DTFINA = '"+Dtos(dDtRec)+"' AND PD6.PD6_NROREC < PD6.PD6_TOTREC"
cQuery += " AND PD6.D_E_L_E_T_ = ' '"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "PD6QRY" )
TCSetField("PD6QRY","PD6_DTINI" , "D",08,00)
TCSetField("PD6QRY","PD6_DTFINA" , "D",08,00)

dbSelectArea("PD6QRY")
dbGotop()
While PD6QRY->(!Eof())
	cPerAtu := StrZero(PD6QRY->PD6_NROREC+1,4)
	
	RecLock("PGE",.t.)
	PGE->PGE_FILIAL := XFILIAL("PGE")
	PGE->PGE_PROPOS := PD6QRY->PD6_PROPOS
	PGE->PGE_PERIOD := cPerAtu
	PGE->PGE_DATA   := PD6QRY->PD6_DTINI
	PGE->PGE_HORAS  := PD6QRY->PD6_HSRECO
	PGE->PGE_TIPO   := "I"
	PGE->PGE_DESCR  := "Iniciado o Periodo "+cPerAtu
	MsUnlock()
	
	RecLock("PGD",.t.)
	PGD->PGD_FILIAL := XFILIAL("PGD")
	PGD->PGD_PROPOS := PD6QRY->PD6_PROPOS
	PGD->PGD_PERIOD := cPerAtu
	PGD->PGD_DTINI  := PD6QRY->PD6_DTINI
	PGD->PGD_DTFIM  := PD6QRY->PD6_DTFINA
	PGD->PGD_HORAS  := PD6QRY->PD6_HSRECO
	PGD->PGD_STATUS := "A"
	MsUnlock()
	
	//Busca as alocações no periodo atual
	nHoras  := 0                                              
	
    cQuery2 := "SELECT PD7.PD7_FILIAL, PD3.PD3_TURMA, PD3.PD3_NOME, PDL.PDL_NOME, PD3.PD3_QTDHOR,PD7.PD7_ALUNO, "
    cQuery2 +=        "PD3.PD3_DTINI, PD7.PD7_CONFIR, PD7.PD7_HORAS, PD7.PD7_TURMA "
    cQuery2 +=  "FROM " + RETSQLNAME("PD7") + " PD7 "
    cQuery2 +=  "JOIN " + RetSqlName ("PD3") +" PD3 ON PD3_FILIAL = PD7_FILIAL AND PD3_TURMA = PD7_TURMA AND PD3.D_E_L_E_T_ = ' ' "
    cQuery2 +=  "JOIN " + RetSqlName ("PDL") +" PDL ON PDL.PDL_FILIAL = '"+ xFilial("PDL")+"' AND PDL.PDL_ALUNO = PD7.PD7_ALUNO AND PDL.D_E_L_E_T_ = ' ' "
    cQuery2 += "WHERE PD7.PD7_FILPRO = '" + PD6QRY->PD6_FILIAL +"' AND PD7.PD7_PROPOS = '" + PD6QRY->PD6_PROPOS +"' AND PD7.D_E_L_E_T_ = ' ' "
    cQuery2 += " AND PD7.PD7_CONFIR <> '6'"
	//cQuery2 += " AND PD3.PD3_DTINI >= '"+Dtos(PD6QRY->PD6_DTINI)+"' AND PD3.PD3_DTFIM <= '"+Dtos(PD6QRY->PD6_DTFINA)+"'"
	cQuery2 += " AND PD3.D_E_L_E_T_ = ' '"
    cQuery2 += "ORDER BY PD7.PD7_FILIAL, PD7.PD7_ALUNO "	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2), "PD7QRY" )
	TCSetField("PD7QRY","PD3_DTINI" , "D",08,00)
	dbSelectArea("PD7QRY")
	dbGotop()
	cTurma := PD7QRY->PD7_TURMA

	While !Eof()
		nHoras += PD7QRY->PD7_HORAS
		RecLock("PGE",.t.)
		PGE->PGE_FILIAL := XFILIAL("PGE")
		PGE->PGE_PROPOS := PD6QRY->PD6_PROPOS
		PGE->PGE_PERIOD := cPerAtu
		PGE->PGE_DATA   := PD7QRY->PD3_DTINI
		PGE->PGE_HORAS  := PD7QRY->PD7_HORAS
		PGE->PGE_TIPO   := "A"
		PGE->PGE_DESCR  := "Alocacao aluno: "+ALLTRIM(PD7QRY->PD7_ALUNO)+" "+PD7QRY->PDL_NOME
		MsUnlock()  
		dbSelectArea("PD7QRY")
		dbSkip()
	EndDo
	cAcumul := PD6QRY->PD6_ACUMUL

	//1=Mensal;2=Bimestral;3=Trimestral;4=Semestral;5=Anual 
	Do Case
	Case cAcumul == "1"
		nVAcumul := 1
		nCalcPer := 30
	Case cAcumul == "2"
		nVAcumul := 3
		nCalcPer := 60
	Case cAcumul == "3"
		nVAcumul := 4
		nCalcPer := 90
	Case cAcumul == "4"
		nVAcumul := 7
		nCalcPer := 180
	Case cAcumul == "5"
		nVAcumul := 13
		nCalcPer := 365
	EndCase
	If nVAcumul > 1
		nDifDt := STOD(PD6QRY->PD6_DATA) - STOD(PD6QRY->PD6_VENCTO)

		If nDifDt < 0
			nDifDt := nDifDt * (-1)
		EndIf

		nDifDt := nDifDt/30
		nDifDt := Int(nDifDt)-1

		For x:=1 To nDifDt
			If nVAcumul  == cCalcPer
				nPerAcul += Alltrim(Str(cCalcPer))+"/"
				nVAcumul +=	Val(PD6QRY->PD6_ACUMUL)
			EndIf
			cCalcPer++
		Next x
	EndIf

	RecLock("PGD",.F.)
	PGD->PGD_SALDO  := PD6QRY->PD6_HSRECO - nHoras
	PGD->PGD_REALIZ := nHoras
	PGD->PGD_EXPIRA := PD6QRY->PD6_HSRECO - nHoras
	MsUnlock()
	
	RecLock("PGE",.T.)
	PGE->PGE_FILIAL := XFILIAL("PGE")
	PGE->PGE_PROPOS := PD6QRY->PD6_PROPOS
	PGE->PGE_PERIOD := cPerAtu
	PGE->PGE_DATA   := dDataBase
	PGE->PGE_HORAS  := PD6QRY->PD6_HSRECO - nHoras
	PGE->PGE_TIPO   := "F"
	PGE->PGE_DESCR  := "Finalizado o Periodo "+cPerAtu
	MsUnlock()
	
	//Inicia um novo periodo na proposta
	dbSelectArea("PD6")
	dbSetOrder(1)
	If dbSeek(PD6QRY->PD6_FILIAL+PD6QRY->PD6_PROPOS)
		RecLock("PD6",.F.)
		PD6->PD6_NROREC := PD6->PD6_NROREC + 1
		If PD6->PD6_NROREC < PD6->PD6_TOTREC
			PD6->PD6_DTINI  := PD6->PD6_DTFINA + 1
			PD6->PD6_DTFINA := PD6->PD6_DTINI + PD6->PD6_NRODIA
		    PD6->PD6_SLDHS  := PD6->PD6_HORAS
			PD6->PD6_SLDPRO := PD6->PD6_SLDPRO - nHoras //AJUSTADO
			PD6->PD6_PERIOD := PD6->PD6_PERIOD + 1
			If PD6QRY->PD6_ACUMUL <> "1"
				nSldRec	:= PD6->PD6_SLDREC - nHoras
				If nSldRec < 0
					nSldRec:= nSldRec*(-1)
				EndIf
				// CONDICAO PARA calculo das horas na RECORRENCIA 
				dDtTot := PD6QRY->PD6_DTINI+nCalcPer //dDatabase >= PD6QRY->PD6_DTINI+nCalcPer
				If StrZero(Month(dDatabase),2) + StrZero(Year(dDatabase),4) >= StrZero(Month(dDtTot),2) + StrZero(Year(dDtTot),4) 
					PD6->PD6_SLDREC := IIF(Alltrim(Str(PD6->PD6_PERIOD))$(nPerAcul),PD6->PD6_HORAS,PD6->PD6_HORAS + (PD6->PD6_HORAS - nHoras)) 
					PD6->PD6_SLDEXE := IIF(Alltrim(Str(PD6->PD6_PERIOD))$(nPerAcul),nHoras,0) 
				Else
					PD6->PD6_SLDREC := IIF(PD6->PD6_SLDREC==0,PD6->PD6_HORAS+(PD6->PD6_HORAS-nHoras),PD6->PD6_SLDREC+(PD6->PD6_HORAS-nHoras))
					PD6->PD6_SLDEXE := PD6->PD6_SLDEXE + nHoras			
				EndIf
			Else
				PD6->PD6_SLDREC := PD6->PD6_HORAS
				PD6->PD6_SLDEXE := 0 //AJUSTADO
			EndIf 
		EndIf            
		MsUnlock()
	EndIf
	//Zera as horas da alocação quando executa a recorrencia
	dbSelectArea('PD7')
	dbSetOrder(1)
	If dbSeek(xFilial("PD7")+cTurma) 	
		While PD7->(!Eof()) .And. xFilial('PD7')+PD7->PD7_TURMA == xFilial('PD3')+cTurma
			If PD7->PD7_CONFIR $ "1,5,6,7"  // Só pode alterar o status que consome horas da proposta
				RecLock("PD7",.F.)
				PD7->PD7_HORAS  := 0
				PD7->(MsUnlock())
			EndIf
			PD7->(DbSkip())
		EndDo
	EndIf

	nPerAcul := ""
	cCalcPer := 0
	dbCloseArea("PD7QRY")
	dbSelectArea("PD6QRY")
	dbSkip()
EndDo
dbCloseArea()
dbCloseArea("PD7QRY")
PutMV("MV_FECHCTT",dDatabase)
Return

//Gatilho para calcular o saldo total da proposta
User Function TCTTSLD(cDtAcum)

Local nSldTOT	:= 0
Local nDifDt
Local cAcumul	:= M->PD6_ACUMUL
Local nVAcumul	:= 0
//1=Mensal;2=Bimestral;3=Trimestral;4=Semestral;5=Anual 
Do Case
Case cAcumul == "1"
	nVAcumul := 1
Case cAcumul == "2"
	nVAcumul := 2
Case cAcumul == "3"
	nVAcumul := 3
Case cAcumul == "4"
	nVAcumul := 6
Case cAcumul == "5"
	nVAcumul := 12
EndCase

nDifDt := M->PD6_DATA - M->PD6_VENCTO

If nDifDt < 0
	nDifDt := nDifDt * (-1)
EndIf

If cDtAcum = 1
	nDifDt := nDifDt/30
	nDifDt := Int(nDifDt)
	nSldTOT := nDifDt * M->PD6_HORAS
EndIf
     
If cDtAcum = 2
	nSldTOT := M->PD6_HORAS
EndIf

nSldTOT := Int(nSldTOT)

Return(nSldTOT)

//Gatilho para calcular o saldo  da proposta
User Function TCTTPD7()

dbSelectArea("PD6")
dbSetOrder(1)
If dbSeek(PD7->PD7_FILIAL+PD7->PD7_PROPOS)

	RecLock("PD6",.F.)
	If PD7->PD7_CONFIRM == "1"
		PD6->PD6_SLDEXE := PD6->PD6_SLDEXE+PD7->PD7_HORAS
	EndIf
	If PD7->PD7_CONFIRM == "3"
		PD6->PD6_SLDEXE := PD6->PD6_SLDEXE-PD7->PD7_HORAS
	EndIf
	
	PD6->(MsUnlock())

EndIf

Return(.T.)

User Function TCTTPER(_PerSld)

Local cPer 	:= 0
Local nHPd3 := PD3->PD3_QTDHOR

If _PerSld == 1
	dbSelectArea("PD6")
	dbSetOrder(1)
	If dbSeek(xFilial("PD6")+M->PD7_PROPOS)
		cPer := PD6->PD6_PERIOD
	EndIf
EndIf
If _PerSld == 2
	dbSelectArea("PD3")
	dbSetOrder(1)
	If dbSeek(xFilial("PD3")+PD7->PD7_TURMA)
		cPer := PD3->PD3_QTDHOR
	Else
		cPer := nHPd3
	EndIf
EndIf

Return(cPer)
