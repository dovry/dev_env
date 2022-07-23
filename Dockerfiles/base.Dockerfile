FROM 	alpine:latest
LABEL 	maintainer		"dovry"
LABEL 	description1	"base image for a development environment with zsh, git and vim"
LABEL	description2	"Also used for testing various shell scripts"
ENV		PATH			"${user_dir}/.local/bin:${PATH}"

WORKDIR /root

# Install packages
RUN apk add --no-cache \
	zsh git vim zsh-autosuggestions zsh-syntax-highlighting wget curl bind-tools grep tree  \
	&& rm -r -f /var/cache/apk/*

# Install Zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
SHELL [ "/bin/zsh", "-c" ]
#	&& /bin/zsh /root/.zshrc
	
RUN	git clone https://github.com/dovry/dotfiles.git /root/dotfiles && cd $_ \
	&& rm /root/.zshrc && ln -s /root/dotfiles/.zshrc /root/.zshrc

ENTRYPOINT ["/bin/zsh"]