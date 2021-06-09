#INCLUDE "TCTTR010.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR010
(Função de execução de relatório BIRT TCTTR010.RPTDESIGN Relatório de Instrutores com grade de capacitação.)
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR010()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR010 TITLE STR0001  //"Instrutores com grade de capacitação"
 
ACTIVATE REPORT oReport LAYOUT TCTTR010 FORMAT HTML
 
Return
