#INCLUDE "TCTTR110.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR110
(Função de execução de relatório BIRT TCTTR110.RPTDESIGN Relatório de Ranking dos Cursos mais vendidos.   )
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR110()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR110 TITLE STR0001 //"Ranking dos Cursos mais Vendidos"
 
ACTIVATE REPORT oReport LAYOUT TCTTR110 FORMAT HTML
 
Return