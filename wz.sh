NOTIFY_HOSTNAME=S-DBORA12
NOTIFY_HOSTALIAS="Banco de Dados Oracle 19C - Abacate ERP"
NOTIFY_HOSTADDRESS=192.168.0.1
NOTIFY_SERVICESTATE=CRIT
NOTIFY_SERVICEDISPLAYNAME=Memory
TESTMESSAGE="Plain text message, sent with the Evolution-API 🚀.\n\nHere you can send texts in bold, italic, strikethrough and monospaced.\n\nYou can also use any available emoticon on WhatsApp, like these examples below:\n\n😉🤣🤩 🤝👏👍🙏"


#WHATSAPPNUMBERORGROUPID
WZID=
#WZID=

MODE=notset

#Functions
notset() {
echo Missing Argument, use testup or testdown for testing.
exit 0
}

preparemessage() {
if [[ "$NOTIFY_WHAT" = HOST ]]
then
#MESSAGE=$(echo Tipo de Alerta: $NOTIFY_WHAT "\n\n" Servidor: *$NOTIFY_HOSTNAME $NOTIFY_HOSTADDRESS* "\n" Descrição: $NOTIFY_HOSTALIAS  "\n" Endereço IP: $NOTIFY_HOSTADDRESS "\n\n" )
MESSAGE=$(echo $TESTMESSAGE)
fi

if [[ "$NOTIFY_WHAT" = SERVICE ]]
then
#MESSAGE=$(echo Tipo de Alerta: $NOTIFY_WHAT "\n\n" Servidor: *$NOTIFY_HOSTNAME* "\n" Descrição: $NOTIFY_HOSTALIAS  "\n" Endereço IP: $NOTIFY_HOSTADDRESS "\n\n" Componente Afetado: $NOTIFY_SERVICEDISPLAYNAME "\n\n" )
MESSAGE=$(echo $TESTMESSAGE)
fi
}
#MESSAGE=$(echo Tipo de Alerta: $NOTIFY_WHAT "\n\n" Servidor: $NOTIFY_HOSTNAME "\n\n" Descrição  "\n\n" Endereço IP: $NOTIFY_HOSTADDRESS "\n\n" Componente Afetado: $NOTIFY_SERVICEDISPLAYNAME "\n\n" )

sendmessage() {
curl --request POST \
--url "" \
--header "accept: application/json" \
--header "Content-Type: Application/json" \
--header "apiKey: 5dc6064eb1f022588f0717eac9e55938" \
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
}

#Translate
if [[ "$NOTIFY_HOSTSTATE" = DOWN ]]
then
NOTIFY_HOSTSTATE=Indisponivel
fi

if [[ "$NOTIFY_HOSTSTATE" = UP ]]
then
NOTIFY_HOSTSTATE=Disponivel
fi


#LOGIC

if [[ "$1" = testdown ]]
then
MODE=$1
NOTIFY_HOSTSTATE=DOWN
NOTIFY_WHAT=HOST
preparemessage
sendmessage
fi

if [[ "$1" = testup ]]
then
MODE=$1
NOTIFY_HOSTSTATE=UP
NOTIFY_WHAT=HOST
preparemessage
sendmessage
fi

if [[ "$MODE" = notset ]]
then
notset
fi

#DEBUG
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
echo
echo Message: $MESSAGE
