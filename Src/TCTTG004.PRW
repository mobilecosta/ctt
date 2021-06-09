#Include "Protheus.ch"                                                  
#Include "FWMVCDEF.CH"
#Include "TOTVS.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function TCTTG004
Gatilho para preenchimento do campo PD6_HSRECO 
@author Fabio Veiga Oliva
@version P12
@since 20/12/2019
/*/
//-----------------------------------------------------------------------------
                                                              
User Function TCTTG004()       
Local nHoras := M->PD6_HORAS
If M->PD6_TIPO == "2" //Recorrente
   nHoras := M->PD6_HSRECO 
EndIf            
Return(nHoras) 