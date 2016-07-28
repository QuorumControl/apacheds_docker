FROM java:8-jdk

RUN apt-get update \
    && apt-get install -y xinetd ldap-utils curl jq gettext wget

ENV APACHEDS_VERSION 2.0.0-M23

RUN wget -O /tmp/installer.deb https://www.apache.org/dist/directory/apacheds/dist/$APACHEDS_VERSION/apacheds-$APACHEDS_VERSION-amd64.deb \
    && dpkg -i /tmp/installer.deb && rm /tmp/installer.deb \
    && mkdir /templates \
    && mkdir /ldifs

COPY files/health_check.sh /root/health_check.sh
COPY files/healthchk /etc/xinetd.d/healthchk
COPY ldifs/* /ldifs/

RUN echo 'healthchk      11001/tcp' >> /etc/services

EXPOSE 10389 10636 11001

COPY templates/* /templates/

COPY scripts/* /root/

RUN chmod +x /root/*.sh

ENV DOMAIN_NAME="effedil" DOMAIN_SUFFIX="it" ACCESS_CONTROL_ENABLED="true" ACTIVEMQ_ENABLED="true"

CMD ["/root/start.sh"]
