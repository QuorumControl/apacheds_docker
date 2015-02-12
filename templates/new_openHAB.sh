#!/bin/bash

#HTPWD=`which htpasswd | wc -l`

#if [ $HTPWD -lt 1 ];
#    then 
#     echo htpasswd not found. try: 'sudo apt-get install apache2-utils';
#     exit 1;
#fi

if [[ $# -ne 2 ]]; 
    then 
     echo Usage: $0 '<new-OpenHab-ID> <new-password>';
     exit 1;
fi

PWD_LENGTH=${#2}
if [ $PWD_LENGTH -lt 5 ];
   then 
   echo 'Error: Password must be at least 5 characters long';
   exit 2;
fi

# plaintext OK
PASSWORD=$2
# SHA OK
#PASSWORD=`htpasswd -nbs $1 $2 | awk -F: {'print $2'} `

rm -rf $1
mkdir $1
cd $1

cat /templates/oh-user.ldif | sed "s@<OHID>@$1@" > /tmp/oh-user.ldif
cat /tmp/oh-user.ldif | sed "s@<ldapPWD>@$PASSWORD@" > /tmp/oh-user_p.ldif
cat /templates/add-oh-user-to-users-group.ldif | sed "s@<OHID>@$1@" > /tmp/add-oh-user-to-users-group.ldif
cat /templates/oh-auth.ldif | sed "s@<OHID>@$1@" > /tmp/oh-auth.ldif

export LDAP_HOST="localhost"
export LDAP_PORT=10389
export LDAP_BIND="cn=mqbroker,ou=Services,dc=${DOMAIN_NAME},dc=${DOMAIN_SUFFIX}"
#export LDAP_PWD="sunflower"

LDAPCMD="ldapmodify -h $LDAP_HOST -p $LDAP_PORT -D $LDAP_BIND -W"

$LDAPCMD -a -f /tmp/oh-user_p.ldif
$LDAPCMD -f /tmp/add-oh-user-to-users-group.ldif
$LDAPCMD -a -f /tmp/oh-auth.ldif

rm /tmp/oh-user*.ldif /tmp/add-oh-user-to-users-group.ldif /tmp/oh-auth.ldif

cd -
