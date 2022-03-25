FROM 	dovry/dev_env:baseimage
LABEL 	maintainer		"dovry"
LABEL 	description		"Ansible dockerfile built on a base image"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"

USER root
# NEW CONTAINER CONFIG


RUN apk add --no-cache ansible

# END CONTAINER CONFIG
USER 	${user_name}
WORKDIR ${user_dir}

RUN ln -s ${user_dir}/.ansible ${user_dir}/ansible

HEALTHCHECK \
	--interval=30s \
	--timeout=5s \
	--start-period=5s \
	--retries=3 CMD [ "command -v ansible" ]

ENTRYPOINT ["tail", "-f", "/dev/null"]