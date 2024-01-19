# movies-copy-backup
Image Docker qui sert à copier un backup d'une instance, vers une autre instance de Wikibase.

Cette image est utilisée par le projet Movies : https://github.com/abes-esr/movies-docker  
A voir, notamment pour les variables d'environnement utilisées par cette image.

La commande oc.sh est utilisée par le entrypoint après avoir défini le namespace par la variale $PROJECT.
Au démarrage du container, le script oc.sh copie uniquement les actions à amener via le sous-script oc_cron.sh dans la crontab
Une fois le container lancé, il est possible d'appeler le script oc.sh afin de procéder à une restauration immédiate ("now") de la base mysql et de la génération de la base triplestore via la commande:

/oc.sh <project_name> <dumper|wdqs-jnl|wdqs-run|all> now

On peut lancer chacun des jobs individuellement toujours avec l'argument "now"
