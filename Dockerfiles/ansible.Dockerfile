FROM 	dovry/dev_env:baseimage
LABEL 	maintainer		"dovry"
LABEL 	description		"Ansible dockerfile built on a base image"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"
ENV		ansi_dir		"${user_dir}/.ansible"
ENV 	ANSI_FOLDERS	"facts files inventory playbooks plugins roles inventory/group_vars inventory/host_vars"
ENV 	ANSI_FILES	 	"inventory/hosts hosts ansible.cfg"

# NEW PKGS
SHELL ["/bin/sh", "-c"]
USER root

RUN apk add --no-cache ansible

# END NEW PKGS
SHELL ["/bin/zsh","-c"]
USER ${user_name}

# BEGIN CONFIG
WORKDIR ${ansi_dir}

RUN \
   ansible localhost -m ansible.builtin.file 	-a 'path=${ansi_dir}/facts/.dummyfile state=touch' \
&& ansible localhost -m ansible.builtin.file 	-a 'path=${ansi_dir}/inventory/hosts state=touch' \
&& ansible localhost -m ansible.builtin.file 	-a 'src=/home/docker/.ansible dest=/home/docker/ansible state=link' \
&& ansible localhost -m ansible.builtin.get_url -a 'url=https://tinyurl.com/ansiblecfg dest=${ansi_dir}/ansible.cfg mode=740'

# END CONFIG

WORKDIR ${user_dir}

HEALTHCHECK \
	--interval=30s \
	--timeout=5s \
	--start-period=5s \
	--retries=3 CMD [ "command -v ansible" ]

ENTRYPOINT ["tail", "-f", "/dev/null"]