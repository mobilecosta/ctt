#INCLUDE "TCTTR020.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR020
(Fun��o de execu��o de relat�rio BIRT TCTTR020.RPTDESIGN Relat�rio de Capta��o de Clientes. )
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR020()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR020 TITLE STR0001 //"Capta��o de Clientes"
 
ACTIVATE REPORT oReport LAYOUT TCTTR020 FORMAT HTML
 
Return
