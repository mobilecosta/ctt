#INCLUDE "TCTTR080.ch"
#Include 'Protheus.ch'
#Include 'tdsBirt.ch'

/*/{Protheus.doc} TCTTR080
(Fun��o de execu��o de relat�rio BIRT TCTTR080.RPTDESIGN Programa��o e Agendamento de Salas.  )
@author Alberto Shindi Kibino
@since 14/07/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function TCTTR080()
 
Local oReport
 
DEFINE REPORT oReport NAME TCTTR080 TITLE STR0001 //"Programa��o e Agendamento de Salas"
 
ACTIVATE REPORT oReport LAYOUT TCTTR080 FORMAT HTML
 
Return
