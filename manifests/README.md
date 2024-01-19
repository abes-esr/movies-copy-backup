KUBECONFIG is the env for kubernetes config file.
The most simple way to create an encoded password into a secret is to create it from a file with this command:

 oc create secret kubeconfig --from-env-file=kubeconfig
