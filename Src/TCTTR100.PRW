#INCLUDE "TCTTR100.ch"
#INCLUDE "TOTVS.CH"

Static cWhere 	:= ""
Static cWhere2  := ""
Static cTrein	:= ""
Static DtIni	:= STOD("")
Static DtFim	:= STOD("")
Static cTurma	:= ""
Static cCodInstr:= ""
Static cNomInstr:= ""
Static cCodCli  := ""
Static cNomCli	:= ""
Static cCnpj    := ""
Static cLin		:= ""
Static cMes		:= ""
Static cLocal	:= ""
Static cAluno	:= ""
Static cEmail	:= ""
Static cTelAluno := ""
Static cTelEmpresa := ""
Static cCH		:= ""
Static cCateg	:= ""
Static cPeriodo	:= ""
Static aLinha 	:= RetSx3Box( Posicione("SX3", 2, "PDM_TPOSIS" , "X3CBox()" ),,, 1 )
Static aPerio 	:= RetSx3Box( Posicione("SX3", 2, "PD3_PERIOD", "X3CBox()" ),,, 1 )
Static aCateg 	:= RetSx3Box( Posicione("SX3", 2, "PD3_CATEG", "X3CBox()" ),,, 1 )
Static aTipo 	:= RetSx3Box( Posicione("SX3", 2, "PD5_FINALI", "X3CBox()" ),,, 1 )

Static aColunas := {} 	// colunas dinamicas do relatorio por causa das perguntas

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Relat�rio com as respostas da pesquisa de satisfa��o de um periodo

@author Wagner Mobile Costa

@version P12
@since 29/07/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTR100()

Private cPerg    := "TCTTR100"
Private oReport	 := Nil
//��������������������������������������������������������������Ŀ
//Parametros da fun��o:
//PutSx1(	cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,
//          nTamanho,nDecimal,nPresel,cGSC,cValid, cF3, cGrpSxg,
//          cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,
//          cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,
//          cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,
//          aHelpEng,aHelpSpa,cHelp)
//� Definicao da Pergunta                                        �
//� MV_PAR01 - Mes e Ano Encerramento do Curso de                
//� MV_PAR02 - Mes e Ano Encerramento do Curso Ate               �
//� MV_PAR03 - Turma de                             			 �
//� MV_PAR04 - Turma Ate                          			 	 �
//� MV_PAR05 - Professor de                                      �
//� MV_PAR06 - Professor Ate                                     �
//� MV_PAR07 - Filiais                                           �
//� MV_PAR08 - Pesquisa                                          �
//����������������������������������������������������������������
U_FTTVSX001(	cPerg,"08","Pesquisa","�Pesquisa","Pesquisa","mv_ch8",;
		"C",6,0,1,"G","","","","","mv_par08","","","","","","","","","","","","","",;
		"","","", 	{"Permite atualizar automaticamente as","alteracoes no browse." },{}, {})

oReport := ReportDef()

if oReport == Nil
	Aviso(STR0016,STR0017,{"OK"}) //"Relatorio"###"Relatorio Cancelado"
else
	oReport:PrintDialog()
endif

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Fun��o para defini��es do layout do relat�rio

@author Wagner Mobile Costa
@version P12
@since 29/07/2015
/*/
//-----------------------------------------------------------------------------
Static Function ReportDef()

Local cTitulo	:= STR0001 //"Pesquisa de Satisfa��o Analitica"
Local nFor		:= 0

Private oSec1 	:= nil
Private oSec2 	:= nil
Private oSec3 	:= nil

	if pergunte(cPerg,.t.)
		// Transforma parametros Range em expressao SQL
		cWhere := ""
		MakeSqlExpr(cPerg)
	
		// Edi��o de parametros para pegar a regra do primeiro dia do mes e o ultimo dia do mes�
		MV_PAR01 := substr(MV_PAR01,3,4)+substr(MV_PAR01,1,2)+'01'
	 	MV_PAR02 := substr(MV_PAR02,3,4)+substr(MV_PAR02,1,2)+'31'
	
	 	If !Empty(MV_PAR07)		//-- Filial
	 		 //MV_PAR07 := STRTRAN(MV_PAR07,"'","")
	 		cWhere += "PDF.PDF_FILIAL " + MV_PAR07 
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
	    If Empty(cWhere)
	    	cWhere := "1=1"
	    EndIf
	    cWhere := "%" + cWhere + "%"
	    
	    //Clausula Where da Pesquisa
	    If Empty(MV_PAR08)
	       cWhere2 := "1=1"
	    Else
	       cWhere2 := "PD4.PD4_PESQ = '" + MV_PAR08 + "'"
	    Endif
	    cWhere2 := "%" + cWhere2 + "%"
	       
	   
		//������������������������������������������������������������������������Ŀ
		//�Criacao do componente de impressao                                      �
		//�                                                                        �
		//�TReport():New                                                           �
		//�ExpC1 : Nome do relatorio                                               �
		//�ExpC2 : Titulo                                                          �
		//�ExpC3 : Pergunte                                                        �
		//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
		//�ExpC5 : Descricao                                                       �
		//�                                                                        �
		//��������������������������������������������������������������������������
		oReport:= TReport():New("TCTTR100",cTitulo,, {|oReport| ReportPrint(oReport)},cTitulo)
		oReport:SetPortrait(.F.)
		oReport:SetLandscape(.T.)
		
		//������������������������������������������������������������������������Ŀ
		//�Criacao da secao utilizada pelo relatorio                               �
		//�                                                                        �
		//�TRSection():New                                                         �
		//�ExpO1 : Objeto TReport que a secao pertence                             �
		//�ExpC2 : Descricao da se�ao                                              �
		//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
		//�        sera considerada como principal para a se��o.                   �
		//�ExpA4 : Array com as Ordens do relat�rio                                �
		//�ExpL5 : Carrega campos do SX3 como celulas                              �
		//�        Default : False                                                 �
		//�ExpL6 : Carrega ordens do Sindex                                        �
		//�        Default : False                                                 �
		//�                                                                        �
		//��������������������������������������������������������������������������
		// regra para gravar a localiza��o do SIGAMAT.EMP
		oSec1 := TRSection():New(oReport,STR0018,{"TRB"},{STR0003},/*Campos do SX3*/,/*Campos do SIX*/)	// "INSTRUTOR + NOME INSTRUTOR + FILIAL DO PRF. + MATRICULA + CARGO + TURMA + DT INICIO + DT FIM + COD CURSO + NOME CURSO + PERIODO + CATEGORIA + LINHA + CH + TOT ALUNOS + ALUNOS PGTO + PESQ RESP" //"CABE�ALHO"###"Origem Unica" //"Departamentos"
		oSec1:SetTotalInLine(.F.)
		
		//����������������������������������������������������������������������������Ŀ
		//�funcao para trazer em array as regras de colunas conforme o tipo de pesquisa�
		//������������������������������������������������������������������������������
		aColunas := TCTR100Col()
		
		//������������������������������������������������������������������������Ŀ
		//�Criacao da celulas da secao do relatorio                                �
		//�                                                                        �
		//�TRCell():New                                                            �
		//�ExpO1 : Objeto TSection que a secao pertence                            �
		//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
		//�ExpC3 : Nome da tabela de referencia da celula                          �
		//�ExpC4 : Titulo da celula                                                �
		//�        Default : X3Titulo()                                            �
		//�ExpC5 : Picture                                                         �
		//�        Default : X3_PICTURE                                            �
		//�ExpC6 : Tamanho                                                         �
		//�        Default : X3_TAMANHO                                            �
		//�ExpL7 : Informe se o tamanho esta em pixel                              �
		//�        Default : False                                                 �
		//�ExpB8 : Bloco de c�digo para impressao.                                 �
		//�        Default : ExpC2                                                 �
		//�                                                                        �
		//��������������������������������������������������������������������������
		
		For nFor := 1 to len(aColunas[2])
			TRCell():New(oSec1,"",/*Tabela*/,aColunas[2][nFor],/*Picture*/,Len(aColunas[2][nFor]),/*lPixel*/,/*bExec*/)
		Next nFor
		
		//������������������������������������������������������������������������Ŀ
		//� Impressao do Cabecalho no top da pagina                                �
		//��������������������������������������������������������������������������
		oReport:Section(1):SetHeaderPage()

		//-- Se��o com as Respostas
		oSec2 := TRSection():New(oReport,STR0019,{"TRB"},{STR0003},/*Campos do SX3*/,/*Campos do SIX*/) //"Pesquisas Respondidas"
		oSec2:SetTotalInLine(.F.)

		TCTR100Peq(oSec2)

		//��������������������������������������������Ŀ
		//�Loop para adicionar as colunas das perguntas�
		//����������������������������������������������
		cVar := ""
		For nFor := 1 to len(aColunas[1])
			setprvt(&("'"+aColunas[1][nFor][3]+"'"))
			cVar := "TRCell():New(oSec2,'"+aColunas[1][nFor][3]+"' ,,U_TCTR100Tit('" + AllTrim(aColunas[1][nFor][5]) + "'," +;
					         "'" + AllTrim(aColunas[1][nFor][1]) + "'),,"+cvaltochar(aColunas[1][nFor][2])+",,{|| aColunas[1][" + AllTrim(Str(nFor)) + "][4] })"
			&(cVar)
		Next nFor
		
		//������������������������������������������������������������������������Ŀ
		//� Impressao do Cabecalho no top da pagina                                �
		//��������������������������������������������������������������������������
		oReport:Section(2):SetHeaderPage()

		//-- Se��o com as Respostas
		oSec3 := TRSection():New(oReport,STR0020,{"TRB"},{STR0003},/*Campos do SX3*/,/*Campos do SIX*/) //"Pesquisas Pendentes"
		oSec3:SetTotalInLine(.F.)
		
		TCTR100Peq(oSec3)
		
		oReport:Section(2):SetHeaderPage()
	EndIf

Return(oReport)

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Fun��o para leitura e impress�o do relat�rio

@author Wagner Mobile Costa
@version P12
@since 29/07/2015
/*/
//-----------------------------------------------------------------------------

Static Function ReportPrint(oReport)

Local aArea := SM0->(GETAREA())
Local nFor	:= 0

   	// Pesquisas Respondidas
   	BeginSql Alias "QRY"
       COLUMN PD3_DTINI AS DATE
       COLUMN PD3_DTFIM AS DATE
   		
	   SELECT PD3_FILIAL, PD3_TURMA, PDF_PERIO, PD3_NOME, PDF_DTINI AS PD3_DTINI, PDF_DTFIM AS PD3_DTFIM, PD3_PERIOD, PD2_NOME, PDL_NOME, 
	   	 	  PDL_EMAIL, PDL_TEL, PDL_TEL2, PDM_TPOSIS, CASE WHEN US_FILIAL IS NULL THEN A1_NOME ELSE US_NOME END AS A1_NOME, 
	   	 	  CASE WHEN US_FILIAL IS NULL THEN A1_TEL ELSE US_TEL END AS A1_TEL, PD5_FINALI, PD5_TOPICO, PDG_NOTAPO, PD4_ITEM, PD4_RESPOS,   
	  		  PD3_CATEG, PD3_PESQ, PDF_QTDHOR, PD7_ALUNO, PD4.R_E_C_N_O_ AS PD4_RECNO, A1_CGC, A1_COD
	     FROM %table:PDF% PDF 
	  	 JOIN %Table:PD2% PD2 ON PD2.PD2_FILIAL = %exp:xFilial("PD2")% AND PD2.PD2_PROF = PDF.PDF_PROF AND PD2.%NotDel%  
	     JOIN %Table:PD3% PD3 ON PD3.PD3_FILIAL = PDF.PDF_FILIAL AND PD3.PD3_TURMA = PDF.PDF_TURMA 
           AND PD3.PD3_STATUS = %Exp:'S'% AND PD3.%NotDel% 
	  	 JOIN %Table:PDM% PDM ON PDM.PDM_FILIAL = %exp:xFilial("PDM")% AND PDM.PDM_CURSO = PD3.PD3_CURSO AND PDM.%NotDel% 
	  	 JOIN (SELECT PD7_FILIAL, PD7_TURMA, PD7_ALUNO, PD7_CLIENT, PD7_LOJA, PD7_PROSPE, PD7_LOJPRO
	             FROM %table:PD7% PD7
			     JOIN %Table:PDF% PDF ON PDF.PDF_FILIAL = PD7.PD7_FILIAL AND PDF.PDF_TURMA = PDF.PDF_TURMA AND PDF.%NotDel%  
                WHERE %Exp:cWhere%  AND PDF.%notDel% 
               GROUP BY PD7_FILIAL, PD7_TURMA, PD7_ALUNO, PD7_CLIENT, PD7_LOJA, PD7_PROSPE, PD7_LOJPRO) PD7 ON PD7.PD7_FILIAL = PD3.PD3_FILIAL 
          AND PD7.PD7_TURMA = PD3.PD3_TURMA
	  	 LEFT JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = %exp:xFilial("SA1")% AND SA1.A1_COD = PD7.PD7_CLIENT AND SA1.A1_LOJA = PD7.PD7_LOJA 
	  	  AND SA1.%NotDel% 
	  	 LEFT JOIN %Table:SUS% SUS ON SUS.US_FILIAL = %exp:xFilial("SUS")% AND SUS.US_COD = PD7.PD7_PROSPE AND SUS.US_LOJA = PD7.PD7_LOJPRO 
	  	  AND SUS.%NotDel%
	  	 JOIN %Table:PDL% PDL ON PDL.PDL_FILIAL = %exp:xFilial("PDL")% AND PDL.PDL_ALUNO = PD7.PD7_ALUNO AND PDL.%NotDel% 
	  	 JOIN %table:PD4% PD4 ON PD4.PD4_FILIAL = PD3.PD3_FILIAL AND PD4.PD4_TURMA = PD3.PD3_TURMA AND PD4.PD4_PERIO = PDF.PDF_PERIO 
	  	  AND PD4.PD4_ALUNO = PD7.PD7_ALUNO AND PD4.%notDel% 
	  	 JOIN %table:PD5% PD5 ON PD5.PD5_FILIAL = %exp:xFilial("PD5")% AND PD5.PD5_PESQ = PD4.PD4_PESQ AND PD5.PD5_ITEM = PD4.PD4_ITEM 
	  	  AND PD5.%notDel% 
	  	 LEFT JOIN %table:PDG% PDG ON PDG.PDG_FILIAL = %exp:xFilial("PDG")% AND PDG.PDG_PONTUA = PD4.PD4_PONTUA AND PDG.PDG_EQUIV = PD4.PD4_EQUIV 
	  	  AND PDG.%notDel% 
	    WHERE %Exp:cWhere% 
	      AND %Exp:cWhere2% 
          AND PDF.%notDel%  
	    ORDER BY PD3_FILIAL,PD3_NOME,PDF_DTINI,PD3_TURMA,PDF_PERIO,PD7_ALUNO
    EndSql

   	// Pesquisas Pendentes
   	BeginSql Alias "QRYPEN"
       COLUMN PD3_DTINI AS DATE
       COLUMN PD3_DTFIM AS DATE
   		
	   SELECT PD3_FILIAL, PD3_TURMA, PDF_PERIO, PD3_NOME, PDF_DTINI AS PD3_DTINI, PDF_DTFIM AS PD3_DTFIM, PD3_PERIOD, PD2_NOME, PDL_NOME, 
	   	 	  PDL_EMAIL, PDL_TEL, PDL_TEL2, PDM_TPOSIS, CASE WHEN US_FILIAL IS NULL THEN A1_NOME ELSE US_NOME END AS A1_NOME, 
	   	 	  CASE WHEN US_FILIAL IS NULL THEN A1_TEL ELSE US_TEL END AS A1_TEL, PD3_CATEG, PD3_PESQ, PDF_QTDHOR, PD7_ALUNO, A1_CGC, A1_COD
	     FROM %table:PDF% PDF 
	  	 JOIN %Table:PD2% PD2 ON PD2.PD2_FILIAL = %exp:xFilial("PD2")% AND PD2.PD2_PROF = PDF.PDF_PROF AND PD2.%NotDel% 
	     JOIN %Table:PD3% PD3 ON PD3.%NotDel% AND PD3.PD3_FILIAL = PDF.PDF_FILIAL AND PD3.PD3_TURMA = PDF.PDF_TURMA 
          AND PD3.PD3_STATUS = %Exp:'S'%
	  	 JOIN %Table:PDM% PDM ON PDM.%NotDel% AND PDM.PDM_FILIAL = %exp:xFilial("PDM")% AND PDM.PDM_CURSO = PD3.PD3_CURSO
	  	 JOIN (SELECT PD7_FILIAL, PD7_TURMA, PD7_ALUNO, PD7_CLIENT, PD7_LOJA, PD7_PROSPE, PD7_LOJPRO
	             FROM %table:PD7% PD7
			     JOIN %Table:PDF% PDF ON PDF.PDF_FILIAL = PD7.PD7_FILIAL AND PDF.PDF_TURMA = PDF.PDF_TURMA AND PDF.%NotDel% 
                WHERE %Exp:cWhere%      AND PD7.PD7_CONFIR IN ('1','5') AND PDF.%notDel% 
               GROUP BY PD7_FILIAL, PD7_TURMA, PD7_ALUNO, PD7_CLIENT, PD7_LOJA, PD7_PROSPE, PD7_LOJPRO) PD7 ON PD7.PD7_FILIAL = PD3.PD3_FILIAL 
          AND PD7.PD7_TURMA = PD3.PD3_TURMA
	  	 LEFT JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = %exp:xFilial("SA1")% AND SA1.A1_COD = PD7.PD7_CLIENT
	  	  AND SA1.A1_LOJA = PD7.PD7_LOJA AND SA1.%NotDel%
	  	 LEFT JOIN %Table:SUS% SUS ON SUS.US_FILIAL = %exp:xFilial("SUS")% AND SUS.US_COD = PD7.PD7_PROSPE AND SUS.US_LOJA = PD7.PD7_LOJPRO 
	  	  AND SUS.%NotDel%
	  	 JOIN %Table:PDL% PDL ON PDL.PDL_FILIAL = %exp:xFilial("PDL")% AND PDL.PDL_ALUNO = PD7.PD7_ALUNO AND PDL.%NotDel%
	  	 LEFT JOIN %table:PD4% PD4 ON PD4.PD4_FILIAL = PD3.PD3_FILIAL AND PD4.PD4_TURMA = PD3.PD3_TURMA 
	  	  AND PD4.PD4_PERIO = PDF.PDF_PERIO AND PD4.PD4_ALUNO = PD7.PD7_ALUNO AND PD4.%notDel%
	    WHERE %Exp:cWhere% AND PDF.%notDel% AND PD4.PD4_FILIAL IS NULL 
	    ORDER BY PD3_FILIAL,PD3_NOME,PDF_DTINI,PD3_TURMA,PDF_PERIO,PD7_ALUNO
    EndSql

	oReport:SetMeter(QRY->(RecCount()) + QRYPEN->(RecCount()))

	// Impress�o do cabecalho da sessao
	oReport:Section(1):Init()
	oReport:Section(1):PrintLine()//imprime a linha

	//-- Inicializa a sessao de pesquisas respondidas
	oReport:Section(2):Init()

	While ! oReport:Cancel() .And. ! QRY->(Eof())
		TCTR100Prn(oReport:Section(2), "QRY")
		
		M->PD3_FILIAL := QRY->PD3_FILIAL
		M->PD3_TURMA  := QRY->PD3_TURMA
		M->PDF_PERIO  := QRY->PDF_PERIO
		M->PD7_ALUNO  := QRY->PD7_ALUNO
		For nFor := 1 To Len(aColunas[1])
			aColunas[1][nFor][4] := ""
		Next
		While 	! oReport:Cancel() .And.;
				QRY->(PD3_FILIAL + PD3_TURMA + PDF_PERIO + PD7_ALUNO) == M->PD3_FILIAL+M->PD3_TURMA+M->PDF_PERIO+M->PD7_ALUNO .And.;
				! QRY->(Eof())

			// Preenche o valor da resposta
			nFor := ascan(aColunas[1],{|x| x[5]== QRY->PD3_PESQ .And. x[3]== 'C'+ QRY->PD4_ITEM})
			if nFor > 0
				if aColunas[1][nFor][2]==150
					PD4->(DbGoTo(QRY->PD4_RECNO))
				EndIf
				aColunas[1][nFor][4] := iif(aColunas[1][nFor][2]==150,PD4->PD4_RESPOS,QRY->PDG_NOTAPO)
			EndIf
		
			QRY->(dbskip())
			oReport:IncMeter()
		EndDo

		oReport:Section(2):PrintLine()//imprime a linha
	end
	QRY->(dbCloseArea())

	//-- Inicializa a sessao de pesquisas pendentes
	oReport:Section(3):Init()

	While ! oReport:Cancel() .And. ! QRYPEN->(Eof())
		TCTR100Prn(oReport:Section(3), "QRYPEN")
		QRYPEN->(dbskip())
		oReport:IncMeter()

		oReport:Section(3):PrintLine()//imprime a linha
	end
	QRYPEN->(dbCloseArea())
		
	If oReport:Cancel()
		cTrein	:= STR0021 //"CANCELADO PELO OPERADOR"
		DtIni	:= STOD("")
		DtFim	:= STOD("")
		cCodInstr:= ""
		cNomInstr:= ""
		cCodCli := ""
		cNomCli	:= ""
		cCnpj   := ""
		cLin	:= ""
		cMes	:= ""
		cLocal	:= ""
		cAluno	:= ""
		cEmail	:= ""
		cTurma	:= ""
		cCH		:= ""
		cCateg	:= ""
		oReport:Section(2):PrintLine()//imprime a linha
	EndIf
	
	oReport:Section(2):SetTotalText("TOTAL")
	oReport:Section(1):Finish()
	oReport:Section(1):SetPageBreak()
	oReport:Section(2):Finish()
	oReport:Section(2):SetPageBreak()
	SM0->(RestArea(aArea))

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Fun��o para montar as colunas do relat�rio

@author Wagner Mobile Costa
@version P12
@param 	aRet[1][1] - Nome
		aRet[1][2] - Tamanho
		aRet[1][3] - Variavel
		aRet[2][1] - Descri��o do Grupo
@since 29/07/2015
/*/
//-----------------------------------------------------------------------------
Static Function TCTR100Col()

Local aR1 	:= {}
Local aR2 	:= {}
Local cWhere2 := ""
    
//Clausula Where da Pesquisa
If Empty(MV_PAR08)
   cWhere2 := "1=1"
Else
   cWhere2 := "PD5.PD5_PESQ = '" + MV_PAR08 + "'"
Endif
cWhere2 := "%" + cWhere2 + "%"

	BeginSql Alias "QRY"
		SELECT PD5.PD5_PESQ, PD5_ITEM, PD5.PD5_FINALI, PD5.PD5_TOPICO, MIN(SX5.X5_DESCRI) AS X5DESCRI 
		  FROM %table:PDF% PDF 
		  JOIN %table:PD3% PD3 ON PD3.PD3_FILIAL = PDF.PDF_FILIAL AND PD3.PD3_TURMA = PDF.PDF_TURMA AND PD3.%notdel% 
		  JOIN %table:PD5% PD5 ON PD5.PD5_FILIAL = %exp:xFilial("PD5")% AND PD5.PD5_PESQ = PD3.PD3_PESQ AND PD5.%notdel%
		  JOIN %table:SX5% SX5 ON SX5.X5_FILIAL = %exp:xFilial("SX5")% AND SX5.X5_TABELA = %Exp:"Z7"% AND SX5.%notdel%
		   AND SX5.X5_CHAVE = PD5.PD5_TOPICO
		 WHERE %Exp:cWhere% AND PDF.%notdel% AND %Exp:cWhere2%  
		 GROUP BY PD5.PD5_PESQ, PD5_ITEM, PD5.PD5_FINALI, PD5.PD5_TOPICO
		 ORDER BY PD5.PD5_PESQ, PD5_ITEM, PD5.PD5_FINALI, PD5.PD5_TOPICO
	EndSQL
	
	WHILE ! QRY->(EOF())
		AADD(aR1,{ AllTrim(Capital(QRY->X5DESCRI)), If(QRY->PD5_TOPICO=='99',150,5),'C'+QRY->PD5_ITEM, "", QRY->PD5_PESQ })
		if aScan(aR2, AllTrim(aTipo[Val(QRY->PD5_FINALI)][3]))=0
			AADD(aR2, AllTrim(aTipo[Val(QRY->PD5_FINALI)][3]))
		endif
		QRY->(DBSKIP())
	END
	QRY->(DbCloseArea())

Return({aR1,aR2})

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Fun��o para montar as colunas das abas Pesquisas Respondidas/Pendentes

@author Wagner Mobile Costa
@version P12
@param oSection = Se��o
@since 14/08/2015
/*/
//-----------------------------------------------------------------------------
Static Function TCTR100Peq(oSection)

TRCell():New(oSection,"cTrein" ,/*Tabela*/,STR0004,/*Picture*/,40,/*lPixel*/,{|| cTrein  }) //"Treinamento"
TRCell():New(oSection,"cTurma" ,/*Tabela*/,STR0005,/*Picture*/,9,/*lPixel*/,{|| cTurma  }) //"Turma"
TRCell():New(oSection,"cCH" ,/*Tabela*/,STR0006,/*Picture*/,6,/*lPixel*/,{|| cCH  }) //"Carga Horaria"
TRCell():New(oSection,"cCateg" ,/*Tabela*/,"Categoria",/*Picture*/,12,/*lPixel*/,{|| cCateg  })
TRCell():New(oSection,"cMes" ,/*Tabela*/,STR0007,/*Picture*/,15,/*lPixel*/,{|| cMes  }) //"M�s"
TRCell():New(oSection,"DtIni" ,/*Tabela*/,"Data Inicio",/*Picture*/,8,/*lPixel*/,{|| DtIni  })
TRCell():New(oSection,"DtFim" ,/*Tabela*/,STR0008,/*Picture*/,8,/*lPixel*/,{|| DtFim  }) //"Data Fim"
TRCell():New(oSection,"cPeriodo" ,/*Tabela*/,STR0009,/*Picture*/,15,/*lPixel*/,{|| cPeriodo  }) //"Periodo"
TRCell():New(oSection,"cNomInstr" ,/*Tabela*/,STR0010,/*Picture*/,TamSx3("PD2_NOME")[1],/*lPixel*/,{|| cNomInstr  }) //"Instrutor"
TRCell():New(oSection,"cLocal" ,/*Tabela*/,STR0011+CRLF+STR0004,/*Picture*/,25,/*lPixel*/,{|| cLocal  }) //"Local do "###"Treinamento"
TRCell():New(oSection,"cAluno" ,/*Tabela*/,STR0012,/*Picture*/,TamSx3("PDL_NOME")[1],/*lPixel*/,{|| cAluno  }) //"Nome Aluno"
TRCell():New(oSection,"cCodCli" ,/*Tabela*/,'Cliente',/*Picture*/,TamSx3("A1_COD")[1],/*lPixel*/,{|| cCodCli  }) //"Cod Empresa"
TRCell():New(oSection,"cNomCli" ,/*Tabela*/,STR0013,/*Picture*/,TamSx3("A1_NOME")[1],/*lPixel*/,{|| cNomCli  }) //"Empresa"
TRCell():New(oSection,"cCnpj" ,/*Tabela*/,'CPF/CNPJ',/*Picture*/,TamSx3("A1_CGC")[1],/*lPixel*/,{|| cCnpj    }) //"CgC"
TRCell():New(oSection,"cLin" ,/*Tabela*/,STR0014,/*Picture*/,25,/*lPixel*/,{|| cLin  }) //"Produto Marca"
TRCell():New(oSection,"cEmail" ,/*Tabela*/,STR0015,/*Picture*/,TamSx3("PDL_EMAIL")[1],/*lPixel*/,{|| cEmail  }) //"Email"
TRCell():New(oSection,"cTelAluno" ,/*Tabela*/,STR0022,/*Picture*/,TamSx3("PDL_EMAIL")[1],/*lPixel*/,{|| cTelAluno  })  //"Tel Aluno"
TRCell():New(oSection,"cTelEmpresa" ,/*Tabela*/,STR0023,/*Picture*/,TamSx3("PDL_EMAIL")[1],/*lPixel*/,{|| cTelEmpresa  })  //"Tel Empresa"

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Fun��o para impress�o dos dados chave das abas Pesquisas Respondidas/Pendentes

@author Wagner Mobile Costa
@version P12
@param oSection = Se��o e cAlias = Alias com as informa��es 
@since 14/08/2015
/*/
//-----------------------------------------------------------------------------
Static Function TCTR100Prn(oSection, cAlias)

cTrein := (cAlias)->PD3_NOME
cCateg := " "
if Val((cAlias)->PD3_CATEG) > 0
	cCateg := aCateg[val((cAlias)->PD3_CATEG)][3]
endif
cMes   := MesExtenso(Month((cAlias)->PD3_DTFIM))
DtIni  := (cAlias)->PD3_DTINI
DtFim  := (cAlias)->PD3_DTFIM
cTurma := (cAlias)->(PD3_TURMA + "/" + PDF_PERIO) 
nPer   := Ascan(aPerio,{ |x| x[2] == (cAlias)->PD3_PERIOD })
cPeriodo := ""
if nPer > 0
	cPeriodo := aPerio[nPer][3] // Periodo
endif
cNomInstr := (cAlias)->PD2_NOME

cLocal := (cAlias)->PD3_FILIAL
If SM0->(DBSEEK( cEmpAnt + (cAlias)->PD3_FILIAL )) .And. ! Empty(SM0->M0_CIDCOB)
	cLocal := SM0->M0_CIDCOB
EndIf

cAluno  := (cAlias)->PDL_NOME
cEmail  := (cAlias)->PDL_EMAIL 
cTelAluno := (cAlias)->PDL_TEL + If(! Empty((cAlias)->PDL_TEL2), "/" + (cAlias)->PDL_TEL2, "") 
cNomCli	:= (cAlias)->A1_NOME
cTelEmpresa := (cAlias)->A1_TEL 
cLin	:= (cAlias)->PDM_TPOSIS
cCH		:= cValtochar((cAlias)->PDF_QTDHOR)
cCnpj   := (cAlias)->A1_CGC
cCodCli := (cAlias)->A1_COD


nLi		:= Ascan(aLinha,{ |x| x[2] == cLin })
if nLi > 0
	cLin := aLinha[nLi][3] // Linha de Produto
endif
	
oSection:Cell("cTrein"):Show()//HIDE()"
oSection:Cell("cTurma"):Show()//HIDE()"
oSection:Cell("cCH"):Show()//HIDE()"
oSection:Cell("cCateg"):Show()//HIDE()"
oSection:Cell("cMes"):Show()//HIDE()"
oSection:Cell("DtIni"):Show()//HIDE()"
oSection:Cell("DtFim"):Show()//HIDE()"
oSection:Cell("cPeriodo"):Show()//HIDE()"
oSection:Cell("cNomInstr"):Show()//HIDE()"
oSection:Cell("cLocal"):Show()//HIDE()"
oSection:Cell("cAluno"):Show()//HIDE()"
oSection:Cell("cCodCli"):Show()//HIDE()"
oSection:Cell("cNomCli"):Show()//HIDE()"
oSection:Cell("cCnpj"):Show()//HIDE()"
oSection:Cell("cLin"):Show()//HIDE()"
oSection:Cell("cEmail"):Show()//HIDE()"
oSection:Cell("cTelAluno"):Show()//HIDE()"
oSection:Cell("cTelEmpresa"):Show()//HIDE()"

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Fun��o para retorno do titulo das colunas

@author Wagner Mobile Costa
@version P12
@param oSection = Se��o e cAlias = Alias com as informa��es 
@since 16/12/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTR100Tit(cPesq, cTitulo)

Return cPesq + "-" + cTitulo
//-----------------------------------------------
