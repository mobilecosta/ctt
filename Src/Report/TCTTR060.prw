#INCLUDE "TCTTR060.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR060
(Fun��o de execu��o de relat�rio BIRT TCTTR060.RPTDESIGN Relat�rio de Turmas X Aloca��es.    )
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
 
DEFINE REPORT oReport NAME TCTTR060 TITLE STR0001 //"Turmas X Aloca��es"
 
ACTIVATE REPORT oReport LAYOUT TCTTR060 FORMAT HTML
 
Return
