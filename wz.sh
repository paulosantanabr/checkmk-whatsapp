#!/bin/bash
# WhatsApp Evolution - v8

WZAPIKEY=
WZID=
WZURL=

testmode() {
NOTIFY_HOSTNAME=S-DBORA12
NOTIFY_HOSTALIAS="Banco de Dados Oracle 19C - Abacate ERP"
NOTIFY_HOSTADDRESS=192.168.0.1
NOTIFY_SERVICESTATE=CRIT
NOTIFY_SERVICEDISPLAYNAME=Memory
NOTIFY_SERVICEDESC=Memory
NOTIFY_SERVICEOUTPUT="Total virtual memory: 18.28% - 652 MiB of 3.48 GiB, Shared memory: 29.89% - 1.04 GiB of 3.48 GiB RAM (warn/crit at 20.00%/30.00% used)WARN, 7 additional details available"
TESTMESSAGE="Plain text message, sent with the Evolution-API 🚀.\n\nHere you can send texts in bold, italic, strikethrough and monospaced.\n\nYou can also use any available emoticon on WhatsApp, like these examples below:\n\n😉🤣🤩 🤝👏👍🙏"
OMD_SITE="monitoring"
CHECKMK_URL="https://teste.com"
NOTIFY_HOSTURL="/check_mk/index.py?start_url=view.py?view_name%3Dhoststatus%26host%3D$NOTIFY_HOSTNAME%26site%3D$OMD_SITE"
echo
echo Parameter: "$1"
echo Host State: $NOTIFY_HOSTSTATE
echo Type of Message: $NOTIFY_WHAT
echo Host name: $NOTIFY_HOSTNAME
echo Alias: $NOTIFY_HOSTALIAS
echo Host Address: $NOTIFY_HOSTADDRESS
echo
echo Service State: $NOTIFY_SERVICESTATE
echo Service Display Name: $NOTIFY_SERVICEDISPLAYNAME
echo Service Description: $SERVICE_DESC
echo
echo Message: $MESSAGE
}

CHECKMK_URL=$(echo $CHECKMKURL$NOTIFY_SERVICEURL$NOTIFY_HOSTURL)

#Functions
notset() {
echo Missing Argument, use testup or testdown for host notification testserviceok, testservicewarn or testservicecrit for service notification.
exit 0
}

preparemessage() {
if [[ "$NOTIFY_WHAT" = HOST ]]
then
MESSAGE=$(echo Servidor: *$NOTIFY_HOSTNAME* "\n"Endereço IP: *$NOTIFY_HOSTADDRESS* "\n"Descrição: *$NOTIFY_HOSTALIAS* "\n\n"📌 Informações Adicionais: "\n\n"Tipo de Evento: $NOTIFY_HOSTSTATE)
#MESSAGE=$(echo $TESTMESSAGE)
fi

if [[ "$NOTIFY_WHAT" = SERVICE ]]
then
MESSAGE=$(echo Servidor: *$NOTIFY_HOSTNAME* "\n"Endereço IP: *$NOTIFY_HOSTADDRESS* "\n"Descrição: *$NOTIFY_HOSTALIAS* "\n\n"📌 Informações Adicionais: "\n\n"Tipo de Evento: $NOTIFY_SERVICESTATE "\n"Componente Afetado: *$NOTIFY_SERVICEDESC*  "\n"Detalhes: *$NOTIFY_SERVICEOUTPUT*)
#MESSAGE=$(echo $TESTMESSAGE)
fi
}
#MESSAGE=$(echo Tipo de Alerta: $NOTIFY_WHAT "\n\n" Servidor: $NOTIFY_HOSTNAME "\n\n" Descrição  "\n\n" Endereço IP: $NOTIFY_HOSTADDRESS "\n\n" Componente Afetado: $NOTIFY_SERVICEDISPLAYNAME "\n\n" )

sendmessage() {
curl --request POST \
--url "$WZURL" \
--header "accept: application/json" \
--header "Content-Type: Application/json" \
--header "apiKey: $WZAPIKEY" \
--data '{
  "number":  "'"$WZID"'",
  "options": {
    "delay": 1200,
    "presence": "composing"
  },
  "textMessage": {
    "text": "'"$MESSAGE"'"
  }
}
'
exit
}

#Translate
translatemessage() {
if [[ "$NOTIFY_HOSTSTATE" = DOWN ]]
then
NOTIFY_HOSTSTATE="*🟥 - Indisponibilidade*"
fi

if [[ "$NOTIFY_HOSTSTATE" = UP ]]
then
NOTIFY_HOSTSTATE="*🟩 - Disponibilidade*"
fi

if [[ "$NOTIFY_SERVICESTATE" = OK ]]
then
NOTIFY_SERVICESTATE="*🟢 - Saudavel*"
fi

if [[ "$NOTIFY_SERVICESTATE" = WARNING ]]
then
NOTIFY_SERVICESTATE="*🟡 - Alarmante*"
fi

if [[ "$NOTIFY_SERVICESTATE" = CRITICAL ]]
then
NOTIFY_SERVICESTATE="*🔴 - Critico*"
fi

if [[ "$NOTIFY_SERVICESTATE" = UNKNOWN ]]
then
NOTIFY_SERVICESTATE="*🟣 - Desconhecido*"
fi
}


#LOGIC

if [[ "$1" = testdown ]]
then
MODE=$1
NOTIFY_HOSTSTATE=DOWN
NOTIFY_WHAT=HOST
testmode
translatemessage
preparemessage
sendmessage
fi

if [[ "$1" = testup ]]
then
MODE=$1
NOTIFY_HOSTSTATE=UP
NOTIFY_WHAT=HOST
testmode
translatemessage
preparemessage
sendmessage
fi

if [[ "$1" = testservicecrit ]]
then
MODE=$1
NOTIFY_SERVICESTATE=CRIT
NOTIFY_WHAT=SERVICE
testmode
translatemessage
preparemessage
sendmessage
fi

if [[ "$1" = testservicewarn ]]
then
MODE=$1
NOTIFY_SERVICESTATE=WARN
NOTIFY_WHAT=SERVICE
testmode
translatemessage
preparemessage
sendmessage
fi

if [[ "$1" = testserviceok ]]
then
MODE=$1
NOTIFY_SERVICESTATE=OK
NOTIFY_WHAT=SERVICE
testmode
translatemessage
preparemessage
sendmessage
fi

if [[ -z "$NOTIFY_HOSTNAME" ]]
then
notset
fi

translatemessage
preparemessage
sendmessage

