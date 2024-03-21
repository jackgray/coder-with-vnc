FROM jackgray/narc-os:jammy-staging	

RUN cp -r /home/kasm-user /tmp/kasm-user
RUN apt-get update && apt-get install sudo
RUN echo "kasm-user ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd
RUN DEBIAN_FRONTEND=noninteractive make-ssl-cert generate-default-snakeoil --force-overwrite
RUN adduser kasm-user ssl-cert

USER 1000

# RUN apt-get update \
# 	&& apt-get install -y
    # \
	# curl \
	# git \
	# golang \
	# sudo \
	# vim \
	# wget \
	# && rm -rf /var/lib/apt/lists/*

# ARG USER=1000

# RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
# 	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
# 	&& chmod 0440 /etc/sudoers.d/${USER}
# USER ${USER}
# WORKDIR /home/${USER}

# USER ${USER}