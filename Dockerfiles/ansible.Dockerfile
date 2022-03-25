FROM 	dovry/dev_env:baseimage
LABEL 	maintainer		"dovry"
LABEL 	description		"Ansible dockerfile built on a base image"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"
ENV		ansi_dir		"${user_dir}/.ansible"


# NEW PKGS
SHELL ["/bin/sh", "-c"]
USER root

RUN apk add --no-cache ansible


# END NEW PKGS
SHELL ["/bin/zsh","-c"]
USER ${user_name}

# BEGIN CONFIG
WORKDIR ${ansi_dir}

RUN mkdir -p ${ansi_dir}/{facts,files,inventory,playbooks,roles}
RUN wget -O ansible.cfg https://tinyurl.com/ansiblecfg
RUN ln -s ${ansi_dir} ${user_dir}/ansible
RUN echo "localhost" > ${ansi_dir}/inventory/hosts

# END CONFIG

HEALTHCHECK \
	--interval=30s \
	--timeout=5s \
	--start-period=5s \
	--retries=3 CMD [ "command -v ansible" ]

ENTRYPOINT ["tail", "-f", "/dev/null"]