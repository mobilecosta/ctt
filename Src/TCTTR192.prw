#include 'protheus.ch'
#include 'parmtype.ch'

user function TCTTR192()

Local cAlias := GetNextAlias()
Local aQuery


If ! Pergunte("TCTTR192", .T.)
	Return( NIL )
Endif	


BeginSql Alias cAlias


 SELECT DISTINCT  
 CASE
   WHEN ADY_PROPOS <> ' ' THEN 'SIM'
   ELSE 'NAO' END AS CTT , 
   
   CASE
   WHEN PD6.PD6_SLDHS = 0 THEN 'OK'
   ELSE 'NAO' END AS VALID , 
    PD6.PD6_SLDHS AS SALDO_PROP ,
                ADY_PROPOS  AS PROPOS, 
                AD1_NROPOR  AS NROPOR, 
                ADJ_CODNIV  AS GRUPO,
                AD1.AD1_DTASSI AS DTASS,
                AD1_DATA AS DTINI, 
                AD1_CODCLI AS COD_CLI, 
                AD1_LOJCLI AS LOJA_CLI,
                A1_NOME    AS NOME_CLI, 
                ADY_VEND AS VENDEDOR, 
                A3_NOME  AS VEND_NOME,
                ADZ_PRODUT AS PRODUTO, 
                TRANSLATE(ADZ_DESCRI,'Õ…¡√ «¬”‘','IEAAECAOO')  AS DESCR, 
                TRANSLATE(PDM_NOME,'Õ…¡√ «¬”‘','IEAAECAOO')  AS CTT_DESCR, 
                PDM.PDM_QTDHOR AS HORAS,
                ADZ_TOTAL AS VALOR,
                AD1_RCREAL AS TOTAL
                
FROM   %Table:SB1% SB1, 
       %Table:ADZ% ADZ, 
       %Table:PDM% PDM, 
       %Table:ADY% ADY, 
       %Table:AD1% AD1, 
       %Table:ADJ% ADJ,
       %Table:PD6% PD6,
       %Table:SA3% SA3,
       %Table:SA1% SA1
              
WHERE  SB1.B1_FILIAL = AD1_FILIAL  
       AND B1_COD = ADZ_PRODUT 
       AND SB1.B1_COD = PDM.PDM_CODSB1 
       AND PDM.PDM_CODSB1 <> ' '
       AND PDM.PDM_MSBLQL <> '1'   
       AND PDM.%NOTDEL%
       AND SB1.%NOTDEL%
       
      AND ADJ_FILIAL = AD1_FILIAL  
      AND ADJ_CODAGR = '000112'
      AND ADJ_CODNIV IN ('0102','0103','0104','0105','0106','0107','0108')
      AND ADJ_NROPOR = AD1_NROPOR
      AND ADJ.%NOTDEL%
      
      AND ADY_FILIAL = AD1_FILIAL  
      AND ADY_OPORTU = AD1.AD1_NROPOR 
      AND ADY.%NOTDEL% 
      
      AND ADZ_FILIAL = ADY_FILIAL       
      AND ADZ_PROPOS = ADY.ADY_PROPOS 
      AND ADZ_REVISA = ADY.ADY_PREVIS 
      AND ADZ.%NOTDEL%
      
      AND A3_FILIAL = ADY_FILIAL    
      AND ADY_VEND = A3_COD(+)
      AND SA3.%NOTDEL%
      
       AND AD1_FILIAL = %XFILIAL:AD1%
       AND AD1_DTASSI >= %EXP:MV_PAR01%
       AND AD1_DTASSI <= %EXP:MV_PAR02% 
       AND AD1_REVISA = ADY_REVISA 
       AND AD1_FCS <> ' '  
       AND AD1.%NOTDEL%
       
       AND AD1_PROPOS = PD6_PROPOS(+)
       AND PD6.%NOTDEL%
       
       AND SA1.A1_FILIAL = AD1_FILIAL
       AND ( AD1_CODCLI = A1_COD(+)  AND AD1_LOJCLI = A1_LOJA(+) )   
       AND SA1.%NOTDEL% 

       ORDER BY AD1.AD1_DTASSI
       
EndSql         

aQuery := GetLastQuery()
		
	MsAguarde( { || U_CTTGeraXLS( "TCTTR192", cAlias ) }, "Aguarde ...", "Gerando relatorio TCTTR192", .T. )
	
	(cAlias)->( dbCloseArea() )
Return( NIL )


//---------------------------------------------------------------------------------------------------------------------------------------------------
User Function CTTGeraXLS( pNome, cAlias )

	Local _cDRVOpen := ""
	Local cPath     := cGetFile()//"C:\temp"
   Local oExcel	 := MntExcel():New()

   oExcel:SetNameArq(pNome)
   oExcel:SetTitle('pNome')
   oExcel:SetCab((cAlias)->(dbStruct()))
   oExcel:SetTabTemp(cAlias)
   oExcel:Create(oExcel)
   
	MsgInfo( "Arquivo " + cPath + pNome + ".XLS, gerado com sucesso !!!", "ATEN«√O !!!" )
	
Return( NIL )      
