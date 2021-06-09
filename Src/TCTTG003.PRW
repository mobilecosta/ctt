#Include "Protheus.ch"
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function TCTTG003
Gatilho para preenchimento do campo PD6_TPOPRO 
@author Fabio Veiga Oliva
@version P12
@since 20/12/2019
/*/
//-----------------------------------------------------------------------------

User Function TCTTG003()       
Local cPD6_TPOPRO := M->PD6_TPOPRO
If M->PD6_TIPO == "2" //Recorrente
   cPD6_TPOPRO := "6" //6-N.A.
EndIf            

If M->PD6_TIPO <> "2"  .And. cPD6_TPOPRO = "6"//Recorrente
   cPD6_TPOPRO := "1" 
EndIf            
Return(cPD6_TPOPRO)                        

//Rotina para gravar tipo N.Recorrente nas propostas existentes
User Function CTTGrvTp()
_xSqlExec := " UPDATE "+RetSqlName("PD6")+" SET PD6_TIPO = '1'  WHERE PD6_TIPO = ' '"
TcSqlExec(_xSqlExec)
Return
