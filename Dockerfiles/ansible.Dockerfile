FROM 	dovry/dev_env:baseimage
LABEL 	maintainer		"dovry"
LABEL 	description		"Runs Ansible"
ENV		ansi_dir		"/root/.ansible"

# install ansible
RUN apk add --no-cache ansible

# copy Ansible configuration
COPY \
Dockerfiles/.conf/ansible-setup.yml \
Dockerfiles/.conf/ansible.cfg \
${ansi_dir}/

# Use Ansible to configure itself
RUN ANSIBLE_DEPRECATION_WARNINGS=false ansible-playbook -l localhost ${ansi_dir}/ansible-setup.yml

HEALTHCHECK \
	--interval=30s \
	--timeout=30s \
	--start-period=5s \
	--retries=3 CMD [ "$(which ansible) --version" ]

ENTRYPOINT [ "/bin/zsh" ]