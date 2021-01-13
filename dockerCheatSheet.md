# Error response from daemon: Get https://b2bi-docker.lab.buch.axway.int/v2/: x509: certificate signed by unknown authority
fix: openssl s_client -showcerts -connect registry_host:registry_port < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/docker/certs.d/<registry_address>/ca.crt
