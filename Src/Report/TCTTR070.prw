#INCLUDE "TCTTR070.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR070
(Fun��o de execu��o de relat�rio BIRT TCTTR070.RPTDESIGN Relat�rio de Turmas X Agendamentos. )
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR070()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR070 TITLE STR0001 //"Turmas X Agendamentos"
 
ACTIVATE REPORT oReport LAYOUT TCTTR070 FORMAT HTML
 
Return
