#INCLUDE "TCTTR010.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR010
(Fun��o de execu��o de relat�rio BIRT TCTTR010.RPTDESIGN Relat�rio de Instrutores com grade de capacita��o.)
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
 
DEFINE REPORT oReport NAME TCTTR010 TITLE STR0001  //"Instrutores com grade de capacita��o"
 
ACTIVATE REPORT oReport LAYOUT TCTTR010 FORMAT HTML
 
Return
