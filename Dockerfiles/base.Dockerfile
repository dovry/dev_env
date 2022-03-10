FROM 	alpine:latest
LABEL 	maintainer		"dovry"
LABEL 	description		"base image for a development environment with zsh, git and vim. Also used for testing dotfile setup"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"

# Install packages
RUN apk add --no-cache \
	zsh git vim grep zsh-autosuggestions zsh-syntax-highlighting bind-tools wget curl \
	&& rm -r --force /var/cache/apk/*

# Add user $user_name
RUN adduser --shell /bin/zsh --defaults --home-dir ${user_dir} ${user_name} \
	&& /bin/zsh ${user_dir}/.zshrc \
	&& chown ${user_name}:${user_name} ${user_dir}/.zshrc

# Change user to $user_name and set working dir to $user_name's home directory
USER 	${user_name}
WORKDIR ${user_dir}

# Install Zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" \
	&& curl --location git.io/antigen > ${user_dir}/.antigen/antigen.zsh --create-dirs \
	&& git clone git://github.com/dovry/dotfiles.git ~/dotfiles

# Setup dotfiles
RUN /bin/zsh dotfiles/shell_setup.sh

ENTRYPOINT ["/bin/zsh"]