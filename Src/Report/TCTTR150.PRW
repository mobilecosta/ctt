#INCLUDE "TCTTR150.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR150
(Fun��o de execu��o de relat�rio BIRT TCTTR150.RPTDESIGN Relat�rio de Salas de aula.    )
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR150()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR150 TITLE STR0001 //"Relat�rio de Salas"
 
ACTIVATE REPORT oReport LAYOUT TCTTR150 FORMAT HTML
 
Return
