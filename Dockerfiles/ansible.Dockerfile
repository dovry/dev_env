FROM 	alpine:latest
LABEL 	maintainer		"dovry"
LABEL 	description		"Ansible dockerfile built on my base image"

RUN apk add --no-cache \
	apk add ansible

HEALTHCHECK \
	--interval=30s \
	--timeout=30s \
	--start-period=5s \
	--retries=3 CMD [ "ansible --version" ]
