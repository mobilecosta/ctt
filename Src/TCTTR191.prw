#include 'protheus.ch'
#include 'parmtype.ch'
#Define STR_PULA    Chr(13)+Chr(10)


User function TCTTR191()

Local oReport

Pergunte("TCTTR191",.F.)

oReport := ReportDef()
oReport:PrintDialog()

Return( Nil )
//***********************************************************************************************************************************

Static Function ReportDef()

Local oReport
Local oSection
Local oBreak

// Criando a o Objeto
oReport := TReport():New("TCTTR191","Relatorio de turmas x Locação","TCTTR191",{|oReport| PrintReport(oReport)},"Relatorio das turmas por alocação")
oReport:SetLandscape() // Define a orientação de página do relatório como paisagem
oReport:LPARAMPAGE        := .F.	// Nao imprime pagina de parametros


oSection := TRSection():New(oReport,"Turmas" )

oSection:SetTotalInLine(.F.) // Define se os totalizadores serão impressos em linha ou coluna
oSection:SetLineHeight(30)
oSection:SetColSpace(1)
oSection:SetLeftMargin(1)

	TRCell():New(oSection,"PD3_FILIAL" ,"PD3")
	TRCell():New(oSection,"PD3_STATUS" ,"PD3")
	TRCell():New(oSection,"PD3_MODAL"  ,"PD3")
	TRCell():New(oSection,"PD3_CATEG"  ,"PD3")
	TRCell():New(oSection,"PD3_DTINI"  ,"PD3")    
	TRCell():New(oSection,"PD3_DTFIM"  ,"PD3")    
	TRCell():New(oSection,"PD3_TURMA"  ,"PD3","Cod. Turma")
	TRCell():New(oSection,"PDM_TPOSIS" ,"PDM","ERP")
	TRCell():New(oSection,"PD3_CURSO"  ,"PD3","Curso")
	TRCell():New(oSection,"PD3_NOME"   ,"PD3","Nome do Curso", "@!", 30)
	
	TRCell():New(oSection,"PD3_PERIOD" ,"PD3")
	TRCell():New(oSection,"PD3_QTDHOR" ,"PD3")
	TRCell():New(oSection,"PD2_NOME"   ,"PD2","Instrutor", "@!",25)
	TRCell():New(oSection,"PD2_EMAIL"  ,"PD2","Email Instrutor")

oSection2 := TRSection():New(oSection,"Alocação" )
oSection2:SetLeftMargin(2)
	TRCell():New(oSection2,"PD7_CONFIR","PD7","Confirmacao","@!",15)
	TRCell():New(oSection2,"PD7_ALUNO" ,"PD7","Aluno")
	TRCell():New(oSection2,"PDL_NOME"  ,"PDL","Nome do Aluno" ,"@!",20)
	TRCell():New(oSection2,"PDL_CPF" ,"PDL")
	TRCell():New(oSection2,"PDL_EMAIL" ,"PDL","Email Aluno","@!",40)
	TRCell():New(oSection2,"PD7_PRENC" ,"PD7","Presença")
	TRCell():New(oSection2,"PDL_TEL"   ,"PDL")
	TRCell():New(oSection2,"PDL_TEL2"  ,"PDL")
	TRCell():New(oSection2,"A1_COD"    ,"SA1", "Cod. Cliente")
	TRCell():New(oSection2,"A1_NOME" ,"SA1","Nome do Cliente","@!",30)
	TRCell():New(oSection2,"A1_TEL"    ,"SA1")
	TRCell():New(oSection2,"PD6_PROPOS","PD6")
	TRCell():New(oSection2,"PD6_SLDHS" ,"PD6", "Saldo Atual")

Return ( oReport )

//*******************************************************************************************

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cPart := ""
Local nOrdem    := oReport:Section(1):GetOrder()
Local cAlias := GetNextAlias() 
oSection:BeginQuery()

//cPart := "%%"
  
BeginSql alias cAlias

//COLUMN PD3_DTINI AS DATE
//COLUMN PD3_DTFIM AS DATE

SELECT PD3_FILIAL, 
       PD3_STATUS,
       PD3_MODAL, 
       PD3_CATEG, 
       PD3_TURMA,
       PD7_TURMA,  
       PDM_TPOSIS, 
       PD3_CURSO,
       PD3_NOME, 
       PD3_DTINI     , 
       PD3_DTFIM     , 
       PD3_PERIOD, 
       PD3.PD3_QTDHOR,
       PD2_NOME , 
       PD2_EMAIL,
       PD7_CONFIR,
       PD7_PRENC,
       PD7_ALUNO,
       PDL_NOME, 
       PDL_EMAIL,
       PDL_CPF, 
       PDL_TEL, 
       PDL_TEL2, 
       CASE 
         WHEN US_FILIAL IS NULL THEN A1_COD 
         ELSE US_COD 
       END            AS A1_COD, 
       CASE 
         WHEN US_FILIAL IS NULL THEN A1_NOME 
         ELSE US_NOME 
       END            AS A1_NOME, 
       CASE 
         WHEN US_FILIAL IS NULL THEN A1_TEL 
         ELSE US_TEL 
       END            AS A1_TEL, 
       PD3_PESQ,
       PD6_PROPOS,
       PD6_SLDHS
FROM  %Table:PDF% PDF 
       JOIN %Table:PD2% PD2 
         ON PD2.PD2_FILIAL = %xFilial:PD2%
            AND PD2.PD2_PROF = PDF.PDF_PROF 
            AND PD2.%notdel%
      LEFT JOIN %Table:PD3% PD3 
         ON PD3.PD3_FILIAL = PDF.PDF_FILIAL 
            AND PD3.PD3_TURMA = PDF.PDF_TURMA 
        
             AND PD3.PD3_PROF >= %EXP:MV_PAR07%
             AND PD3.PD3_PROF <= %EXP:MV_PAR08%
        
            AND PD3.%notdel% 
       JOIN %Table:PDM% PDM 
         ON PDM.PDM_FILIAL = %xFilial:PDM% 
            AND PDM.PDM_CURSO = PD3.PD3_CURSO 
            AND PDM.%notdel% 
       JOIN %Table:PD7% PD7 
         ON PD7.PD7_FILIAL = PD3.PD3_FILIAL 
         AND PD7.PD7_TURMA = PD3.PD3_TURMA 
         AND PD7.D_E_L_E_T_ = ' '
            
       LEFT JOIN %Table:SA1% SA1 
              ON SA1.A1_FILIAL = %xFilial:SA1% 
                 AND SA1.A1_COD = PD7.PD7_CLIENT 
                 AND SA1.A1_LOJA = PD7.PD7_LOJA 
                 AND SA1.%notdel% 
       LEFT JOIN %Table:SUS% SUS 
              ON SUS.US_FILIAL = %xFilial:SUS% 
                 AND SUS.US_COD = PD7.PD7_PROSPE 
                 AND SUS.US_LOJA = PD7.PD7_LOJPRO 
                 AND SUS.%notdel% 
       JOIN %Table:PDL% PDL 
         ON PDL.PDL_FILIAL = %xFilial:SUS% 
            AND PDL.PDL_ALUNO = PD7.PD7_ALUNO 
            AND PDL.%notdel% 
      LEFT JOIN %Table:PD6% PD6
     // ON PD6.PD6_FILIAL = PD7.PD7_FILIAL 
      ON PD7_PROPOS = PD6_PROPOS
      AND PD6.%notdel% 

  WHERE PDF.PDF_FILIAL >= %EXP:MV_PAR01%
       AND PDF.PDF_FILIAL <= %EXP:MV_PAR02%
       
       AND PDF.PDF_TURMA >= %EXP:MV_PAR03%
       AND PDF.PDF_TURMA <= %EXP:MV_PAR04%
       
       AND PDF.PDF_DTINI >= %EXP:MV_PAR05% 
       AND PDF.PDF_DTFIM <= %EXP:MV_PAR06%
       
    
       AND PDF.%notdel% 
Order by PD3_FILIAL, PD3_DTINI, PDF_TURMA

	
EndSql

aRetSql := GetLastQuery()

memowrite("C:\temp\sqlturmas.txt",aRetSql[2])

oSection:EndQuery()
oSection2:SetParentQuery()
oSection2:SetParentFilter({|cParam| (cAlias)->PD7_TURMA == cParam},{|| (cAlias)->PD3_TURMA})
oSection:Print()

(cAlias)->( dbCloseArea() ) 

Return( Nil ) 

