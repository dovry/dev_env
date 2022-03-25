FROM 	dovry/dev_env:baseimage
LABEL 	maintainer		"dovry"
LABEL 	description		"Ansible dockerfile built on a base image"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"
ENV		ansi_dir		"${user_dir}/.ansible"
ENV		ansi_folders	"facts,files,inventory,playbooks,roles"

USER root
# ADD PACKAGES HERE


RUN apk add --no-cache ansible

# END PACKAGES HERE
USER 	${user_name}
WORKDIR ${user_dir}

RUN mkdir ${ansi_dir}/{${ansi_folders}} \
	&& wget -O ${ansi_dir}/ansible.cfg https://tinyurl.com/ansiblecfg \
	&& ln -s ${ansi_dir} ${user_dir}/ansible \
	&& echo "localhost" > ${ansi_dir}/inventory/hosts

HEALTHCHECK \
	--interval=30s \
	--timeout=5s \
	--start-period=5s \
	--retries=3 CMD [ "command -v ansible" ]

ENTRYPOINT ["tail", "-f", "/dev/null"]