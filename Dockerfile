FROM alpine:latest as movies-copy-backup-image
RUN apk add --no-cache --update docker openrc
RUN rc-update add docker boot
RUN echo "3    0       *       *       *       docker exec  movies-db-dumper sh -c 'restore "'$(ls -t /backup/prod/*.gz | head -n1) $DB_TYPE $DB_HOST $DB_NAME $DB_USER $DB_PASS 3306'"' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
RUN echo "4    0       *       *       *       docker exec  movies-wikibase-wdqs sh -c 'rm -f data/data.jnl' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
RUN echo "5    0       *       *       *       docker restart movies-wikibase-wdqs >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
RUN echo "6    0       *       *       *       docker exec  movies-wikibase-wdqs bash -c '/wdqs/runUpdate.sh "'-h http://$WDQS_HOST:$WDQS_PORT -- --wikibaseUrl $WIKIBASE_SCHEME://$WIKIBASE_HOST --conceptUri $WIKIBASE_SCHEME://$WIKIBASE_HOST --entityNamespaces ${WDQS_ENTITY_NAMESPACES} -s 20200501000000'"'" "| tee logfile | awk '1;/Got no real changes/{exit}'"" " >> /var/spool/cron/crontabs/root
#RUN echo "8    0       *       *       *       docker start movies-wikibase-wdqs-updater >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
#RUN echo "6    0       *       *       *       docker restart movies-wikibase-wdqs-updater >/dev/null 2>&1" >> /var/spool/cron/crontabs/root

RUN apk add --no-cache --update tzdata
ENV TZ="Europe/Paris"
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
