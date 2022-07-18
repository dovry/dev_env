FROM 	alpine:latest
LABEL 	maintainer		"dovry"
LABEL 	description1	"base image for a development environment with zsh, git and vim"
LABEL	description2	"Also used for testing various shell scripts"
ENV 	user_name 		"docker"
ENV 	user_dir 		"/home/${user_name}"
ENV		PATH			"${user_dir}/.local/bin:${PATH}"

# Install packages
RUN apk add --no-cache \
	zsh git vim zsh-autosuggestions zsh-syntax-highlighting  wget curl bind-tools grep  \
	&& rm -r -f /var/cache/apk/*

# Add user $user_name
RUN adduser -s /bin/zsh -D -h ${user_dir} ${user_name}

# Change user to $user_name and set working dir to $user_name's home directory
USER 	${user_name}
WORKDIR ${user_dir}

# Install Zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" \
	&& /bin/zsh ${user_dir}/.zshrc
	
RUN	chown ${user_name}:${user_name} ${user_dir}/.zshrc \
	&& git clone https://github.com/dovry/dotfiles.git ~/dotfiles

RUN /bin/zsh dotfiles/shell_setup.sh

SHELL ["/bin/zsh"]

ENTRYPOINT ["/bin/zsh"]