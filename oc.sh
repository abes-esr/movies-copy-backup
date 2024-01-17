#!/bin/sh

case $1 in
    dumper)
        export DUMPER=$(oc get pods -o json | jq -r '.items[].metadata|select(.name|test("dumper")).name')
        oc exec $DUMPER -- restore $(ls -t /backup_racine/prod/*.gz | head -n1) $DB_TYPE $DB_HOST $DB_NAME $DB_USER $DB_PASS 3306 >/dev
        ;;
    wdqs-jnl)
        export WDQS=$(oc get pods -o json | jq -r '.items[].metadata|select((.name|test("wdqs")) and (.name|test("frontend|proxy|updater")|not)).name')
        oc exec $WDQS -- sh -c 'rm -f data/data.jnl' >/dev/null 2>&1
        ;;
    wdqs-run)
        export WDQS=$(oc get pods -o json | jq -r '.items[].metadata|select((.name|test("wdqs")) and (.name|test("frontend|proxy|updater")|not)).name')
        oc exec $WDQS -- bash -c '/wdqs/runUpdate.sh -h http://$WDQS_HOST:$WDQS_PORT -- --wikibaseUrl $WIKIBASE_SCHEME://$WIKIBASE_HOST --conceptUri $WIKIBASE_SCHEME://$WIKIBASE_HOST --entityNamespaces ${WDQS_ENTITY_NAMESPACES} -s 20200501000000' | tee logfile | awk '1;/Got no real changes/{exit}' 
        ;;
    all)
        export DUMPER=$(oc get pods -o json | jq -r '.items[].metadata|select(.name|test("dumper")).name')
        export WDQS=$(oc get pods -o json | jq -r '.items[].metadata|select((.name|test("wdqs")) and (.name|test("frontend|proxy|updater")|not)).name')
        oc exec $DUMPER -- restore $(ls -t /backup_racine/prod/*.gz | head -n1) $DB_TYPE $DB_HOST $DB_NAME $DB_USER $DB_PASS 3306 >/dev
        oc exec $WDQS -- sh -c 'rm -f data/data.jnl' >/dev/null 2>&1
        oc exec $WDQS -- bash -c '/wdqs/runUpdate.sh -h http://$WDQS_HOST:$WDQS_PORT -- --wikibaseUrl $WIKIBASE_SCHEME://$WIKIBASE_HOST --conceptUri $WIKIBASE_SCHEME://$WIKIBASE_HOST --entityNamespaces ${WDQS_ENTITY_NAMESPACES} -s 20200501000000' | tee logfile | awk '1;/Got no real changes/{exit}' 
        ;;
esac
