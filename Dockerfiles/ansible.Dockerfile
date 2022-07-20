FROM 	dovry/dev_env:baseimage
LABEL 	maintainer		"dovry"
LABEL 	description		"Runs Ansible"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"
ENV 	ansi_dir		"${user_dir}/.ansible"

SHELL ["/bin/sh", "-c"]
USER root
# NEW CONTAINER CONFIG

# install python3 + pip3 + ansible
RUN \ 
apk add --no-cache --quiet python3 py3-pip \
&& rm -rf /var/cache/apk/*

SHELL ["/bin/zsh", "-c"]
USER ${user_name}
WORKDIR ${ansi_dir}

RUN \
pip3 install ansible \
&& ln -s ${user_dir}/.ansible ${user_dir}/ansible


# copy Ansible configuration
COPY \
Dockerfiles/.conf/ansible-setup.yml \
Dockerfiles/.conf/ansible.cfg \
${ansi_dir}/

# Use Ansible to configure itself (idempotency check with 'repeat' zsh command)
# https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html ctrl+f 'repeat'
RUN repeat 2 ansible-playbook ${ansi_dir}/ansible-setup.yml

HEALTHCHECK \
	--interval=30s \
	--timeout=30s \
	--start-period=5s \
	--retries=3 CMD [ "$(which ansible) --version" ]