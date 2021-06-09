#INCLUDE "TCTTR050.ch"
#INCLUDE "totvs.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Geração de planilha excell para conferencia da Alocação

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------
USER FUNCTION TCTTR050()

Local cPerg		:=	"TCTTR050"
Local aCabec := {} //variavel de cabeçalho
Local aDados := {} //variavel dos dados
Local cWhere := ""                  

	If !ApOleClient("MSExcel") // testa a interação com o excel.
		MsgAlert(STR0001) //"Microsoft Excel não instalado!"
		Return Nil
	EndIf

	If ! Pergunte(cPerg,.T.)
		return 
	endif             

	MakeSqlExpr(cPerg)

   	If !Empty(MV_PAR07)		//-- Filial
      	cWhere += " AND " + MV_PAR07
   	EndIf

   	If !Empty(MV_PAR03)		//-- SALA DE 
      cWhere += " AND PD3.PD3_SALA >= '" + MV_PAR03 + "'"
   	EndIf

   	If !Empty(MV_PAR04)		//-- SALA ATÉ
      	cWhere += " AND PD3.PD3_SALA <= '" + MV_PAR04 + "'"
   	EndIf

   	If !Empty(MV_PAR05)		//-- Professor de
      	cWhere += " AND PDF.PDF_PROF >= '" + MV_PAR05 + "'"
   	EndIf

   	If !Empty(MV_PAR06)		//-- Professor ate
      	cWhere += " AND PDF.PDF_PROF <= '" + MV_PAR06 + "'"
   	EndIf
   	
   	cWhere := "%" + cWhere + "%"

   
   	BeginSql Alias "QRY"
      	COLUMN PDF_DTINI AS DATE
      	COLUMN PDF_DTFIM AS DATE  

		SELECT PD3_FILIAL, PD3_TURMA, PD3_SALA, PDO_NOME, PD3_PROF, PD2_NOME, PD3_CURSO, PDM_NOME, PDF_DTINI, PDF_DTFIM, PDF_QTDHOR, 
		       INSC, PDO_NOME, PDO_COMP
	      FROM %table:PD3% PD3
		  JOIN %table:PDF% PDF ON PDF.%NotDel% AND PDF.PDF_FILIAL = PD3.PD3_FILIAL AND PDF.PDF_TURMA = PD3.PD3_TURMA
           AND PDF.PDF_DTINI BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)% 
	      JOIN %table:PD2% PD2 ON PD2.%NotDel% AND PD2.PD2_FILIAL = %exp:xFilial("PD2")% AND PD2.PD2_PROF = PDF.PDF_PROF
       	  JOIN %Table:PDM% PDM ON PDM.%NotDel% AND PDM.PDM_FILIAL = %exp:xFilial("PDM")% AND PDM.PDM_CURSO = PD3.PD3_CURSO
	      JOIN %Table:PDO% PDO ON PDO.%NotDel% AND PDO.PDO_FILIAL = %exp:xFilial("PDO")% AND PDO.PDO_SALA = PD3.PD3_SALA 
          LEFT JOIN (SELECT PD7_FILIAL, PD7_TURMA, PDF_PERIO, COUNT(*) AS INSC
                       FROM %table:PD3% PD3 
                       JOIN %table:PD7% PD7 ON PD7.%NotDel% AND PD7.PD7_FILIAL = PD3.PD3_FILIAL AND PD7.PD7_TURMA = PD3.PD3_TURMA 
                        AND PD7.PD7_CONFIR IN (%exp:'1'%, %exp:'5'%, %exp:'6'%)
                       JOIN %table:PDF% PDF ON PDF.%NotDel% AND PDF.PDF_FILIAL = PD3.PD3_FILIAL AND PDF.PDF_TURMA = PD3.PD3_TURMA
                        AND PDF.PDF_DTINI BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)% 
                      WHERE PD3.%notdel% %Exp:cWhere%
                      GROUP BY PD7_FILIAL, PD7_TURMA, PDF_PERIO) PD7 ON PD7.PD7_FILIAL = PD3.PD3_FILIAL AND PD7.PD7_TURMA = PD3.PD3_TURMA
           AND PD7.PDF_PERIO = PDF.PDF_PERIO 
         WHERE PD3.%notdel% %Exp:cWhere%
           AND PD3.PD3_STATUS <> %exp:'C'% 
        ORDER BY PD3_FILIAL, PD3_TURMA, PDF_DTINI
	endsql

	aCabec := {STR0002,STR0003,STR0004,STR0005,STR0006, STR0007, STR0008,STR0009, STR0010, STR0011,STR0012, " Filial "} //"Nome Curso"###"Instrutor"###"Código Turma"###"Dt. Início"###"Dt. Fim"###"Sala"###"Carga Horária"###"Cod. Sala"###"Cod. Instrutor"###"Inscritos"###"Vagas"
	
	WHILE !QRY->(EOF())
		
		AADD(aDados,{	ALLTRIM(QRY->PDM_NOME),;//01
		ALLTRIM(QRY->PD2_NOME),;//02
		QRY->PD3_TURMA, ;//03
		QRY->PDF_DTINI,;//04
		QRY->PDF_DTFIM,;//05
	    QRY->PDO_NOME,;
	 	QRY->PDF_QTDHOR,;//07
		QRY->PD3_SALA,;//08
		QRY->PD3_PROF,;//09
		QRY->INSC,;//10                                          
		QRY->PDO_COMP,;
		QRY->PD3_FILIAL })
		
		QRY->(DBSKIP())
	ENDDO
	QRY->(DbCloseArea())
	
	DlgToExcel({ {STR0013, STR0014, aCabec, aDados} }) // utiiliza a função //"ARRAY"###"Relação de Turmas"

Return
