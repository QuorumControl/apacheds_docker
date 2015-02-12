apacheds_docker
===============

[ApacheDS Homepage](http://directory.apache.org/apacheds/)

This project run ApacheDS in a docker container with an Oracle Java 7 environment. 


##How to use this image
Currently this image uses various environment variables to properly startup, you need to expose ports to your local machine to connect using [Apache Directory Studio](http://directory.apache.org/studio/)

* `-p 10389:10389`  (unencrypted or StartTLS)
* `-p 10636:10636`  (SSL)

##Example with boot2docker

1. `docker run --name apacheds -d -p 10389:10389 effedil/apacheds-docker`
2. Start Apache Directory Studio 
3. In the bottom left corner there is a section called "Connections" Click on the "LDAP" icon to add a connection to your container. 
4. Hostname: `192.168.59.103` and Port: `10389`
5. Click "Next"
6. Bind DN or user: `uid=admin,ou=system` Bind password: `secret` (Default ApacheDS password)
7. Click "Finish"

##Configurations

* Configure main domain

use DOMAIN_NAME and DOMAIN_SUFFIX to define the default domain:
```
DOMAIN_NAME=effedil
DOMAIN_SUFFIX=it
```
* Change main admin password

you can change the default admin password 'secret' passing the variable ADMIN_PASSWORD
```
ADMIN_PASSWORD=mypassword
```
* Enable ActiveMQ Access Control Entries

you can enable ActiveMQ to use this ApacheDS instance as Authentication-Authorization service
``` 
ACTIVEMQ_ENABLED=1
```
Once enabled the Broker will authenticate using cn=mqbroker,ou=Services,dc=${DOMAIN_NAME},dc=${DOMAIN_SUFFIX} 
(password defaults to 'sunflower')

In addition an 'admin' user will be created under ou=User,ou=ActiveMQ,dc=${DOMAIN_NAME},dc=${DOMAIN_SUFFIX}
this ActiveMQ user will have all administration permissions for Topics and Queues.
(password defaults to 'sunflower')

