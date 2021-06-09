#INCLUDE "TOTVS.CH"
#INCLUDE "TCTTR180.CH"

#define CRLF CHR(13)+CHR(10)

Static nHndXML   := 0

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Geração de planilha de programação de cursos

@author Fabio Jose Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------
User Function TCTTR180()

If ! pergunte("TCTTR180",.T.)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cXML := lower(alltrim(MV_PAR03))

If right(cXML,4) <> ".xml"
	cXML += ".xml"
Endif

RptStatus({|| RunReport() }, STR0001)	// "Geração da Planilha de Cursos"

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Execução do processamento para planilha 

@author Fabio Jose Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function RunReport()

Local _FGestao	:= ""
Local _cTpoSis
Local _aMerPla	:= {}
Local _nX 		:= 0
Local _nY		:= 0

	nHndXML   := 0
	MV_PAR04 := STRZERO(VAL(MV_PAR04),2)
	
	BeginSQL Alias "QRYPDM"
	   SELECT PDM_CURSO, PDM_TPOSIS, PDM_FAMGES, X5_DESCRI AS PDM_DESCFM, PDM_NOME, PDM_QTDHOR, PDM_VALOR, PDM_VERSAO 
	     FROM %table:PDM% PDM 
	     JOIN %table:SX5% SX5 ON SX5.%notdel% AND SX5.X5_FILIAL = %Exp:xFilial("SX5")% 
	      AND SX5.X5_TABELA = %Exp:'Z1'% AND SX5.X5_CHAVE = PDM.PDM_FAMGES  
	    WHERE PDM.%notdel% AND PDM_MSBLQL = %Exp:'2'% AND PDM_TPOSIS <> %Exp:''%
	      AND PDM_FAMGES <> %Exp:''% AND PDM_NOME <> %Exp:''% 
	      AND PDM_CURSO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% 
	    ORDER BY PDM_TPOSIS, PDM_FAMGES, PDM_NOME
	EndSQL

	_aDTposis := RetSx3Box(POSICIONE("SX3", 2, "PDM_TPOSIS", "X3CBOX()"),,, 1)
	
	DbSelectArea("QRYPDM")
	
	While !QRYPDM->(EOF())
		_cTpoSis := QRYPDM->PDM_TPOSIS
		cFile	 := Alltrim(_aDTposis[Ascan(_aDTposis,{ |x| x[2] = QRYPDM->PDM_TPOSIS })][3])
		cModelo	 := ""
		
		If nHndXML == 0
			nHndXML := fCreate(cXML)
	 		IF nHndXML <= 0
	 			Alert(STR0002 + cXML + "]")		// "Atenção o arquivo que esta sendo gerado esta em uso ["
				QRYPDM->(DbCloseArea())
	 			return nil
	 		endif 
	 
			CabecXML()
			AddStyles()
		EndIf
		
		NewSheet(cFile)		
		
		aRow := {}
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		AddRow(aRow,18,cModelo,.F.)
		
		aRow := {}
		aadd(aRow,{STR0003 + cFile,"s78","",""})	//"Calendário de Treinamento - "
		aadd(aRow,{"","s79","",""})
		aadd(aRow,{"","s79","",""})
		aadd(aRow,{"","s79","",""})
		aadd(aRow,{"","s79","",""})
		aadd(aRow,{"","s79","",""})
		aadd(aRow,{"","s79","",""})
		aadd(aRow,{"","s71","",""})
		AddRow(aRow,18,cModelo,.F.)
		
		aRow := {}
		aadd(aRow,{"","",""})
		aadd(aRow,{"Atendimento Comercial","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"Integral (I)","",""})
		aadd(aRow,{"= " + mv_par06,"",""})
		aadd(aRow,{"","",""})
		AddRow(aRow,18,cModelo,.F.)
		
		aRow := {}
		aadd(aRow,{"","",""})
		aadd(aRow,{"Horário: " + mv_par05,"",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"Sábado (Sab)","",""})
		aadd(aRow,{"= " + mv_par09,"",""})
		aadd(aRow,{"","",""})
		AddRow(aRow,18,cModelo,.F.)
		
		aRow := {}
		aadd(aRow,{"","",""})
		aadd(aRow,{"Telefone:    "  + TABELA("Z4",ALLTRIM(SM0->M0_ESTCOB)) +         "     e-mail:  "  +  LOWER(TABELA("Z3",ALLTRIM(SM0->M0_ESTCOB))) ,"",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"Noite    (N)","",""})
		aadd(aRow,{"= " + mv_par08,"",""})
		aadd(aRow,{"","",""})
		AddRow(aRow,18,cModelo,.F.)
		
		aRow := {}
		aadd(aRow,{"","",""})
		aadd(aRow,{"Local:   " + Alltrim(SM0->M0_FILIAL) + "  -  (" + Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim(SM0->M0_BAIRCOB) + ")","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"Manhã  (M)","",""})
		aadd(aRow,{"= " + mv_par06,"",""})
		aadd(aRow,{"","",""})
		AddRow(aRow,18,cModelo,.F.)
		
		aRow := {}
		aadd(aRow,{"","",""})
		aadd(aRow,{mv_par10,"",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"","",""})
		aadd(aRow,{"Tarde    (T)","",""})
		aadd(aRow,{"= " + mv_par08,"",""})
		aadd(aRow,{"","",""})
		AddRow(aRow,18,cModelo,.F.)
		
		_cMes01	:= UPPER(FG_CMONTH(CTOD("01/" + MV_PAR04)))
		_cMes02	:= UPPER(FG_CMONTH(CTOD("01/" + STR(VAL(MV_PAR04)+1))))
		_cMes03	:= UPPER(FG_CMONTH(CTOD("01/" + STR(VAL(MV_PAR04)+2))))
		
		aRow := {}
		aadd(aRow,{"FAMÍLIA DE GESTÃO","s134",""})
		aadd(aRow,{"CURSO","s134",""})
		aadd(aRow,{"CARGA HORARIA","s134",""})
		aadd(aRow,{"VALOR CURSO","s134",""})
		aadd(aRow,{"VERSAO","s134",""})
		aadd(aRow,{_cMes01,"s134",""})
		aadd(aRow,{_cMes02,"s134",""})
		aadd(aRow,{_cMes03,"s134",""})
		AddRow(aRow,18,cModelo,.F.)
		
		While !QRYPDM->(EOF()) .AND. _cTpoSis = QRYPDM->PDM_TPOSIS
			
			_cTpoSis 	:= QRYPDM->PDM_TPOSIS
			_FGestao	:= QRYPDM->PDM_DESCFM 
			_lPulaArow	:= .T.
			_lChkArow	:= .T.
			_lChkMerge	:= .T.
			_lVldStil	:= .T.
			_NroFamGe	:= Alltrim(QRYPDM->PDM_FAMGES)
			
			_aMerPla	:= {}
			
			While !QRYPDM->(EOF()) .AND. _cTpoSis = QRYPDM->PDM_TPOSIS .AND. _NroFamGe = Alltrim(QRYPDM->PDM_FAMGES)
				
				_cNomeCur	:= Alltrim(QRYPDM->PDM_NOME)
				_nQtdHr		:= TRANS(QRYPDM->PDM_QTDHOR, PesqPict("PDM", "PDM_QTDHOR"))
				_nZEVlr		:= TRANSFORM(QRYPDM->PDM_VALOR, PesqPict("PDM", "PDM_VALOR"))
				_cVersao	:= Substr(QRYPDM->PDM_VERSAO,1,2) + ":" + Substr(QRYPDM->PDM_VERSAO,3,2)
				cPerio01	:= "Consultar"
				cPerio02	:= "Consultar"
				cPerio03	:= "Consultar"
				lChkPerio	:= .F.
				_DescPeri	:= ""
				
				DbSelectArea("PD3")
				DbSetOrder(3)		//-- PD3_FILIAL + PD3_CURSO
				If DbSeek(xFilial("PD3") + QRYPDM->PDM_CURSO )
					
					While !PD3->(EOF()) .AND. PD3->PD3_FILIAL == xFilial("PD3") .And. PD3->PD3_CURSO == QRYPDM->PDM_CURSO
					
					    // Se Turma for cancelada nao sai no agendamento
					    IF PD3->PD3_STATUS = 'C'  
					       PD3->(DBSKIP())
					       LOOP
					    ENDIF   
					
						cPerio01 := "Consultar"
						cPerio02 := "Consultar"
						cPerio03 := "Consultar"
						lChkPerio := .F.
						
						_DescPeri := "Presencial"
						If PD3->PD3_CATEG = "1" .OR. PD3->PD3_CATEG = "5"
							If PD3->PD3_CATEG = "5"
								_DescPeri := "Virtual"
							Endif
							
							cDescri := _DescPeri + " T1: " +	Substr(DTOS(PD3->PD3_DTINI),7,2) + " a " + Substr(DTOS(PD3->PD3_DTFIM),7,2) + " (" + PD3->PD3_PERIOD + ")"
							If Left(Dtos(PD3->PD3_DTINI), 6) = Left(Dtos(dDataBase), 4) + mv_par04 	//-- 1 Periodo
								cPerio01 := cDescri
								lChkPerio := .T.
							ElseIf Left(Dtos(PD3->PD3_DTINI), 6) = Left(Dtos(dDataBase), 4) + StrZero(Val(mv_par04) + 1, 2)	//-- 2 Periodo
								cPerio02 := cDescri
								lChkPerio := .T.
							ElseIf Left(Dtos(PD3->PD3_DTINI), 6) = Left(Dtos(dDataBase), 4) + StrZero(Val(mv_par04) + 2, 2) //-- 3 Periodo
								cPerio03 := cDescri
								lChkPerio := .T.
							EndIf

							If lChkPerio
								aRow := {}
								aadd(aRow,{_FGestao,"m49886304","","",""})
								aadd(aRow,{_cNomeCur,"m49886304","","",""})
								aadd(aRow,{_nQtdHr,"s67","","",""})
								aadd(aRow,{_nZEVlr,"s67","","",""})
								aadd(aRow,{_cVersao,"s134","","",""})
								aadd(aRow,{cPerio01,"s67","","",""})
								aadd(aRow,{cPerio02,"s67","","",""})
								aadd(aRow,{cPerio03,"s64","","",""})
								
								aadd(_aMerPla,aRow)
								
								lChkPerio	:= .T.
								PD3->(DbSkip())
								Loop
							Endif
						Endif
						PD3->(DbSkip())
					Enddo
				Endif

				IF !lChkPerio	
					aRow := {}
					aadd(aRow,{_FGestao,"m49886304","","",""})
					aadd(aRow,{_cNomeCur,"m49886304","","",""})
					aadd(aRow,{_nQtdHr,"s67","","",""})
					aadd(aRow,{_nZEVlr,"s67","","",""})
					aadd(aRow,{_cVersao,"s134","","",""})
					aadd(aRow,{cPerio01,"s67","","",""})
					aadd(aRow,{cPerio02,"s67","","",""})
					aadd(aRow,{cPerio03,"s64","","",""})
					
					aadd(_aMerPla,aRow)
				ENDIF
				QRYPDM->(DbSkip())
			Enddo
			
			For _nX	:= 1 To Len(_aMerPla)
				If _nX == 1
					_aMerPla[_nX,1,4]	:= STR(Len(_aMerPla) - 1)
				Else
					_aMerPla[_nX,2,5]	:= "2"
				Endif
			Next
			
			_nCtr	:= 1
			
			For _nX	:= 1 To Len(_aMerPla)
				aRow	:= {}
				For _nY	:= _nCtr To Len(_aMerPla[_nX])
					aadd(aRow,_aMerPla[_nX,_nY])
				Next
				
				AddRow(aRow,18,cModelo,.F.)
				If _nX >= 1
					_nCtr := 2
				Endif
			Next
		Enddo
		CloseSheet()
	Enddo
	QRYPDM->(DbCloseArea())
	
	If nHndXML > 0
		GravaXML('</Workbook>')
		FClose(nHndXML)
		If file(cXML)
			MsgInfo("Arquivo ["+ cXML +"]  criado com sucesso")
	
			If ApOleClient( 'MsExcel' )
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cXML ) // Abre uma planilha
				oExcelApp:SetVisible(.T.)
			Else
				Alert( "Microsoft Excel nao encontrado !" )	 //
			EndIf
		else
			Alert("Erro na criação do arquivo ["+(cXML) +"]" )
		endif
	Else
		alert("Não existe dados para o preenchimento da planilha")
	EndIf

Return Nil

Return
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Geração do cabeçalho do XML

@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function CabecXML()
Local cBufferXML := ""

GravaXML('<?xml version="1.0" encoding="ISO-8859-1" ?>')
GravaXML('<?mso-application progid="Excel.Sheet"?>')
GravaXML('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"')
GravaXML('xmlns:o="urn:schemas-microsoft-com:office:office"')
GravaXML('xmlns:x="urn:schemas-microsoft-com:office:excel"')
GravaXML('xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"')
GravaXML('xmlns:html="http://www.w3.org/TR/REC-html40">')
GravaXML('<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">')
GravaXML('<Author>'+Substr(cusuario,7,15) +'</Author>')
GravaXML('<LastAuthor>'+Substr(cusuario,7,15) +'</LastAuthor>')
GravaXML('<Created>' + substr(dtos(ddatabase),1,4)+'-'+substr(dtos(ddatabase),5,2)+'-'+substr(dtos(ddatabase),7,2)+'-'+Time()+'</Created>')
GravaXML('<Version>12.00</Version>')
GravaXML('</DocumentProperties>')

Return Nil
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Geração das tags de estilos do XML
@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function AddStyles()
Local cBufferXML := ""


GravaXML('<Styles>')

GravaXML('<Style ss:ID="Normal">')
GravaXML('<Alignment ss:Vertical="Center" ss:Horizontal="Center" />')
GravaXML('<Font ss:FontName="Arial" ss:Size="8" ss:Color="#FFFFFF" ss:Bold="1"/>')
GravaXML('<Interior ss:Color="#000080" ss:Pattern="Solid"/>')
GravaXML('</Style>')

GravaXML('<Style ss:ID="s134">')
GravaXML('<Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
GravaXML('<Borders>')
GravaXML('<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"')
GravaXML('ss:Color="#333333"/>')
GravaXML('<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('</Borders>')
GravaXML('<Font ss:FontName="Tahoma" x:Family="Swiss" ss:Size="8" ss:Color="#FFFFFF"')
GravaXML('ss:Bold="1"/>')
GravaXML('<Interior ss:Color="#538ED5" ss:Pattern="Solid"/>')
GravaXML('<NumberFormat ss:Format="@"/>')
GravaXML('<Protection/>')
GravaXML('</Style>')

GravaXML('<Style ss:ID="s64">')
GravaXML('<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
GravaXML('<Borders>')
GravaXML('<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('</Borders>')
GravaXML('<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
GravaXML('<Interior/>')
GravaXML('<NumberFormat/>')
GravaXML('<Protection/>')
GravaXML('</Style>')

GravaXML('<Style ss:ID="s67">')
GravaXML('<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
GravaXML('<Borders>')
GravaXML('<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('</Borders>')
GravaXML('<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
GravaXML('<Interior/>')
GravaXML('<NumberFormat/>')
GravaXML('<Protection/>')
GravaXML('</Style>')

GravaXML('<Style ss:ID="s71">')
GravaXML('<Borders>')
GravaXML('<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('</Borders>')
GravaXML('<Interior ss:Color="#538ED5" ss:Pattern="Solid"/>')
GravaXML('</Style>')

GravaXML('<Style ss:ID="s78">')
GravaXML('<Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>')
GravaXML('<Borders>')
GravaXML('<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('</Borders>')
GravaXML('<Font ss:FontName="Tahoma" x:Family="Swiss" ss:Size="8" ss:Color="#FFFFFF"')
GravaXML('ss:Bold="1"/>')
GravaXML('<Interior ss:Color="#538ED5" ss:Pattern="Solid"/>')
GravaXML('<NumberFormat ss:Format="@"/>')
GravaXML('<Protection/>')
GravaXML('</Style>')

GravaXML('<Style ss:ID="s79">')
GravaXML('<Borders>')
GravaXML('<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('</Borders>')
GravaXML('<Interior ss:Color="#538ED5" ss:Pattern="Solid"/>')
GravaXML('</Style>')

GravaXML('<Style ss:ID="m49886304">')
GravaXML('<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>')
GravaXML('<Borders>')
GravaXML('<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>')
GravaXML('</Borders>')
GravaXML('<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
GravaXML('<Interior/>')
GravaXML('<NumberFormat/>')
GravaXML('<Protection/>')
GravaXML('</Style>')

GravaXML('</Styles>')

Return Nil
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Função de auxilio ao usuario para escolha do diretorio
@author Wagner Mobile Costa
@version P12
@since 06/04/2015
/*/
//-----------------------------------------------------------------------------

User Function fOpenXML()
Local cRet	   := "", cVar := &(ReadVar())
Local cType    := "Arquivos XML | *.XML"
Local nTamanho := 0

cRet := cGetFile(cType,"Informe o arquivo",,cVar,.T.,GETF_OVERWRITEPROMPT+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_LOCALFLOPPY)
nTamanho := Len(cVar)

&(ReadVar()) := Left(cRet + Space(nTamanho), nTamanho)

return .T.

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Criação das abas do arquivo XML

@author Fabio José Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------

Static function SheetProp()

GravaXML('<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
GravaXML('</WorksheetOptions>')

Return Nil

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Retorno do tipo do XML

@author Fabio José Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function XMLType(xValue)
Local cTipo := "String"
Do Case
	Case ValType(xValue) == "C"
		cTipo := "String"
	Case ValType(xValue) == "N"
		cTipo := "Number"
	Case ValType(xValue) == "D"
		cTipo := "DateTime"
EndCase

Return cTipo

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Gravação do XML

@author Fabio José Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function GravaXML(cBuffer)

fWrite(nHndXML,cBuffer+CRLF)

Return Nil

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Abertura das abas 

@author Fabio José Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function NewSheet(cName)
Local cBufferXML := ""

GravaXML('<Worksheet ss:Name="'+cName+'">')
GravaXML('<Table>')

Return Nil
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Fechamento da aba

@author Fabio José Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------

Static Function CloseSheet()
Local cBufferXML := ""

GravaXML('</Table>')
SheetProp()
GravaXML('</Worksheet>')


Return Nil
//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Adiciona cada linha da planilha

@author Fabio José Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------


Static Function AddRow(aRow,nAltura,cModelo,lGraf)
Local cBufferXML := ""
Local _nX
Local cType
Local cStyle := ""

GravaXML('<Row ss:Height="'+Alltrim(Str(nAltura))+'">')


for _nX := 1 to len(aRow)
	If Len(aRow[_nX]) >= 1
		cStyle := ""
		cData  := ""
		cTipo := XMLType(aRow[_nX][1])
		If cTipo == "String" .and. Empty(aRow[_nX][1])
			cData  := ""
		Else
			cData := '<Data ss:Type="'+cTipo+'">'+ValToXML(aRow[_nX][1])+'</Data>'
		Endif
		
		If Len(aRow[_nX]) >= 2
			If !Empty(aRow[_nX][2])
				cStyle += 'ss:StyleID="'+aRow[_nX][2]+'" '
			Endif
		Endif
		
		If Len(aRow[_nX]) >= 3
			If !Empty(aRow[_nX][3])
				cStyle += 'ss:MergeAcross="'+aRow[_nX][3]+'" '
			Endif
		Endif
		
		If Len(aRow[_nX]) >= 4
			If !Empty(aRow[_nX][4])
				cStyle += 'ss:MergeDown="'+Alltrim(aRow[_nX][4])+'" '
			Endif
		Endif
		
		If Len(aRow[_nX]) >= 5
			If !Empty(aRow[_nX][5])
				cStyle += 'ss:Index="'+aRow[_nX][5]+'" '
			Endif
		Endif
		
		If Len(aRow[_nX]) >= 6
			If !Empty(aRow[_nX][6])
				cStyle += 'ss:HRef="#'+"'"+aRow[_nX][6]+"'"+'!A1" '
			Endif
		Endif
		
		GravaXML('<Cell '+cStyle+'>'+cData+'</Cell>')
	Endif
Next
GravaXML('</Row>')

Return Nil

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Transforma o valor para uma string para uma geração do XML

@author Fabio José Batista
@version P12
@since 24/04/2015
/*/
//-----------------------------------------------------------------------------


Static Function ValToXML(xValue)
Do Case
	Case ValType(xValue) == "C"
		xValue := AllTrim(xValue)
	Case ValType(xValue) == "N"
		xValue := Alltrim(Str(xValue))
	Case ValType(xValue) == "D"
		xValue := DTOS(xValue)
		xValue := Left(xValue,4)+"-"+Substr(xValue,5,2)+"-"+Right(xValue,2)
	Case ValType(xValue) == "U"
		xValue := ""
EndCase

Return xValue