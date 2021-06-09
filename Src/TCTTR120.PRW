#INCLUDE "TCTTR120.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Lista de presença
@author Fabio José Batista
@version P12
@since 14/04/2015
/*/
//-----------------------------------------------------------------------------
Static nHdl := 0

USER FUNCTION TCTTR120()

Local oMrkBrowse, oDlg, aArea := GetArea(), lOk := .F.
Local bOk 		:= {||If(TCTT120Sel(oMrkBrowse,cArqTrab,@lOk,aProf),(oMrkBrowse:Deactivate(), oDlg:End()), Nil)}
Local aStruct 	:= {}, aColumns := {}, aProf := {}
Local nX		:= 0
Local nProf 	:= 1

//Declaracao de variaveis
Private cTitulo	:= STR0001 //"Impressao"
Private oFont0	:= Tfont():New ( "Calibri" 			  ,  0,20 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private oFont1	:= Tfont():New ( "Calibri" 			  ,  0,10 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private oFont2	:= Tfont():New ( "Calibri" 			  ,  0,20 , , .F./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .T./*ITALICO*/    )
Private oFont3	:= Tfont():New ( "Calibri" 			  ,  0,12 , , .T./*NEGRITO*/  , , , , ,.F./*SUBLINHADO*/, .F./*ITALICO*/    )
Private _nOpc		:= 0
Private _nTotAlu	:= 0
Private _cTitulo	:= STR0002 + SM0->M0_ESTCOB //"LISTA DE PRESENÇA - CENTRO DE TREINAMENTO TOTVS - "

Private cMarca 		:= ""
Private _aAux		:= {}
Private cArqTrab 	:= GetNextAlias()
Private oTempTable	:= FWTemporaryTable():New( cArqTrab )

Public oPrn    	:= NIL

BeginSql Alias "QRY"
  COLUMN PDF_DTINI AS DATE
  COLUMN PDF_DTFIM AS DATE
  
  SELECT PDF_PROF, MIN(PD2_NOME) AS PD2_NOME, MIN(PDF_DTINI) AS PDF_DTINI,
  		 MAX(PDF_DTFIM) AS PDF_DTFIM, SUM(PDF_QTDHOR) AS PDF_QTDHOR
    FROM %table:PDF% PDF
    JOIN %table:PD2% PD2 ON PD2.PD2_FILIAL = %exp:xFilial("PD2")% AND PD2.PD2_PROF = PDF.PDF_PROF AND PD2.%notdel%
   WHERE PDF.PDF_FILIAL = %Exp:PD3->PD3_FILIAL% AND PDF.PDF_TURMA = %Exp:PD3->PD3_TURMA% AND PDF.%notdel%
   GROUP BY PDF.PDF_PROF
   ORDER BY PDF.PDF_PROF
EndSQL

While ! Eof()
	Aadd(aProf, { PDF_PROF, PD2_NOME, PDF_DTINI, PDF_DTFIM, PDF_QTDHOR, .T. })
	DbSkip()
EndDo
DbCloseArea()

If Len(aProf) > 1
	Aadd(aStruct, {"PDF_OK","C",1,0})
	Aadd(aStruct, {"PDF_PROF","C",TamSx3("PDF_PROF")[1],0})
	Aadd(aStruct, {"PD2_NOME","C",TamSx3("PD2_NOME")[1],0})
	Aadd(aStruct, {"PDF_DTINI","D",TamSx3("PDF_DTINI")[1],0})
	Aadd(aStruct, {"PDF_DTFIM","D",TamSx3("PDF_DTFIM")[1],0})
	Aadd(aStruct, {"PDF_QTDHOR","N",TamSx3("PDF_QTDHOR")[1],TamSx3("PDF_QTDHOR")[2]})
	oTemptable:SetFields( aStruct )
	oTempTable:Create()
	DbSelectArea(cArqTrab)
	
	//Preenche Tabela TMP com as informações filtradas
	For nProf := 1 To Len(aProf)
		RecLock(cArqTrab,.T.)
		(cArqTrab)->PDF_PROF := aProf[nProf][1]
		(cArqTrab)->PD2_NOME := aProf[nProf][2]
		(cArqTrab)->PDF_DTINI := aProf[nProf][3]
		(cArqTrab)->PDF_DTFIM := aProf[nProf][4]
		(cArqTrab)->PDF_QTDHOR := aProf[nProf][5]
		MsUnlock()
	Next
	
	//----------------MarkBrowse----------------------------------------------------
	For nX := 1 To Len(aStruct)
		If	! aStruct[nX][1] $ "PDF_OK"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
			aColumns[Len(aColumns)]:SetTitle(RetTitle(aStruct[nX][1]))
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
		EndIf
	Next nX
	
	If !(cArqTrab)->(Eof())
		aSize := MsAdvSize(,.F.,400)
		DEFINE MSDIALOG oDlg TITLE STR0003 + PD3->PD3_TURMA + STR0004 From 300,0 to 800,1000 OF oMainWnd PIXEL //"Seleção Lista Presença - Turma ["###"]"
		oMrkBrowse:= FWMarkBrowse():New()
		oMrkBrowse:SetFieldMark("PDF_OK")
		oMrkBrowse:SetOwner(oDlg)
		oMrkBrowse:SetMenuDef("TCTTR120")
		oMrkBrowse:SetAlias(cArqTrab)
		oMrkBrowse:AddButton(STR0005, bOk,,,, .F., 3 ) //Confirmar
		oMrkBrowse:bMark     	:= {||}
		oMrkBrowse:bAllMark  := {|| TCTT120AlM(oMrkBrowse,cArqTrab)}
		oMrkBrowse:SetDescription("")
		oMrkBrowse:SetColumns(aColumns)
		oMrkBrowse:Activate()
		ACTIVATE MSDIALOg oDlg CENTERED
	EndIf

	(cArqTrab)->(dbCloseArea())
	FErase(cArqTrab)
	
	If ! lOk
		Alert(STR0006) //"Atenção. Não foi selecionado nenhum professor para impressão da lista de presença !"
		Return
	EndIf
EndIf
RestArea(aArea)

oPrn := TMSPrinter():New(cTitulo)
oPrn:SetPaperSize(9)
oPrn:SetLandscape()

_nOpc := Aviso(	STR0007	,; //"### Tipo de Impressao ###"
				STR0008,; //"Selecione o tipo de impressão para este relatório:"
				{STR0009,STR0010,STR0011},1) //"Tela"###"Excel"###"Cancelar"
					
Prep_obj(aProf)

If _nOpc == 1
	Monta_interface()
EndIf	

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Marcação dos registros a serem impressos
@author Wagner Mobile Costa
@version P12
@since 10/05/2015
/*/
//-----------------------------------------------------------------------------
Static Function TCTT120AlM(oMrkBrowse,cArqTrab)
Local cMarca := oMrkBrowse:Mark()

dbSelectArea(cArqTrab)
(cArqTrab)->(DbGoTop())
While !(cArqTrab)->(Eof())
	RecLock(cArqTrab, .F.)
	If (cArqTrab)->PDF_OK == cMarca
		(cArqTrab)->PDF_OK := ' '
	Else
		(cArqTrab)->PDF_OK := cMarca
	EndIf
	MsUnlock()
	(cArqTrab)->(DbSkip())	
End

oMrkBrowse:oBrowse:Refresh(.T.)
Return .T.	

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina para seleção dos registros
@author Wagner Mobile Costa
@version P12
@since 10/05/2015
/*/
//-----------------------------------------------------------------------------
Static Function TCTT120Sel(oMrkBrowse,cArqTrab,lOk,aProf)
Local cMarca := oMrkBrowse:Mark()
Local nPos	 := 0

dbSelectArea(cArqTrab)
(cArqTrab)->(DbGoTop())
While !(cArqTrab)->(Eof())
	nPos := Ascan(aProf, {|x| x[1] == (cArqTrab)->PDF_PROF })
	If nPos > 0
		aProf[nPos][6] := (cArqTrab)->PDF_OK == cMarca
		If aProf[nPos][6]
			lOk := .T.
		EndIf
	EndIf
	(cArqTrab)->(DbSkip())	
End

Return  .T.	

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
 Monta interface com o usuario
@author Fabio José Batista
@version P12
@since 14/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function Monta_interface()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY STR0012 OF oDlg PIXEL Size 150,010  COLOR CLR_HBLUE //"Esse relatório exibe a lista de presença."

@  6,167 BUTTON "&Imprime"	SIZE 036,012 ACTION	oPrn:Print()		OF oDlg PIXEL
@ 28,167 BUTTON "&Setup"	SIZE 036,012 ACTION	oPrn:Setup()		OF oDlg PIXEL
@ 49,167 BUTTON "Pre&view"	SIZE 036,012 ACTION	oPrn:Preview()		OF oDlg PIXEL
@ 70,167 BUTTON STR0013		SIZE 036,012 ACTION	oDlg:End()  		OF oDlg PIXEL //"Sai&r"

ACTIVATE MSDIALOG oDlg CENTERED

Return


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Faz a leitura das turmas para envio de impressão de relatório ou excel

@author Fabio José Batista
@version P12
@since 14/04/2015
/*/
//-----------------------------------------------------------------------------
Static Function Prep_obj(aProf)

Local nJ 	  	  := 0
Local nPDM_TPOSIS := 1
Local nHora 	  := 0
Local aPDM_TPOSIS := RetSx3Box(POSICIONE("SX3", 2, "PDM_TPOSIS", "X3CBOX()"),,, 1), cArq := ""

Private aDatas 	  := {}
Private _nPula	  := 0
Private nlin 	  := 100
Private npos 	  := 2025
Private cMarca	  := ""

// Marca
cPDM_TPOSIS := POSICIONE("PDM",1,xFilial("PDM")+PD3->PD3_CURSO,"PDM_TPOSIS")
If ! Empty(cPDM_TPOSIS)
	nPDM_TPOSIS := Ascan(aPDM_TPOSIS,{ |x| x[2] = cPDM_TPOSIS })
	If nPDM_TPOSIS > 0
		cMarca := Alltrim(aPDM_TPOSIS[nPDM_TPOSIS][3])
	EndIf
EndIf

DbSelectArea("PDI")
DbSetOrder(2)	// PDI_FILIAL + PDI_TURMA + PDI_PROF + PDI_DATA + PDI_HRINI
M->PDI_QTDHOR := 0
If DbSeek(xFilial("PDI") + PD3->PD3_TURMA )
	While ! PDI->(EOF()) .AND. PDI->(PDI_FILIAL+PDI_TURMA) == PD3->(PD3_FILIAL+PD3_TURMA)
		If Len(aProf) == 0 .Or. Ascan(aProf, {|x| x[1] == PDI->PDI_PROF .And. x[6] }) > 0 
			AADD(aDatas, {DTOC(PDI->PDI_DATA),PDI->PDI_HRINI,PDI->PDI_HRFIM })
			M->PDI_PROF := PDI->PDI_PROF 
			
			nHora := Val(Left(PDI->PDI_HRFIM, 2)) - Val(Left(PDI->PDI_HRINI, 2))
			nHora += ((Val(Right(PDI->PDI_HRFIM, 2)) - Val(Right(PDI->PDI_HRINI, 2))) / 60)

			M->PDI_QTDHOR += nHora

			If ! Empty(PDI->PDI_INTER)
				nHora := Val(Left(PDI->PDI_INTER, 2))
				nHora += ((Val(Right(PDI->PDI_INTER, 2))) / 60) 
				M->PDI_QTDHOR -= nHora
			EndIf
		EndIf

		PDI->(DbSkip())

		If 	(Len(aDatas) > 0) .And.;
			(PDI->(EOF()) .Or. PDI->(PDI_FILIAL+PDI_TURMA) <> PD3->(PD3_FILIAL+PD3_TURMA) .Or.;
			 PDI->PDI_PROF <> M->PDI_PROF)
			aSort(aDatas,,,{|a,b| a[1] + a[2] < b[1] + b[2] })
			
			//-------------------------
			// 1 = Tela ; 2 = Excel  //
			//-------------------------
			If _nOpc == 1
				For nJ:=1 to Len(aDatas)
					
					_nPula++
					If _nPula > 5
						Cabec( _aAux )
						ImpLista( _aAux )
						_nPula	:= 1
						_aAux	:= {}
						AADD(_aAux,aDatas[nJ,1] + " " + Trans(aDatas[nJ,2], "@R 99:99") + " a " + Trans(aDatas[nJ,3], "@R 99:99"))
					Else
						AADD(_aAux,aDatas[nJ,1] + " " + Trans(aDatas[nJ,2], "@R 99:99") + " a " + Trans(aDatas[nJ,3], "@R 99:99"))
					EndIf
					
					If nJ == Len(aDatas)
						Cabec( _aAux )
						ImpLista( _aAux )
					EndIf
					
				Next nJ
			ElseIf _nOpc == 2 .And. Len(aDatas) > 0
				If nHdl == 0
					cArq := GetTempPath() + "LISTA_" + DtoS(DATE()) + StrTran(TIME(),":","") + ".CSV"
					nHdl := FCreate(cArq)
				EndIf

				MsgRun(STR0014,,{ || ImpExcel( aDatas ) }) //"Imprimindo lista em Excel ..."
			EndIf
			aDatas := {}
			_aAux  := {}
			M->PDI_QTDHOR := 0
		EndIf
		DbSelectArea("PDI")
	EndDo
EndIf

If _nOpc == 1
	oPrn:End()
Else
	FClose(nHdl)
	
	// Abre arquivo no Excel
	If !ApOleClient( "MsExcel" )
		MsgStop(STR0015) //"Microsoft Excel nao instalado!"
	ElseIf ! Empty(cArq)
		_oExcel := MsExcel():New()
		_oExcel:WorkBooks:Open(cArq)	// Abre uma planilha
		_oExcel:SetVisible(.T.) 		// Visualiza a planilha
		_oExcel:Destroy()
	EndIf

	nHdl := 0
EndIf

Return
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
 Monta o cabeçalho do relatorio
@author Fabio José Batista
@version P12
@since 14/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function Cabec( _aAux )

Local _cDat1	:= ""
Local _cDat2	:= ""
Local _cDat3	:= ""
Local _cDat4	:= ""
Local _cDat5	:= ""
Local _nX		:= 0

PD2->(dbsetorder(1))
PD3->(dbsetorder(1))
PDO->(dbsetorder(1))

For _nX := 1 To Len(_aAux)
	If _nX == 1
		_cDat1 := _aAux[_nX]
	ElseIf _nX == 2
		_cDat2 := _aAux[_nX]
	ElseIf _nX == 3
		_cDat3 := _aAux[_nX]
	ElseIf _nX == 4
		_cDat4 := _aAux[_nX]
	ElseIf _nX == 5
		_cDat5 := _aAux[_nX]
	EndIf	
Next _nX

oPrn:StartPage()
TCTTRCAB()

oPrn:SayBitmap( 060,060, 'logotipo.bmp',442,153, , .T. )  

//MARCA     1Topo  LE  Fundo  LD
oPrn:Box(0600,0050, 2350,  1000)
//PERIODO  2Topo  LE  Fundo  LD
oPrn:Box(0600,0050, 2350,  1770)
//INSTRUTOR Topo  LE  Fundo  LD
oPrn:Box(0500,1770, 2350,  3335)
//CARGAHORA Topo  LE  Fundo  LD
oPrn:Box(0600,1770, 2350,  3335)
//marca     Topo  LE  Fundo  LD
oPrn:Box(0700,0050, 2350,  3335)
//sala             LE  Fundo  LD
oPrn:Box(0700,2000, 2350,  3335)
//empresa          LE  Fundo  LD
oPrn:Box(0950,0050, 2350,  3335)
//data            LE  Fundo  LD
oPrn:Box(0800,2000, 2350,  3335)
//coluna 1         LE  Fundo  LD
oPrn:Box(0800,2000, 2350,  2267)
//coluna 2         LE  Fundo  LD
oPrn:Box(0800,2267, 2350,  2534)
//coluna 3         LE  Fundo  LD
oPrn:Box(0800,2534, 2350,  2801)
//coluna 4         LE  Fundo  LD
oPrn:Box(0800,2801, 2350,  3068)
//coluna 5         LE  Fundo  LD
oPrn:Box(0800,3068, 2350,  3335)

//--------------------------
// Informacoes das datas  //
//--------------------------
nPos := 2035
oPrn:Say( 835,nPos,Left(_cDat1, 10),oFont3)
If ! Empty(Right(_cDat1, 13))
	oPrn:Say( 885,nPos - 15,Right(_cDat1, 13),oFont3)
EndIf
nPos += 265					
oPrn:Say( 835,nPos,Left(_cDat2, 10),oFont3)
If ! Empty(Right(_cDat2, 13))
	oPrn:Say( 885,nPos - 15,Right(_cDat2, 13),oFont3)
EndIf
nPos += 265
oPrn:Say( 835,nPos,Left(_cDat3, 10),oFont3)
If ! Empty(Right(_cDat3, 13))
	oPrn:Say( 885,nPos - 15,Right(_cDat3, 13),oFont3)
EndIf
nPos += 265
oPrn:Say( 835,nPos,Left(_cDat4, 10),oFont3)
If ! Empty(Right(_cDat4, 13))
	oPrn:Say( 885,nPos - 15,Right(_cDat4, 13),oFont3)
EndIf
nPos += 265
oPrn:Say( 835,nPos,Left(_cDat5, 10),oFont3)
If ! Empty(Right(_cDat5, 13))
	oPrn:Say( 885,nPos - 15,Right(_cDat5, 13),oFont3)
EndIf
nPos += 265

PDO->(dbseek(xFilial("PDO") + PD3->PD3_SALA))
PD2->(Dbseek(xFilial("PD2") + M->PDI_PROF))

oPrn:Say( 533, 100 , STR0016+PD3->PD3_TURMA + "-" + alltrim(PD3->PD3_NOME)  ,oFont3) //"CURSO: "
oPrn:Say( 633, 100 , STR0017+alltrim(cMarca)  ,oFont3) //"MARCA: "
oPrn:Say( 633, 1030, "PERÍODO: " + 	aDatas[1][1] + " até " + aDatas[Len(aDatas)][1], oFont3)
oPrn:Say( 783, 300 , STR0018  ,oFont3) //"EMPRESA"
oPrn:Say( 783, 1050, STR0019  ,oFont3) //"PARTICIPANTE"
oPrn:Say( 633, 1800, alltrim(PDO->PDO_NOME)  ,oFont3)//NOME DA SALA
oPrn:Say( 783, 1850, STR0020  ,oFont3) //"CPF"
oPrn:Say( 533, 2150, STR0021+alltrim(PD2->PD2_NOME)  ,oFont3)//NOME DO PROFESSOR //"INSTRUTOR(a): "
oPrn:Say( 633, 2825, STR0022+alltrim(str(M->PDI_QTDHOR))+STR0023  ,oFont3) //"CARGA HORÁRIA: "###"hs"
oPrn:Say( 733, 2600, STR0024  ,oFont3) //"DATA"
//linhas           LE  Fundo  LD

oPrn:Box(1050,0050, 2350, 3335)
oPrn:Box(1150,0050, 2350, 3335)
oPrn:Box(1250,0050, 2350, 3335)
oPrn:Box(1350,0050, 2350, 3335)
oPrn:Box(1450,0050, 2350, 3335)
oPrn:Box(1550,0050, 2350, 3335)
oPrn:Box(1650,0050, 2350, 3335)
oPrn:Box(1750,0050, 2350, 3335)
oPrn:Box(1850,0050, 2350, 3335)
oPrn:Box(1950,0050, 2350, 3335)
oPrn:Box(2050,0050, 2350, 3335)
oPrn:Box(2150,0050, 2350, 3335)
oPrn:Box(2250,0050, 2350, 3335)

npos := 850
nlin := 100
oPrn:Say(  nlin, npos , _cTitulo ,oFont0)
nLin := 983

Return()

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
 Impressão da lista de presença

@author Fabio José Batista
@version P12
@since 14/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function ImpLista( _aAux )

Local _nPulo := 0
Local cNome  := ""

_nTotAlu := 0

SA1->(DbSetOrder(1))
PDL->(DbSetOrder(1))
PD7->(dbSetOrder(1))

PD7->(dbSeek( xFilial( "PD7" ) + PD3->PD3_TURMA ))
While PD7->(!EOF()) .And. PD7->PD7_TURMA == PD3->PD3_TURMA .AND. PD7->PD7_FILIAL == PD3->PD3_FILIAL
   If ( PD7->PD7_CONFIR == '1' .OR. PD7->PD7_CONFIR == '5' .OR. PD7->PD7_CONFIR == '6' )

      If ! Empty(PD7->PD7_PROSPE)
      	  SUS->( dbseek(xFilial("SUS")+ PD7->PD7_PROSPE + PD7->PD7_LOJPRO))
      	  cNome := Left(AllTrim(SUS->US_NREDUZ), 30) + " - " + Trans(SUS->US_CGC, If(Len(AllTrim(SUS->US_CGC)) = 14, "@R 99.999.999/9999-99", "@R 999.999.999-99"))
      Else
      	  SA1->( dbseek(xFilial("SA1")+ PD7->PD7_CLIENT + PD7->PD7_LOJA))
      	  cNome := Left(AllTrim(SA1->A1_NREDUZ), 30) + " - " + Trans(SA1->A1_CGC, If(Len(AllTrim(SA1->A1_CGC)) = 14, "@R 99.999.999/9999-99", "@R 999.999.999-99"))
      EndIf
      oPrn:Say( nLin, 070, alltrim(cNome),oFont1)

      PDL->(dbseek(xFilial("PDL")+ PD7->PD7_ALUNO))
      oPrn:Say( nLin, 1030, SubStr(alltrim(PDL->PDL_NOME),1,30) + " - " + alltrim(PD7->PD7_ALUNO),oFont1)
      oPrn:Say( nLin, 1790, alltrim(PDL->PDL_CPF)  ,oFont1)

      nLin+=100
      _nPulo ++
      _nTotAlu ++

      If _nPulo == 14
         oPrn:EndPage()
         _nPulo	:= 1
         nlin 	:= 100
         Cabec(_aAux)
      EndIf
   endif

   PD7->(DbSkip())
End

//------------------------
// Quantidade de alunos //
//------------------------
oPrn:Say(2390,0050,STR0025 + cValToChar(_nTotAlu),oFont1) //"QUANTIDADE DE ALUNOS: "
oPrn:EndPage()

Return()

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
 Impressao em Excel da lista de presenca
@author Fabio José Batista
@version P12
@since 14/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function ImpExcel( _aDatas )

Local _nX		:= 0
Local _cDatas	:= ""
Local _oExcel	:= NIL
Local cNome		:= ""

// Manipulacao das datas
For _nX := 1 To Len(_aDatas)
	_cDatas += _aDatas[_nX,1] + ";"
Next _nX

// Criacao do arquivo na maquina do usuario
PD2->(DbSeek(xFilial() + M->PDI_PROF))

AcaLog(_cTitulo + ";")
AcaLog(STR0016 + PD3->PD3_TURMA + STR0026 + AllTrim(PD3->PD3_NOME) + STR0027 + STR0021 + M->PDI_PROF+ "-" + AllTrim(PD2->PD2_NOME)) //"Curso: "###" - "###";"###"Instrutor(a): "

AcaLog(STR0017 + cMarca + STR0027 + STR0028 + aDatas[1][1] + "-" + Trans(aDatas[1][2], STR0029) + STR0030 +; //"Marca: "###";"###"Periodo: "###"@R 99:99"###" até "
												aDatas[Len(aDatas)][1] + "-" + Trans(aDatas[Len(aDatas)][3], "@R 99:99") + ";" +;
												AllTrim(PD3->PD3_NOME) + ";" + STR0022+; //"CARGA HORÁRIA: "
		AllTrim(Str(M->PDI_QTDHOR)) + "hs")

// Cabecalho
AcaLog("Empresa;Participante;CPF;Data(s): " + _cDatas)

// Posiciona
SA1->(DbSetOrder(1))
PDL->(DbSetOrder(1))
PD7->(dbSetOrder(1))

PD7->(dbSeek( xFilial( STR0031 ) + PD3->PD3_TURMA )) //"PD7"
While PD7->(!EOF()) .And. PD7->PD7_TURMA == PD3->PD3_TURMA .AND. PD7->PD7_FILIAL == PD3->PD3_FILIAL
   If ( PD7->PD7_CONFIR == "1" .OR. PD7->PD7_CONFIR == "5" .OR. PD7->PD7_CONFIR == "6" )
      If ! Empty(PD7->PD7_PROSPE)
      	  SUS->( dbseek(xFilial("SUS")+ PD7->PD7_PROSPE + PD7->PD7_LOJPRO))
      	  cNome := AllTrim(SUS->US_NOME) + " - " + Trans(SUS->US_CGC, If(Len(AllTrim(SUS->US_CGC)) = 14, "@R 99.999.999/9999-99", "@R 999.999.999-99"))
      Else
      	  SA1->( dbseek(xFilial("SA1")+ PD7->PD7_CLIENT + PD7->PD7_LOJA))
      	  cNome := AllTrim(SA1->A1_NOME) + " - " + Trans(SA1->A1_CGC, If(Len(AllTrim(SA1->A1_CGC)) = 14, "@R 99.999.999/9999-99", "@R 999.999.999-99"))
      EndIf

      PDL->(dbseek(xFilial("PDL") + PD7->PD7_ALUNO ))
      AcaLog(	Alltrim(cNome)  + ";" + Alltrim(PDL->PDL_NOME) + " - Cod.: " + ;
				PD7->PD7_ALUNO+ "; '" + Alltrim(PDL->PDL_CPF) + "'")

   EndIf

   PD7->(dbSkip())
EndDo

Return()

Static Function AcaLog(cConteudo)

FWrite(nHdl, cConteudo + Chr(13) + Chr(10))

Return

Static Function TCTTRCAB()
   //Caixa
           //Topo  LE  Fundo  LD
	oPrn:Box(0050,0050,0450,  3335)  
	
	        //Topo  LE  Fundo  LD
	oPrn:Box(0500,0050, 2350,  3335) 
	
    oPrn:SayBitmap( 060,060, 'totvs.jpg',360, 360, , .T. )    
Return
