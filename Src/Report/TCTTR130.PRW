#INCLUDE "TCTTR130.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR130
(Fun��o de execu��o de relat�rio BIRT TCTTR130.RPTDESIGN Relat�rio de Turmas.   )
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
 
DEFINE REPORT oReport NAME TCTTR130 TITLE STR0001 //"Relat�rio de Turmas"
 
ACTIVATE REPORT oReport LAYOUT TCTTR130 FORMAT HTML
 
Return