#INCLUDE "TCTTR040.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR040
(Função de execução de relatório BIRT TCTTR040.RPTDESIGN Relatório de Cursos Faturados.  )
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR040()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR040 TITLE STR0001 //"Cursos Faturados"
 
ACTIVATE REPORT oReport LAYOUT TCTTR040 FORMAT HTML
 
Return
