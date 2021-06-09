#INCLUDE "TOTVS.CH"
STATIC aPDJ := {}	//-- Regras para calculo do prêmio

STATIC cCodInstr := ""
STATIC cNomInstr := ""
STATIC cMat		 := ""
STATIC xFilOrig	 := ""
STATIC cCarg	 := ""
STATIC DtIni	 := STOD("")
STATIC DtFim	 := STOD("")
STATIC cPer		 := ""
STATIC cCatg	 := ""
STATIC cPD3_SELO := ""
STATIC cLin		 := ""
STATIC cTurma	 := ""
STATIC cCodCur	 := ""
STATIC cTrein	 := ""
STATIC nChHor	 := 0
STATIC nTotAlu	 := 0
STATIC nAluPgto	 := 0
STATIC nPResp	 := 0
STATIC nIst		 := 0
STATIC nMater	 := 0
STATIC nMedG	 := 0
STATIC cHoRf	 := ""
STATIC nVlHor	 := 0
STATIC nTotPrf	 := 0
STATIC nAnalis	 := 0
STATIC nLider	 := 0
STATIC nCoord	 := 0

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Relatório do calculo de prêmio

@author Wagner Mobile Costa
@version P12
@since 21/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTR030()

Local oReport

Private cPerg := PADR("TCTTR030",10)

   oReport := ReportDef()
   oReport:PrintDialog()

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem das definições do relatório

@author Wagner Mobile Costa
@version P12
@since 21/04/2015
/*/
//-----------------------------------------------------------------------------
Static Function ReportDef()

Local oReport
Local cTitulo := "Calculo de pagamento de Professores, Analista e Lider"
Local oEmpFil := nil

   pergunte(cPerg,.f.)

   oReport:= TReport():New(cPerg,cTitulo,cPerg, {|oReport| ReportPrint(oReport)},cTitulo)
   oReport:SetPortrait(.F.)
   oReport:SetLandscape(.T.)

   oEmpFil := TRSection():New(oReport,cTitulo,{"TRB"},{"Origem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)	// "INSTRUTOR + NOME INSTRUTOR + FILIAL DO PRF. + MATRICULA + CARGO + TURMA + DT INICIO + DT FIM + COD CURSO + NOME CURSO + PERIODO + CATEGORIA + LINHA + CH + TOT ALUNOS + ALUNOS PGTO + PESQ RESP"
   oEmpFil:SetTotalInLine(.F.)

   TRCell():New(oEmpFil,"cCodInstr" ,/*Tabela*/,"Código",/*Picture*/,TamSx3("PD3_PROF")[1],/*lPixel*/,{|| cCodInstr  })
   TRCell():New(oEmpFil,"cNomInstr" ,/*Tabela*/,"Instrutor",/*Picture*/,TamSx3("PD2_NOME")[1],/*lPixel*/,{|| cNomInstr  })
   TRCell():New(oEmpFil,"cMat" ,/*Tabela*/,"Matricula",/*Picture*/,TamSx3("PD2_CRACHA")[1],/*lPixel*/,{|| cMat  })
   TRCell():New(oEmpFil,"xFilOrig" ,/*Tabela*/,"Filial Origem",/*Picture*/,TamSx3("PD2_FILORI")[1],/*lPixel*/,{|| xFilOrig  })
   TRCell():New(oEmpFil,"cCarg" ,/*Tabela*/,"Cargo",/*Picture*/,15,/*lPixel*/,{|| cCarg })
   TRCell():New(oEmpFil,"DtIni" ,/*Tabela*/,"Data Inicio",/*Picture*/,8,/*lPixel*/,{|| DtIni })
   TRCell():New(oEmpFil,"DtFim" ,/*Tabela*/,"Data Fim",/*Picture*/,8,/*lPixel*/,{|| DtFim  })
   TRCell():New(oEmpFil,"cPer" ,/*Tabela*/,"Periodo",/*Picture*/,TamSx3("PD3_PERIOD")[1],/*lPixel*/,{|| cPer })
   TRCell():New(oEmpFil,"cFilTRM" ,/*Tabela*/,"Filial TRM",/*Picture*/,30,/*lPixel*/,{|| cFilTRM  })
   TRCell():New(oEmpFil,"cCatg" ,/*Tabela*/,"Categoria",/*Picture*/,TamSx3("PD3_CATEG")[1],/*lPixel*/,{|| cCatg })
   TRCell():New(oEmpFil,"cPD3_SELO" ,/*Tabela*/,"Selo Verde",/*Picture*/,TamSx3("PD3_SELO")[1],/*lPixel*/,{|| cPD3_SELO })
   TRCell():New(oEmpFil,"cLin" ,/*Tabela*/,"Linha",/*Picture*/,25,/*lPixel*/,{|| cLin  })
   TRCell():New(oEmpFil,"cTurma" ,/*Tabela*/,"Turma",/*Picture*/,TamSx3("PD3_TURMA")[1],/*lPixel*/,{|| cTurma  })
   TRCell():New(oEmpFil,"cCodCur" ,/*Tabela*/,"Cod. Curso",/*Picture*/,TamSx3("PD3_CURSO")[1],/*lPixel*/,{|| cCodCur  })
   TRCell():New(oEmpFil,"cTrein" ,/*Tabela*/,"Treinamento",/*Picture*/,TamSx3("PD3_NOME")[1],/*lPixel*/,{|| cTrein  })
   TRCell():New(oEmpFil,"nChHor" ,/*Tabela*/,"Carga Horaria",/*Picture*/,TamSx3("PD3_QTDHOR")[1],/*lPixel*/,{|| nChHor  })
   TRCell():New(oEmpFil,"nTotAlu" ,/*Tabela*/,"Total Alunos",/*Picture*/,6,/*lPixel*/,{|| nTotAlu  })
   TRCell():New(oEmpFil,"nAluPgto" ,/*Tabela*/,"Alunos Pagantes",/*Picture*/,6,/*lPixel*/,{|| nAluPgto  })
   TRCell():New(oEmpFil,"nPResp" ,/*Tabela*/,"Pesq. Respondidas",/*Picture*/,6,/*lPixel*/,{|| nPResp  })
   TRCell():New(oEmpFil,"nIst" ,/*Tabela*/,"Instrutor",/*Picture*/,4,/*lPixel*/,{|| nIst  })
   TRCell():New(oEmpFil,"nMater" ,/*Tabela*/,"Material",/*Picture*/,4,/*lPixel*/,{|| nMater  })
   TRCell():New(oEmpFil,"nMedG" ,/*Tabela*/,"Media Geral" ,/*Picture*/,4,/*lPixel*/,{|| nMedG  })
   TRCell():New(oEmpFil,"cHoRf" ,/*Tabela*/,"Hora Referência" ,/*Picture*/,4,/*lPixel*/,{|| cHoRf  })
   TRCell():New(oEmpFil,"nVlHor" ,/*Tabela*/,"Valor Hora" ,/*Picture*/,4,/*lPixel*/,{|| nVlHor  })
   TRCell():New(oEmpFil,"nTotPrf" ,/*Tabela*/,"Total Instrutor" ,/*Picture*/,4,/*lPixel*/,{|| nTotPrf  })
   TRCell():New(oEmpFil,"nAnalis" ,/*Tabela*/,"Total Analista"+CRLF+"Parceiro" ,/*Picture*/,4,/*lPixel*/,{|| nAnalis  })
   TRCell():New(oEmpFil,"nLider" ,/*Tabela*/,"Total Lider" ,/*Picture*/,4,/*lPixel*/,{|| nLider  })
   TRCell():New(oEmpFil,"nCoord" ,/*Tabela*/,"Total Coordenador",/*Picture*/,4,/*lPixel*/,{|| nCoord  })

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do Cabecalho no top da pagina                                ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   oReport:Section(1):SetHeaderPage()

Return(oReport)

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Geração do relatório

@author Wagner Mobile Costa
@version P12
@since 21/04/2015
/*/
//-----------------------------------------------------------------------------
Static Function ReportPrint(oReport)

Local cWhere := ""
Local aTipo  := RetSx3Box( Posicione("SX3", 2, "PD5_FINALI", "X3CBox()" ),,, 1 )
Local aCargo := RetSx3Box( Posicione("SX3", 2, "PD2_CARGO"  , "X3CBox()" ),,, 1 )
Local aPerio := RetSx3Box( Posicione("SX3", 2, "PD3_PERIOD", "X3CBox()" ),,, 1 )
Local aCateg := RetSx3Box( Posicione("SX3", 2, "PD3_CATEG", "X3CBox()" ),,, 1 )
Local aLinha := RetSx3Box( Posicione("SX3", 2, "PDM_TPOSIS", "X3CBox()" ),,, 1 )
Local aArea	 := SM0->(GETAREA())

   cCodInstr := ""
   cNomInstr := ""
   cPD3_SELO := ""
   cMat		:= ""
   xFilOrig	:= ""
   cCarg	:= ""
   DtIni	:= STOD("")
   DtFim	:= STOD("")
   cPer		:= ""
   cCatg	:= ""
   cLin		:= ""
   cTurma	:= ""
   cCodCur	:= ""
   cTrein	:= ""
   nChHor	:= 0
   nTotAlu	:= 0
   nAluPgto	:= 0
   nPResp	:= 0
   nIst		:= 0
   nMater	:= 0
   nInfr	:= 0
   nRece	:= 0
   nCome	:= 0
   nCoff	:= 0
   nDive	:= 0
   nMedG	:= 0
   cHoRf	:= ""
   nVlHor	:= 0
   nTotPrf	:= 0
   nAnalis	:= 0
   nLider	:= 0
   nCoord	:= 0

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Edição de parametros para pegar a regra do primeiro dia do mes e o ultimo dia do mes³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   MV_PAR01 := substr(MV_PAR01,3,4)+substr(MV_PAR01,1,2)+'01'
   MV_PAR02 := substr(MV_PAR02,3,4)+substr(MV_PAR02,1,2)+'31'

   If Select("QRY") > 0
      QRY->(DbCloseArea())
   EndIf

   MakeSqlExpr(cPerg)

   If !Empty(MV_PAR07)		//-- Filial
      cWhere += MV_PAR07
   EndIf

   If !Empty(MV_PAR03)		//-- Turma de
      If ! Empty(cWhere)
          cWhere += " AND "
      EndIf
      cWhere += "PDF.PDF_TURMA >= '" + MV_PAR03 + "'"
   EndIf

   If !Empty(MV_PAR04)		//-- Turma ate
      If ! Empty(cWhere)
          cWhere += " AND "
      EndIf
      cWhere += "PDF.PDF_TURMA <= '" + MV_PAR04 + "'"
   EndIf

   If !Empty(MV_PAR01)		//-- Data Encerramento Curso de
      If ! Empty(cWhere)
          cWhere += " AND "
      EndIf
      cWhere += "PDF.PDF_DTFIM >= '" + MV_PAR01 + "'"
   EndIf

   If !Empty(MV_PAR02)		//-- Data Encerramento Curso ate
      If ! Empty(cWhere)
          cWhere += " AND "
      EndIf
      cWhere += "PDF.PDF_DTFIM <= '" + MV_PAR02 + "'"
   EndIf

   If !Empty(MV_PAR05)		//-- Professor de
      If ! Empty(cWhere)
          cWhere += " AND "
      EndIf
      cWhere += "PDF.PDF_PROF >= '" + MV_PAR05 + "'"
   EndIf

   If !Empty(MV_PAR06)		//-- Professor ate
      If ! Empty(cWhere)
          cWhere += " AND "
      EndIf
      cWhere += "PDF.PDF_PROF <= '" + MV_PAR06 + "'"
   EndIf

   If ! Empty(cWhere)
      cWhere += " AND "
   EndIf
   cWhere += "PD3.PD3_CATEG <> '9' AND PD3.PD3_STATUS = 'S' AND PD3.D_E_L_E_T_ = ' '"
   cWhere := "%" + cWhere + "%"
   
   oReport:Section(1):BeginQuery()
   BeginSql Alias "QRY"
      COLUMN PD3_DTINI AS DATE
      COLUMN PD3_DTFIM AS DATE

      SELECT PD3.PD3_FILIAL, PD3.PD3_TURMA, PD3.PDF_PERIO, PD3.PD3_PROF, PD2.PD2_NOME, PD2.PD2_CRACHA, PD2.PD2_FILORI,
             PD2.PD2_CARGO, PD2.PD2_VLRHOR, PD3.PD3_DTINI, PD3.PD3_DTFIM, PD3.PD3_PERIOD, PD3.PD3_CATEG, PD3.PD3_SELO,
   	         PDM.PDM_TPOSIS, PD3.PD3_CURSO, PD3.PD3_NOME, PD3.PD3_QTDHOR, PD3.QTDALUNO, PD3.QTDALUNOPAGANTE, PD3.PESQRESP,
             PD2.PD2_VLRHOR, PD4.NOTAINSTRUTOR, PD4.NOTAMATERIAL, (PD4.NOTAINSTRUTOR+PD4.NOTAMATERIAL)/2 AS MEDIAGERAL
        FROM (SELECT PD3.PD3_FILIAL, PD3.PD3_TURMA, PDF.PDF_PERIO, MIN(PD3.PD3_CURSO) AS PD3_CURSO, MIN(PD3.PD3_NOME) AS PD3_NOME,
                     MIN(PDF.PDF_PROF) AS PD3_PROF, MIN(PDF.PDF_DTINI) AS PD3_DTINI, MIN(PDF.PDF_DTFIM) AS PD3_DTFIM,
		             MIN(PD3.PD3_PERIOD) AS PD3_PERIOD, MIN(PD3.PD3_CATEG) AS PD3_CATEG, MIN(PD3.PD3_SELO) AS PD3_SELO,
		             MIN(PDF.PDF_QTDHOR) AS PD3_QTDHOR,
                     COUNT(CASE WHEN PD7.PD7_CONFIR IN (%exp:'1'%, %exp:'5'%, %exp:'6'%) THEN 1 ELSE NULL END) AS QTDALUNO,
                     COUNT(CASE WHEN PD7.PD7_CONFIR IN (%exp:'1'%, %exp:'6'%) THEN 1 ELSE NULL END) AS QTDALUNOPAGANTE,
                     COUNT(CASE WHEN PD4_FILIAL IS NULL THEN NULL ELSE 1 END) AS PESQRESP
                FROM %table:PD3% PD3
                JOIN %table:PDF% PDF ON PDF.PDF_FILIAL = PD3.PD3_FILIAL AND PDF.PDF_TURMA = PD3.PD3_TURMA AND PDF.%notDel%
                JOIN (SELECT PD7_FILIAL, PD7_TURMA, PD7_ALUNO, PDF_PERIO, PD7_CONFIR
			            FROM %table:PD7% PD7
                        JOIN %table:PD3% PD3 ON PD3.PD3_FILIAL = PD7.PD7_FILIAL AND PD3.PD3_TURMA = PD7.PD7_TURMA AND PD3.%notDel%
                        JOIN %table:PDF% PDF ON PDF.PDF_FILIAL = PD7.PD7_FILIAL AND PDF.PDF_TURMA = PD7.PD7_TURMA AND PDF.%notDel%
		               WHERE %Exp:StrTran(StrTran(cWhere, "PD3_FILIAL", "PD7_FILIAL"), "PD3.D_E_L_E_T_ = ' '", "PD7.D_E_L_E_T_ = ' '")%
                    GROUP BY PD7_FILIAL, PD7_TURMA, PD7_ALUNO, PDF_PERIO, PD7_CONFIR) PD7 ON PD7.PD7_FILIAL = PD3.PD3_FILIAL AND PD7.PD7_TURMA = PD3.PD3_TURMA
                 AND PD7.PDF_PERIO = PDF.PDF_PERIO          
		   LEFT JOIN (SELECT PD4_FILIAL, PD4_TURMA, PD4_PERIO, PD4_ALUNO
				        FROM %table:PD4% PD4
                        JOIN %table:PD3% PD3 ON PD3.PD3_FILIAL = PD4.PD4_FILIAL AND PD3.PD3_TURMA = PD4.PD4_TURMA AND PD3.%notDel%
                        JOIN %table:PDF% PDF ON PDF.PDF_FILIAL = PD4.PD4_FILIAL AND PDF.PDF_TURMA = PD4.PD4_TURMA
						 AND PDF.PDF_PERIO = PD4.PD4_PERIO AND PDF.%notDel%
					   WHERE %Exp:StrTran(StrTran(cWhere, "PD3_FILIAL", "PD4_FILIAL"), "PD3.D_E_L_E_T_ = ' '", "PD4.D_E_L_E_T_ = ' '")%
                    GROUP BY PD4_FILIAL, PD4_TURMA, PD4_PERIO, PD4_ALUNO) PD4 ON PD4.PD4_FILIAL = PD3.PD3_FILIAL 
				 AND PD4.PD4_TURMA = PD3.PD3_TURMA AND PD4.PD4_PERIO = PDF.PDF_PERIO AND PD4.PD4_ALUNO = PD7.PD7_ALUNO
               WHERE %Exp:cWhere%
               GROUP BY PD3.PD3_FILIAL, PD3.PD3_TURMA, PDF.PDF_PERIO) PD3
        LEFT JOIN (SELECT PD4.PD4_FILIAL, PD4.PD4_TURMA, PD4.PD4_PERIO,
                          SUM(CASE WHEN PD4.PD4_FINALI = %Exp:'1'% THEN PDG.PDG_NOTAPO ELSE NULL END) /
                          COUNT(CASE WHEN PD4.PD4_FINALI = %Exp:'1'% THEN 1 ELSE NULL END) AS NOTAINSTRUTOR,
                          SUM(CASE WHEN PD4.PD4_FINALI = %Exp:'2'% THEN PDG.PDG_NOTAPO ELSE NULL END) /
                          COUNT(CASE WHEN PD4.PD4_FINALI = %Exp:'2'% THEN 1 ELSE NULL END) AS NOTAMATERIAL
                     FROM %table:PD3% PD3
	                 JOIN %table:PD4% PD4 ON PD4.PD4_FILIAL = PD3.PD3_FILIAL AND PD4.PD4_TURMA = PD3.PD3_TURMA AND PD4.PD4_PESQ = PD3.PD3_PESQ 
	                  AND PD4.%notDel% 
                     JOIN %table:PDF% PDF ON PDF.PDF_FILIAL = PD3.PD3_FILIAL AND PDF.PDF_TURMA = PD3.PD3_TURMA
 					  AND PDF.PDF_PERIO = PD4.PD4_PERIO AND PDF.%notDel%
	                 JOIN %table:PD5% PD5 ON PD5.PD5_FILIAL = %exp:xFilial("PD5")% AND PD5.PD5_PESQ = PD4.PD4_PESQ AND PD5.PD5_ITEM = PD4.PD4_ITEM 
	                  AND PD5.%notDel%
	                 JOIN %table:PDG% PDG ON PDG.PDG_FILIAL = %exp:xFilial("PDG")% AND PDG.PDG_PONTUA = PD4.PD4_PONTUA AND PDG.PDG_EQUIV = PD4.PD4_EQUIV 
	                  AND PDG.%notDel%
                    WHERE %Exp:cWhere%
                    GROUP BY PD4.PD4_FILIAL, PD4.PD4_TURMA, PD4.PD4_PERIO) PD4 ON PD4.PD4_FILIAL = PD3.PD3_FILIAL 
              AND PD4.PD4_TURMA = PD3.PD3_TURMA AND PD4.PD4_PERIO = PD3.PDF_PERIO
        JOIN %table:PD2% PD2 ON PD2.PD2_FILIAL = %exp:xFilial("PD2")% AND PD2.PD2_PROF = PD3.PD3_PROF AND PD2.%notDel%
        JOIN %table:PDM% PDM ON PDM.PDM_FILIAL = %exp:xFilial("PDM")% AND PDM.PDM_CURSO = PD3.PD3_CURSO AND PDM.%notDel%
    ORDER BY PD3.PD3_PROF, PD3.PD3_FILIAL, PD3.PD3_TURMA, PD3.PDF_PERIO
   EndSql
   oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

   QRY->(dbGoTop())
   oReport:SetMeter(RecCount())
   oReport:Section(1):Init()

   While ! oReport:Cancel() .And. QRY->(!Eof())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³processo de alimentar as variaveis para adicionar no relatorio³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCodInstr	:= QRY->PD3_PROF
		cNomInstr	:= QRY->PD2_NOME
		cMat 		:= QRY->PD2_CRACHA
		xFilOrig	:= QRY->PD2_FILORI

		If SM0->(DBSEEK( cEmpAnt + xFilOrig ))
			xFilOrig := SM0->M0_CIDCOB
		EndIf
		SM0->(RestArea(aArea))
		
		cCarg 		:= " "
		if VAL(QRY->PD2_CARGO) > 0
			cCarg := aCargo[VAL(QRY->PD2_CARGO)][3]
		endif
		DtIni := QRY->PD3_DTINI
		DtFim := QRY->PD3_DTFIM
		nPer  := Ascan(aPerio,{ |x| x[2] == QRY->PD3_PERIOD })
		cPer  := " "
		if nPer > 0
			cPer := aPerio[nPer][3] // Periodo
		endif

		SM0->(DBSEEK( cEmpAnt + QRY->PD3_FILIAL ))
		cFilTRM := SM0->M0_CIDCOB
		SM0->(RestArea(aArea))
		
		cCatg := " "
		if val(QRY->PD3_CATEG) > 0
			cCatg := aCateg[val(QRY->PD3_CATEG)][3]
		endif
		nLi	 := Ascan(aLinha,{ |x| x[2] == QRY->PDM_TPOSIS })
		cLin := " "
		if nLi > 0
			cLin := aLinha[nLi][3] // Linha de Produto
		endif
		cTurma	:= QRY->(PD3_TURMA + "/" + PDF_PERIO)
		cPD3_SELO := If(QRY->PD3_SELO == "1", "Sim", "Nao") 
		cCodCur	:= QRY->PD3_CURSO
		cTrein	:= QRY->PD3_NOME
		nChHor	:= QRY->PD3_QTDHOR
		nTotAlu	:= QRY->QTDALUNO
		nAluPgto:= QRY->QTDALUNOPAGANTE
		nPResp	:= QRY->PESQRESP
		nIst	:= QRY->NOTAINSTRUTOR
		nMater 	:= QRY->NOTAMATERIAL
		nMedG 	:= ARRED(QRY->MEDIAGERAL)
		aRet 	:= CalPrCTT(nMedG, nAluPgto, QRY->PD3_CATEG, QRY->PD3_SELO)
		cHoRf 	:= aRet[2]
		nVlHor 	:= aRet[1]
		nTotPrf := nVlHor*nChHor
		nAnalis := IIF(QRY->PD3_PERIOD $'N,S',nChHor*QRY->PD2_VLRHOR,0)
		nLider 	:= cHoRf*aRet[3]*nChHor
		nCoord 	:= cHoRf*aRet[4]*nChHor
	
		oReport:Section(1):Cell("cCodInstr"):Show()//HIDE()"
		oReport:Section(1):Cell("cNomInstr"):Show()//HIDE()"
		oReport:Section(1):Cell("cMat"):Show()//HIDE()"
		oReport:Section(1):Cell("xFilOrig"):Show()//HIDE()"
		oReport:Section(1):Cell("cCarg"):Show()//HIDE()"
		oReport:Section(1):Cell("DtIni"):Show()//HIDE()"
		oReport:Section(1):Cell("DtFim"):Show()//HIDE()"
		oReport:Section(1):Cell("cPer"):Show()//HIDE()"
		oReport:Section(1):Cell("cCatg"):Show()//HIDE()"
		oReport:Section(1):Cell("cPD3_SELO"):Show()//HIDE()"
		oReport:Section(1):Cell("cLin"):Show()//HIDE()"
		oReport:Section(1):Cell("cTurma"):Show()//HIDE()"
		oReport:Section(1):Cell("cCodCur"):Show()//HIDE()"
		oReport:Section(1):Cell("cTrein"):Show()//HIDE()"
		oReport:Section(1):Cell("nChHor"):Show()//HIDE()"
		oReport:Section(1):Cell("nTotAlu"):Show()//HIDE()"
		oReport:Section(1):Cell("nAluPgto"):Show()//HIDE()"
		oReport:Section(1):Cell("nPResp"):Show()//HIDE()"
		oReport:Section(1):Cell("nIst"):Show()//HIDE()"
		oReport:Section(1):Cell("nMater"):Show()//HIDE()"
		oReport:Section(1):Cell("nMedG"):Show()//HIDE()"
		oReport:Section(1):Cell("cHoRf"):Show()//HIDE()"
		oReport:Section(1):Cell("nVlHor"):Show()//HIDE()"
		oReport:Section(1):Cell("nTotPrf"):Show()//HIDE()"
		oReport:Section(1):Cell("nAnalis"):Show()//HIDE()"
		oReport:Section(1):Cell("nLider"):Show()//HIDE()"
		oReport:Section(1):Cell("nCoord"):Show()//HIDE()"

		oReport:Section(1):PrintLine()//imprime a linha

		oReport:IncMeter()

		QRY->(dbskip())
	End

	oReport:Section(1):SetTotalText("Total")
	oReport:Section(1):Finish()
	oReport:Section(1):SetPageBreak()
	QRY->(dbCloseArea())

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Função para retorno da faixa de calculo do prêmio de acordo com media e pagantes

@author Wagner Mobile Costa
@version P12
@param nMedG = Media Geral da pesquisa de satisfação do aluno
       nAluPgto = Número de alunos pagantes
       cPD3_CATEG = Categoria da Turma
       cPD3_SELO = Selo Verde (Indica o calculo do premio) 1=Sim ou 2=Não
@since 22/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function CalPrCTT(nMedG, nAluPgto, cPD3_CATEG, cPD3_SELO )

Local aDadosPesq := {0,0,0,0,0,0,0,0}, nPDJ := 0

	If Len(aPDJ) == 0
		DbSelectArea("PDJ")
		DbSetOrder(1)
		DbGoTop()

		While ! PDJ->(EOF())
			If PDJ->PDJ_MSBLQL == "2"
				Aadd(aPDJ, { 	PDJ->PDJ_COEINI / 10, PDJ->PDJ_COEFIM / 10, PDJ->PDJ_PARDE, PDJ->PDJ_PARATE, PDJ->PDJ_VLRHOR, PDJ->PDJ_HRREF,;
								PDJ->PDJ_REFLID, PDJ->PDJ_REFCOD, PDJ->PDJ_VLRFOR })
			EndIf
			PDJ->(DbSkip())
		Enddo
	EndIf

	For nPDJ := 1 To Len(aPDJ)
		If nMedG >= aPDJ[nPDJ][1] .And. nMedG <= aPDJ[nPDJ][2] .And. nAluPgto >= aPDJ[nPDJ][3] .And. nAluPgto <= aPDJ[nPDJ][4]
			aDadosPesq := {}
			
			Aadd(aDadosPesq, aPDJ[nPDJ][5] + If(cPD3_CATEG == "7", aPDJ[nPDJ][9], 0) )	// Formação TOTVS tem acrescimo no valor da hora referencia
			Aadd(aDadosPesq, aPDJ[nPDJ][6])
			Aadd(aDadosPesq, aPDJ[nPDJ][7])
			Aadd(aDadosPesq, aPDJ[nPDJ][8])
				
			Exit
		EndIf 
	Next

Return aDadosPesq

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regra de arredondamento da nota para calculo do prêmio

@author Wagner Mobile Costa
@version P12
@since 22/04/2015
/*/
//-----------------------------------------------------------------------------
Static Function ARRED(nNota)

Local cNota := cvaltochar(round(nNota,2))
Local cFran := ''
Local cRet  := ''
Local nRet  := nNota

if at('.',cNota) > 0
   cFran:= substr(cNota,at('.',cNota)+1)
   cFran := iif(len(alltrim(cFran))==1,alltrim(cFran)+'0',alltrim(cFran))
   cRet := substr(cNota,1,at('.',cNota)-1)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Regra de arredondamento³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   if val(cFran)<= 00
      nRet :=val(cRet+'.00')
   elseif val(cFran)>= 01 .and.  val(cFran)<= 05
      nRet :=val(cRet+'.05')
   elseif val(cFran)>= 06 .and.  val(cFran)<= 10
      nRet :=val(cRet+'.10')
   elseif val(cFran)>= 11 .and.  val(cFran)<= 15
      nRet :=val(cRet+'.15')
   elseif val(cFran)>= 16 .and.  val(cFran)<= 20
      nRet :=val(cRet+'.20')
   elseif val(cFran)>= 21 .and.  val(cFran)<= 25
      nRet :=val(cRet+'.25')
   elseif val(cFran)>= 26 .and.  val(cFran)<= 30
      nRet :=val(cRet+'.30')
   elseif val(cFran)>= 31 .and.  val(cFran)<= 35
      nRet :=val(cRet+'.35')
   elseif val(cFran)>= 36 .and.  val(cFran)<= 40
      nRet :=val(cRet+'.40')
   elseif val(cFran)>= 41 .and.  val(cFran)<= 45
      nRet :=val(cRet+'.45')
   elseif val(cFran)>= 46 .and.  val(cFran)<= 50
      nRet :=val(cRet+'.50')
   elseif val(cFran)>= 51 .and.  val(cFran)<= 55
      nRet :=val(cRet+'.55')
   elseif val(cFran)>= 56 .and.  val(cFran)<= 60
      nRet :=val(cRet+'.60')
   elseif val(cFran)>= 61 .and.  val(cFran)<= 65
      nRet :=val(cRet+'.65')
   elseif val(cFran)>= 66 .and.  val(cFran)<= 70
      nRet :=val(cRet+'.70')
   elseif val(cFran)>= 71 .and.  val(cFran)<= 75
      nRet :=val(cRet+'.75')
   elseif val(cFran)>= 76 .and.  val(cFran)<= 80
      nRet :=val(cRet+'.80')
   elseif val(cFran)>= 81 .and.  val(cFran)<= 85
      nRet :=val(cRet+'.85')
   elseif val(cFran)>= 86 .and.  val(cFran)<= 90
      nRet :=val(cRet+'.90')
   elseif val(cFran)>= 91 .and.  val(cFran)<= 95
      nRet :=val(cRet+'.95')
   elseif val(cFran)>= 96
      nRet :=val(soma1(STRZERO(VAL(cRet),2)))
   endif
endif

Return(nRet)

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validação da digitação da competencia inicial e final do relatório

@author Wagner Mobile Costa
@version P12
@since 22/04/2015
/*/
//-----------------------------------------------------------------------------
User Function XDT01(cPar)

Local lRet := .t.
Local cMes := substr(cPar,1,2)

if strzero(val(cMes),2) > '12'
   lRet := .f.
   alert('informe o Mes correto parametro de MES/ANO')
endif

Return(lRet)