#INCLUDE "TCTTIMVC.ch"
#Include 'TOTVS.ch'
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina para importação automática via MVC

@author Wagner Mobile Costa
@version P12
@since 10/04/2015
/*/
//-----------------------------------------------------------------------------

User Function TCTTIMVC()

Local oModel   := Nil, cModel := cSQL := "", lSQL := lField := lExecute := .F. 
Local aTable   := {}, cTime   := Time(), nOperation := MODEL_OPERATION_INSERT
Local nInsert  := 0	
Private Titulo := STR0001 //"Importação das Tabelas do Módulo CTT"
Private aFormsMVC := {}
Private lErro	  := .F.

	FT_FUse("tcttimvc.ini")
	FT_FGoTop ()
	cLinha := FT_FREADLN()
	AutoGrLog( STR0002 + Time() + STR0003) //"Inicio em ["###"]"

	Do While !FT_FEof()
		If Left(cLinha, 8) = "</MODEL>"
			MsAguarde({|| Import(oModel, cModel, aTable, nOperation)}, Titulo, "Importando [" + aFormsMVC[1][2] + "]. Aguarde....", .T.)
			cModel := ""
		ElseIf Left(cLinha, 7) = "<TABLE="
			Aadd(aTable, { Subs(cLinha, 8, Len(cLinha) - 8), "", {}, {} })
			aFields := {}
		ElseIf Left(cLinha, 7) = "<FIELD="
			Aadd(aTable[Len(aTable)][3], { Subs(cLinha, 8, Len(cLinha) - 8), {} })
			lField := .T.
		ElseIf Left(cLinha, 8) = "</FIELD>"
			lField := .F.
		ElseIf lField
			Aadd(aTable[Len(aTable)][3][Len(aTable[Len(aTable)][3])][2], cLinha)
		ElseIf Left(cLinha, 5) = "<SQL>"
			lSQL := .T.
			cSQL := ""
		ElseIf Left(cLinha, 6) = "</SQL>"
			lSQL := .F.
			aTable[Len(aTable)][2] := cSQL
		ElseIf lSQL
			cSQL += cLinha + Chr(13) + Chr(10)
		ElseIf Left(cLinha, 9) = "<EXECUTE>"
			lExecute := .T.
			cSQL := ""
		ElseIf Left(cLinha, 10) = "</EXECUTE>"
			lExecute := .F.
			If Empty(cModel)
			   ExecSQL(cSQL)
			EndIf
		ElseIf lExecute
			If Empty(cModel)
			   cSQL += cLinha + Chr(13) + Chr(10)
			Else
				Aadd(aTable[Len(aTable)][4], cLinha)
			EndIf
		ElseIf Left(cLinha, 11) = "<OPERATION>"
			nOperation := Val(Substring(cLinha, 12, 1))
		ElseIf Left(cLinha, 7) = "<MODEL="
			aTable := {} 
			cModel := Subs(cLinha, 8, Len(cLinha) - 8)
			oModel := FWLoadModel( cModel )
			lExecute := .F.
		EndIf
		FT_FSkip ()
		cLinha := FT_FREADLN()
	EndDo

	FT_FUse()
	AutoGrLog( STR0004 + Time() + "]") //"Finalizado em ["
	If lErro
		If MsgYesNo('Importação realizada com erros ! Inicio ' + cTime + STR0005 + Time() + STR0006) //" e final "###". Deseja visualizar ?"
			MostraErro()
		EndIf
	Else
		Alert('Importação realizada com sucesso ! Inicio ' + cTime + STR0005 + Time()) //" e final "
		MostraErro()
	EndIf

Return

Static Function ExecSQL(cSQL)

Local nError  := nPage := nAt := 0, cGetDB := TcGetDb(), aInsert := { }, nPages := 500000
Local cInsert := cSelect := "", aFil := {}
Local nInsert := 0

If SM0->M0_CODIGO == "00"
	aFil := { { "01", "00001000100" }, { "07", "00001001200" }, { "11", "00001001700" }, { "01", "00101000100" } }
ElseIf SM0->M0_CODIGO == "02"
	aFil := { { "01", "20001155100" } }
EndIf

aInsert := { Translate(cSQL) }

If .F. // Upper(cGetDB) == "ORACLE" .And. Left(cSQL, 6) = "INSERT"
   nAt  := At("SELECT", aInsert[1])
   cInsert := Left(aInsert[1], nAt - 1)

   cSelect := Subs(aInsert[1], nAt, Len(aInsert[1]))
   cSQL := "SELECT COUNT(*) AS REG FROM (" + cSelect + ")"

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL), "QRY" )
   If QRY->REG > nPages
      aInsert := {}
      While nPage < QRY->REG
         nPage += nPages
         cSQL := cInsert + " SELECT * FROM (" + cSelect + ") " +;
                             "WHERE ROWNUM >= " + AllTrim(Str(nPage - nPages + 1)) + " AND ROWNUM <= "  + AllTrim(Str(nPage))

         Aadd(aInsert, cSQL)
      EndDo
   EndIf
   QRY->(DbCloseArea())
EndIf

For nInsert := 1 To Len(aInsert)
    cSQL := aInsert[nInsert]

    MsAguarde({|| nError := TCSQLExec(cSQL) }, Titulo, STR0007, .T.) //"Executando instrução SQL. Aguarde...."
    If nError <> 0
       AutoGrLog( STR0008 + cSQL + STR0009 + AllTrim(Str(nError)) + "-" + TCSQLError() + "-" + Time()) //"Instrução ["###"] - "
    Else
       AutoGrLog( STR0008 + cSQL + STR0010 + Time()) //"Instrução ["###"] - Executada "
    EndIf
Next

Return

Static Function Import(oModel, cModel, aTable, nOperation)

Local nFields := 0
Local nReg := nRegDet := nPos := nImport := 0, lRet := lReadOnly := .F.
Local aErro	  := {}, aFields := {}, lTitulo := .F.
Local cTab	  := cChave := "", cFilAntB := cFilAnt
Local nTab	  := 0
Local nAux	  := 0
Local aTamCpo := {}
Local cCpoAux := ""

If Len(aTable) == 0 .Or. Empty(aTable[1][2])
	Alert(STR0011 + cModel + STR0012) //"Definição do SQL do Modelo ["###"] invalido !"
	Return .F.
EndIf

//-- Importação do cadastro de Cursos
For nTab := 1 To Len(aFormsMVC)
	If ! aFormsMVC[nTab][4]
		TCSQLExec("DELETE FROM " + RetSqlName(aFormsMVC[nTab][1]))
	EndIf
Next

dbUseArea(.T.,"TOPCONN",TcGenQry(,,Translate(aTable[1][2])), "QRY" )



For nFields := 1 To QRY->(FCount())
	cCpoAux := QRY->(FieldName(nFields))
	aTamCpo := TAMSX3( cCpoAux )

	If Len(aTamCpo) > 0 .AND. aTamCpo[3] <> "C"
		TcSetField( cAliProj, cCpoAux, aTamCpo[3], aTamCpo[1], aTamCpo[2] )
	EndIf
Next

DbSelectArea("QRY")
oModel:SetOperation( nOperation )
AutoGrLog( STR0013 + aTable[1][1] + "-" + aFormsMVC[1][2] + STR0014 + (cTime := Time())) //"Tabela "###" - Inicio: "

While ! QRY->(Eof())
	MsProcTxt(STR0015 + aFormsMVC[1][1] + STR0016 + AllTrim(Str(++ nReg))) //"Gravando ["###"] - Registro: "
	ProcessMessage()

	For nAux := 1 To Len(aTable[1][4])
		&(aTable[1][4][nAux])
	Next
	 
	oModel:Activate()
	
	//-- Leitura das tabelas a serem importados
	lRet 	  := .T.
	aModelTab := {}
	aStruTab  := {} 
	For nTab := 1 To Len(aTable)
		Aadd(aModelTab, oModel:GetModel( aTable[nTab][1] ))
		Aadd(aStruTab, aModelTab[Len(aModelTab)]:GetStruct() )
		aFields := aStruTab[Len(aStruTab)]:GetFields()

		cTab := "QRY"
		If nTab > 1
			cTab := "DET"
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,Translate(aTable[nTab][2])), cTab )

			For nFields := 1 To DET->(FCount())
				cCpoAux := DET->(FieldName(nFields))
				aTamCpo := TAMSX3( cCpoAux )
				
				If Len(aTamCpo) > 0 .AND. aTamCpo[3] <> "C"
					TcSetField(cTab, cCpoAux, aTamCpo[3], aTamCpo[1], aTamCpo[2])
				EndIf
			Next
			nRegDet := 0
		EndIf
		
		While If(nTab == 1, .T., ! (cTab)->(Eof()))
			lReadOnly := .F.
			If Empty(aFormsMVC[1][6])
				lReadOnly := aFormsMVC[nTab][4]
			EndIf
			
			If lReadOnly
				Exit
			EndIf

			If nTab > 1
				For nAux := 1 To Len(aTable[nTab][4])
					&(aTable[nTab][4][nAux])
				Next
	 
				If ++ nRegDet > 1
					If aModelTab[Len(aModelTab)]:AddLine() <> nRegDet
						nRegDet --
						lRet := .F.
					EndIf
				EndIf
			EndIf
		
			If lRet
				For nFields := 1 To (cTab)->(FCount())
					nPos := Ascan(aTable[nTab][3], { |x| x[1] == (cTab)->(FieldName(nFields)) }) 
					If nPos > 0
						For nAux := 1 To Len(aTable[nTab][3][nPos][2])
							&(aTable[nTab][3][nPos][2][nAux])
						Next 
					ElseIf "FILIAL" $ (cTab)->(FieldName(nFields)) .And. ! Empty((cTab)->(FieldName(nFields)))
						cFilAnt := &(cTab + "->" + (cTab)->(FieldName(nFields)))
						If Empty(aFormsMVC[nTab][6])
							If ! aModelTab[nTab]:SetValue((cTab)->(FieldName(nFields)), xFilial(aTable[nTab][1], cFilAnt))
								lRet := .F.
							EndIf
						EndIf
					ElseIf aScan( aFields, { |x| AllTrim( x[3] ) ==  AllTrim((cTab)->(FieldName(nFields))) } )  > 0
						If ! aModelTab[nTab]:SetValue((cTab)->(FieldName(nFields)), &(cTab + "->" + (cTab)->(FieldName(nFields))))
							lRet := .F.
						EndIf
					EndIf
				Next
			EndIf
		
			If nTab > 1 .And. lRet
				DET->(DbSkip())
			Else
				Exit
			EndIf		
		EndDo
		If nTab > 1
			DET->(DbCloseArea())
		EndIf
	Next 
	
	If lRet
		lRet := oModel:VldData()
		If lRet
			lRet := oModel:CommitData()
		EndIf
		nImport ++
	EndIf
	
	If !lRet
		aErro := oModel:GetErrorMessage()
		
		If ! lTitulo
			AutoGrLog( STR0017 + aTable[1][1] + "-" + aFormsMVC[1][2]) //"Log de Inconsistencias - Tabela "
			lTitulo := .T.
		EndIf
	
		cChave := ""
		If ! Empty(aFormsMVC[1][6])
			For nFields := 1 To Len(aFormsMVC[1][5])
				cChave += &(QRY->(aFormsMVC[1][5][nFields][2]))
			Next 
		Else
			cChave := &(QRY->(&(aTable[1][1])->(IndexKey(1))))
		EndIf
		
		AutoGrLog( STR0018 +  cChave) //"Chave: "
		AutoGrLog( "Erro: " +  AllToChar( aErro[4]  ) + "-" + AllToChar( aErro[9]  ) + "- Erro:" + AllToChar( aErro[5] + "-"+aErro[6]  ))
		AutoGrLog( Replicate("-", 80))
	
		lErro := .T.
	EndIf
	
	// Desativamos o Model
	oModel:DeActivate()
	
	QRY->(DbSkip())	 
EndDo
QRY->(DbCloseArea())
AutoGrLog( STR0013 + aTable[1][1] + "-" + aFormsMVC[1][2] + STR0019 + AllTrim(Str(nImport)) + STR0020 + Time() +; //"Tabela "###" - Registros: "###" - Fim: "
		   STR0021 + ElapTime(cTime, Time())) //" - Tempo: "
AutoGrLog( "")

cFilAnt := cFilAntB

Return

Static Function Translate(cParser)

Local cLinha := "", n1 := n2 := nExec := 0

Do While .T.
	n1 := At("<ADVPL>",SubString(cParser,1,Len(cParser)))
	if n1 == 0
		Return cParser
	endif
	n2 := At("</ADVPL>",SubString(cParser,n1,Len(cParser)))

	if n2 == 0 .and. n1 > 0
		Alert(STR0022) //"Estrutura sem a tag </ADVPL>!"
		Break
	endif

	cLinha := SubString(cParser,n1+7,n2-8)
	cParam := cLinha

	_xSQL(@cLinha)

	if ValType(cLinha) == "C"
		cParser := SubString(cParser,1,n1-1)+cLinha+SubString(cParser,n2+7+n1,Len(cParser))
		nExec ++
	ElseIf nExec > 1
      	Alert(STR0023 + cParam + STR0024 + cParser + "] ") //"Atenção. O parametro ["###"] não está sendo substituido na instrução ["

		Break
	endif
EndDo

Return cParser

Static Function _xSQL(cLinha)

Local nX
Local cRet := ""

if Upper(Alltrim(cLinha)) == STR0025 //"<COLUNAS>"
	For nX := 1 to Len(::aSX3)
		cRet += ", "+alltrim(::aSX3[nX,2])
	Next nX
	cLinha := SubStr(cRet,2,Len(cRet))
else
	cLinha := &(cLinha)
endif

Return

User Function FilToCTT(cFieldV11, cFieldV12)

Local cReturn := "", aFil := U_FilGtCTT()

cReturn := "CASE WHEN " + cFieldV11 + " = '01' THEN '" + aFil[1] + "' ELSE " +;
           "CASE WHEN " + cFieldV11 + " = '03' THEN '" + aFil[2] + "' ELSE " +;
	       "CASE WHEN " + cFieldV11 + " = '07' THEN '" + aFil[3] + "' ELSE '' END END END"

If ! Empty(cFieldV12)	    
	cReturn += " AS " + cFieldV12
EndIf

Return cReturn

User Function FilGtCTT()

Local aFil := { "01", "02", "03" }

If FWSizeFilial() == 11
	aFil := { '00001000100', '00101000100', '00001001200' }
EndIf

Return aFil

User Function FilToSQL(cFieldV11, cFieldV12)

Local cReturn := "CASE WHEN " + cFieldV11 + " = '" + __FIL11 + "' THEN '" + __FIL12 + "' ELSE '' END"

If ! Empty(cFieldV12)
	 cReturn += " AS " + cFieldV12
EndIf

Return cReturn
