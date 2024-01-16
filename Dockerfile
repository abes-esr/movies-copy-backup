FROM frolvlad/alpine-glibc:latest as movies-copy-backup-image
RUN wget -q https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-02-18-033438/openshift-client-linux-4.12.0-0.okd-2023-02-18-033438.tar.gz -O /usr/local/bin/openshift-client-linux-4.12.0-0.okd-2023-02-18-033438.tar.gz
RUN cd /usr/local/bin && tar xvzf openshift-client-linux-4.12.0-0.okd-2023-02-18-033438.tar.gz && chmod +x oc && chmod +x kubectl
RUN rm -f openshift-client-linux-4.12.0-0.okd-2023-02-18-033438.tar.gz
RUN apk add --update ca-certificates

ENV TZ="Europe/Paris"
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
