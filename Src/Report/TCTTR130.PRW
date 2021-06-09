#INCLUDE "TCTTR130.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR130
(Função de execução de relatório BIRT TCTTR130.RPTDESIGN Relatório de Turmas.   )
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR130()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR130 TITLE STR0001 //"Relatório de Turmas"
 
ACTIVATE REPORT oReport LAYOUT TCTTR130 FORMAT HTML
 
Return