Configuração INI App Server Pesquisa de Satisfação

[#CICLO3]
SourcePath=D:\TOTVS\Apo_25\8046_PORTAL_CTT
RootPath=D:\TOTVS\Protheus_Data
CtreeRootPath=D:\TOTVS\Protheus_Data
StartPath=\system\
x2_path=
RpoDb=top
RpoLanguage=portuguese
RpoVersion=120
LocalFiles=ctree
Trace=0
localdbextension=.dtc
PictFormat=DEFAULT
DateFormat=DEFAULT
SpecialKey=#CICLO3
MultPROFILE=1
HelpServer=interno.totvs.com/mktfiles/tdiportais/helponlineprotheus/p12/
TOPMEMOMEGA=1
Theme=Sunset
FWTRACELOG=1
MIGTOTVSV12=1

[TOPCONNECT]
DataBase=ORACLE
Server=172.24.50.16
Alias=PRJUPDT12
ProtheusOnly=0
Port=7901

[DRIVERS]
Active=TCP
multiprotocolportsecure=0

[TCP]
Type=TCPIP
Port=7066
;secureconnection=0

[GENERAL]
InstallPath=D:\TOTVS
ConsoleLog=1
ConsoleFile=D:\TOTVS\LOGS\.PROTHEUS25_7066.LOG
Consolelogsize=10000
CtreeMode=SERVER
CtreePreImg=1
CheckSpecialKey=0
Segmento=pZFVvWym
Serie===AV
MaxQuerySize=31960
;ServerMemoryLimit=1024
DebugThreadUsedMemory=1
ServerMemoryInfo=1
ASyncConsoleLog=0
maxStringSize=50 

[CTREESERVER]
Ctservername=FAIRCOMS@172.24.50.16

[CTREESERVERMASTER]
WaitForNotification=180 
Ctservername=FAIRCOMS@172.24.50.16
ENVIRONMENTS=#CICLO3
Files=SX2000,SX3000,SX6000,SX7000,SXA000,SXB000,SXD000,SIX000

[LICENSECLIENT] 
Server=172.24.50.16
Port=10506

[SSLConfigure]
Verbose = 1
SSL2    = 1
SSL3    = 1
TLS1_0  = 1
TLS1_1  = 1
TLS1_2  = 1
Bugs    = 0
State   = 1

[SERVICE]
Name=.PROTHEUS25_8046_PORTAL_CTT
DisplayName=.PROTHEUS25_8046_PORTAL_CTT

[TDS]
ALLOWAPPLYPATCH=*
ALLOWEDIT=*

[MAIL]
PROTOCOL=POP3
TLSVERSION=1
SSLVERSION=3
TRYPROTOCOLS=0
AUTHLOGIN=1
AUTHPLAIN=1
AUTHNTLM=1

[ONSTART]
JOBS=JOB_PESQUISA_0001
RefreshRate=120

[JOB_PESQUISA_0001]
TYPE=WEBEX
Environment=#CICLO3
INSTANCES=10,20,3,3
SIGAWEB=PP
INSTANCENAME=pp
ONSTART=STARTWEBEX
ONCONNECT=CONNECTWEBEX
ONEXIT=FINISHWEBEX
WEBSERVICELOCATION=http://172.24.50.16:8042
PREPAREIN=00,00001000100

[pesquisasatisfacaoctt_dev.cp.totvs.com.br:8046]
ENABLE=1
PATH=D:\TOTVS\Protheus_Data\web\portal
Environment=TREINAMENTO
INSTANCENAME=portal
RESPONSEJOB=JOB_PESQUISA_0001
DEFAULTPAGE=U_TCTTH010.apw

[pesquisasatisfacaoctt_dev]
ENABLE=1
PATH=D:\TOTVS\Protheus_Data\web\portal
Environment=TREINAMENTO
INSTANCENAME=portal
RESPONSEJOB=JOB_PESQUISA_0001
DEFAULTPAGE=U_TCTTH010.apw

[172.24.50.16:8046]
ENABLE=1
PATH=D:\TOTVS\Protheus_Data\web\portal
Environment=TREINAMENTO
INSTANCENAME=portal
RESPONSEJOB=JOB_PESQUISA_0001
DEFAULTPAGE=U_TCTTH010.apw

[HTTP]
ENABLE=1
PORT=8046
