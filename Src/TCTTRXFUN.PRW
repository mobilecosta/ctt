#INCLUDE "TCTTRXFUN.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "AP5MAIL.CH"
#Include "FWMVCDEF.CH"

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Função para montagem de cabecalho de relatórios em TMsPrinter

@author Fabio Jose Batista
@version P12
@since 10/04/2015
/*/
//-----------------------------------------------------------------------------

User Function TCTTRCAB()
   //Caixa
           //Topo  LE  Fundo  LD
	oPrn:Box(0050,0050,0450,  3335)  
	
	        //Topo  LE  Fundo  LD
	oPrn:Box(0500,0050, 2300,  3335) 
	
    oPrn:SayBitmap( 060,060, 'totvs.jpg',360, 360, , .T. )    
Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Função para centralizar texto de relatórios em TMsPrinter

@author Fabio Jose Batista
@version P12
@since 10/04/2015
/*/
//-----------------------------------------------------------------------------

User Function Centralizar(cTexto,oFonte,pIni,pFin)
Local nPos := 0

nPos := (((pFin/2)-(oPrn:GetTextWidth (cTexto, oFonte)/2))-pIni)

Return nPos

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Função para gravação de log de envio de email

@author Wagner Mobile Costa
@version P12
@since 07/09/2016
/*/
//-----------------------------------------------------------------------------

User Function TCTXLOGM(cTabela, cChave, cAssunto, cEMail, cMsgFile, cFile, lSendMail)

Local cCopy := ""
Private lCopyObj := .F.
Private CCODOBJ  := ""
Default cMensagem := ""
 
If ! Empty(cMsgFile)
	If ! Empty(cEMail)
		cMsgFile += "</br>" + "cc: " + cEMail
	EndIf

	If ! lSendMail
		cMsgFile += "</br>" + "Erro: " + cMensagem 
	EndIf

	MemoWrit(cFile, cMsgFile)
EndIf

RegToMemory("ACB",.t.)

cCopy := GetLocEnd(0)+RetFileName(cFile) + Subs(cFile, Rat(".", cFile), Len(cFile))
__CopyFile(cFile,cCopy)
MsDocWzGrv( cCopy, cAssunto, {}, {} )
FErase(cFile)

RecLock("AC9",.T.)
AC9->AC9_FILIAL	:= xFilial("AC9")
AC9->AC9_FILENT	:= xFilial(cTabela)
AC9->AC9_ENTIDA := cTabela
AC9->AC9_CODENT	:= xFilial(cTabela) + cChave
AC9->AC9_CODOBJ	:= M->ACB_CODOBJ
MSUnlock()

Return


/*/{Protheus.doc} RetToken
Abre arquivo TXT e retorna o Token
@type function
@author queizy.nascimento
@since 23/03/2017
@version 1.0
/*/
User Function RetToken()

Local cFile := '\SYSTEM\TOKENVLABS.CFG'
Local cLine := ''

	// Verifica se o arquivo existe
	If ! File(cFile)
		MsgAlert('Erro', 'Arquivo de configuração de Token ( '+cFile+' ) não encontrado.')
		Return cLine
	Endif

	// Abre o arquivo
	nHandle := FT_FUse(cFile)
	// Se houver erro de abertura abandona processamento
	If nHandle = -1
		MsgAlert('Erro', 'Erro na leitura do arquivo de configuração de Token ( '+cFile+' ). Verifique.')
		Return cLine
	EndIf
		
	// FT_FReadLn:
	// Lê e retorna uma linha de texto do arquivo aberto pela função FT_FUse().
	// As linhas do texto, são delimitadas pela sequência de caracteres CRLF (chr(13)+chr(10))
	// ou apenas LF (chr(10)), e o tamanho máximo de cada linha é 1022 bytes.
	cLine  := FT_FReadLn()
		
	// Fecha o Arquivo
	FT_FUSE()
	
Return cLine
