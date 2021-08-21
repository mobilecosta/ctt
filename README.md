Fontes e Docs Projeto CTT

a) Api TOKEN
curl --location --request POST 'https://apimqa.totvs.com.br/api-homologacao/token' \
--header 'Authorization: Basic TVBrRVE1ZFJHZzFkSkxHcTlDM05mSFQxa21nYTpHSFBFamZwaXJYbEVvTjBmbWRndGhqaUk3ZWth' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-raw 'grant_type=client_credentials'

Fonte API
TCTTS001.PRW

Orientações para consumir o json modelo da pasta Resource

1) Instalar o json server
npm install -g json-server

2) Subir
json-server --watch ctt.json

Para consumir use localhost:3000/aAluno ou localhost:3000/aCursos

a) Metodos do Projeto:
![image](https://user-images.githubusercontent.com/20256620/130312057-d03f1827-6ecd-4765-ae22-05f6df194c48.png)

