FROM 	dovry/dev_env:baseimage
LABEL 	maintainer		"dovry"
LABEL 	description		"Ansible dockerfile built on a base image"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"
ENV		ansi_dir		"${user_dir}/.ansible"
ENV 	ANSIBLE_FOLDERS	"facts files inventory playbooks plugins roles inventory/group_vars inventory/host_vars"

# NEW PKGS
SHELL ["/bin/sh", "-c"]
USER root

RUN apk add --no-cache build-base py3-cffi

# END NEW PKGS

SHELL ["/bin/zsh","-c"]
USER ${user_name}

RUN pip3 install ansible

# BEGIN CONFIG
WORKDIR ${ansi_dir}

#RUN \
#	ansible localhost -m ansible.builtin.file 	-a 'path=${ansi_dir}/inventory/hosts state=touch' \
#&& 	
#&& 	ansible localhost -m ansible.builtin.get_url -a 'url=https://tinyurl.com/ansiblecfg dest=${ansi_dir}/ansible.cfg mode=740'

RUN ansible localhost -m ansible.builtin.file 	-a 'src=${ansi_dir} dest=/home/docker/ansible state=link' \
&& for folder in ${ANSIBLE_FOLDERS}; do mkdir -p ${ansi_dir}/$folder; done

#mkdir -p ${ansi_dir}/inventory

# END CONFIG

WORKDIR ${user_dir}

HEALTHCHECK \
	--interval=30s \
	--timeout=5s \
	--start-period=5s \
	--retries=3 CMD [ "command -v ansible" ]

SHELL ["/bin/zsh"]

ENTRYPOINT ["/bin/zsh"]