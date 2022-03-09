FROM 	alpine:latest
LABEL 	maintainer		"dovry"
LABEL 	description		"base image for a development environment with zsh, git and vim. Also used for testing dotfile setup"
ENV 	container 		"docker"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"

# Install packages
RUN apk add --no-cache \
	zsh git vim grep zsh-autosuggestions zsh-syntax-highlighting bind-tools wget \
	&& rm -rf /var/cache/apk/*

# Add user $user_name
RUN adduser -s /bin/zsh -D -h ${user_dir} ${user_name} \
	&& touch ${user_dir}/.zshrc \
	&& chown ${user_name}:${user_name} ${user_dir}/.zshrc

# Change user to $user_name and set working dir to $user_name's home directory
USER 	${user_name}
WORKDIR ${user_dir}

# Install Zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" \
	&& git clone git://github.com/dovry/dotfiles.git ~/dotfiles

# Setup dotfiles
RUN /bin/zsh dotfiles/shell_setup.sh \
	&& echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc \
	&& echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

ENTRYPOINT ["/bin/zsh"]