FROM alpine:latest as movies-copy-backup-image
RUN wget -q https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-02-18-033438/openshift-client-linux-4.12.0-0.okd-2023-02-18-033438.tar.gz -O /usr/local/bin/op
enshift-client-linux-4.12.0-0.okd-2023-02-18-033438.tar.gz
RUN cd /usr/local/bin && tar xvzf openshift-client-linux-4.12.0-0.okd-2023-02-18-033438.tar.gz && chmod +x {kubectl,oc}
RUN echo "3    0       *       *       *       oc exec movies-db-dumper sh -c 'restore "'$(ls -t /backup_racine/prod/*.gz | head -n1) $DB_TYPE $DB_HOST $DB_NAME $DB_USER $DB_PASS 3306'"' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
RUN echo "4    0       *       *       *       oc exec  movies-wikibase-wdqs sh -c 'rm -f data/data.jnl' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
RUN echo "5    0       *       *       *       oc exec  movies-wikibase-wdqs bash -c '/wdqs/runUpdate.sh "'-h http://$WDQS_HOST:$WDQS_PORT -- --wikibaseUrl $WIKIBASE_SCHEME://$WIKIBASE_HOST --conceptUri $WIKIBASE_SCHEME://$WIKIBASE_HOST --entityNamespaces ${WDQS_ENTITY_NAMESPACES} -s 20200501000000'"'" "| tee logfile | awk '1;/Got no real changes/{exit}'"" " >> /var/spool/cron/crontabs/root

ENV TZ="Europe/Paris"
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
