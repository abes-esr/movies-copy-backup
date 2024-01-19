KUBECONFIG is the env for kubernetes config file.
The most simple way to create an encoded passord is to create it from a file with command:

 oc create secret kubeconfig --from-env-file=kuconfig.txt
