#INCLUDE "TCTTA250.ch"
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Manutenção do Histórico de Treinamento

@author Fabio José Batista
@version P12
@since 02/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTA250()

Local oBrowse, aRotSave := AClone(aRotina)

Private cCadastro := STR0001 + AllTrim(SA1->A1_COD) + STR0002 + AllTrim(SA1->A1_LOJA) + STR0003 +; //"Histórico Treinamento - Cliente ["###"/"###"] - "
					 AllTrim(SA1->A1_NREDUZ)

aRotina := Nil		// Limpa as rotinas definidas pela rotina anterior

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("PD0")

oBrowse:SetDescription(cCadastro)
oBrowse:SetMenuDef("TCTTA250")
oBrowse:SetMainProc("TCTTA250")

oBrowse:SetFilterDefault( "PD0_CLIENT = '" + SA1->A1_COD + "' .AND. PD0_LOJA = '" + SA1->A1_LOJA + "'" )

oBrowse:Activate()

aRotina := AClone(aRotSave)

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Montagem do Menu do cadastro de Histórico de Treinamento

@author Wagner Mobile Costa
@version P12
@since 05/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE STR0006  	ACTION STR0004        	 	OPERATION 1 ACCESS 0 //"PESQBRW" //"Pesquisar"
ADD OPTION aRotina TITLE STR0007  	ACTION STR0005 		OPERATION 2 ACCESS 0 //"VIEWDEF.TCTTA250" //"Visualizar"
ADD OPTION aRotina TITLE STR0008 		ACTION STR0005 		OPERATION 3 ACCESS 0 //"VIEWDEF.TCTTA250" //"Incluir"
ADD OPTION aRotina TITLE STR0009  	ACTION STR0005 		OPERATION 4 ACCESS 0 //"VIEWDEF.TCTTA250" //"Alterar"
ADD OPTION aRotina TITLE STR0010 		ACTION STR0005 		OPERATION 5 ACCESS 0 //"VIEWDEF.TCTTA250" //"Excluir"

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo

@author Fabio José Batista
@version P12
@since 02/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ModelDef()

Local oStruPD0 	:= FWFormStruct( 1, 'PD0' )
Local oModel	:= MPFormModel():New('TCTTM250')

oModel:AddFields( 'TCTTAPD0',, oStruPD0 )
oModel:SetDescription( cCadastro )
oModel:GetModel( 'TCTTAPD0' ):SetDescription( cCadastro )

oModel:SetPrimaryKey({"PD0_FILIAL", "PD0_CLIENT"})

Return oModel

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Regras de Montagem do Modelo

@author Fabio José Batista
@version P12
@since 02/04/2015
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function ViewDef()

Local oModel   := FWLoadModel( 'TCTTA250' )
Local oStruPD0 := FWFormStruct( 2, 'PD0' )
Local oView

oView := FWFormView():New()
oView:SetModel( oModel )

oView:AddField( 'VIEW_PD0', oStruPD0, 'TCTTAPD0' )

oView:CreateHorizontalBox( 'TELA' , 100 )
oView:SetOwnerView( 'VIEW_PD0', 'TELA' )

Return oView

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Inicializador padrão do campo PD0_ITEM

@author Wagner Mobile Costa
@version P12
@since 14/06/2015
@return cRelacao
/*/
//-----------------------------------------------------------------------------
User Function TT250Ini()

Local cRelacao := "01", aArea := GetArea()

BeginSQL Alias "QRY"
	SELECT MAX(PD0_ITEM) AS PD0_ITEM 
	  FROM %table:PD0%
	 WHERE %notDel% AND PD0_CLIENT = %exp:SA1->A1_COD% AND PD0_LOJA = %exp:SA1->A1_LOJA%   
EndSql
If ! Empty(QRY->PD0_ITEM)
	cRelacao := Soma1(QRY->PD0_ITEM)
EndIf
QRY->(DbCloseArea())
RestArea(aArea)

Return cRelacao