#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} When
Condição de edição dos campos PD3_CATEG e PD3_QTDHOR

@author Wagner Mobile Costa
@version P12
@since 08/04/2015
@return = lRet = Indica se tem acesso ao campo
/*/
//-----------------------------------------------------------------------------
User Function TCTTW001

Return M->PD3_CATEG $ '9,3'		//-- 1=Regular;2=V.I.P.;3=Personalizado;4=In Company;5=Virtual;6=Controller;7=Formacao TOTVS;9=Adm