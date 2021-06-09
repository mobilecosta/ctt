#INCLUDE "TCTTR060.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR060
(Função de execução de relatório BIRT TCTTR060.RPTDESIGN Relatório de Turmas X Alocações.    )
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR060()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR060 TITLE STR0001 //"Turmas X Alocações"
 
ACTIVATE REPORT oReport LAYOUT TCTTR060 FORMAT HTML
 
Return
