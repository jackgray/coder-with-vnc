# Use Coder to spin up graphical workspaces

The templates directory contains examples that provide a button to start a debian based virtual environment in the browser. 

Auto mount storage by modifying the terraform template file:
```
  volumes {
    container_path = "/home/${local.username}/s3"
    host_path = "/home/${local.username}/s3"
  }
```

If your usernames between the host machine and Coder accounts match, you can provide different mounts for different users and dynamically map them to the container.

So far attempts to mount network drives or s3 endpoints via s3fs directly inside the container have been unsuccessful, requiring matching usernames and fstab entries on the hostmachine for dynamic directory access on the container based on IAM policy. 

Installing Nextcloud on the docker image may be a viable route as it can serve S3 endpoints

Run a custom docker container by wraping the Dockerfile with:

```
ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-focal"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

#############

# your specs

#############

# Copy startup scripts for vs-code server and kasm vnc server
COPY configs/kasmvnc.yaml /etc/kasmvnc/kasmvnc.yaml

COPY scripts/vnc_startup.sh /dockerstartup/vnc_startup.sh
COPY scripts/mount_buckets.sh /dockerstartup/mount_buckets.sh
COPY scripts/kasm_default_profile.sh /dockerstartup/kasm_default_profile.sh
COPY scripts/custom_startup.sh /dockerstartup/custom_startup.sh

RUN chmod +x /dockerstartup/vnc_startup.sh
RUN chmod +x /dockerstartup/kasm_default_profile.sh
RUN chmod +x /dockerstartup/custom_startup.sh
RUN chown kasm-user:kasm-user /dockerstartup 

RUN usermod -aG sudo kasm-user
RUN usermod -s /bin/bash kasm-user
RUN echo "kasm-user ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/kasm-user
RUN echo "kasm-user ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd
RUN chmod 0440 /etc/sudoers.d/kasm-user
RUN adduser kasm-user ssl-cert

RUN DEBIAN_FRONTEND=noninteractive make-ssl-cert generate-default-snakeoil --force-overwrite

RUN apt-get clean -y && \ 
    apt-get autoremove -y && \ 
    rm -rf /var/lib/apt/lists/*

```

See [narcOS][github.com/jackgray/narc-os] for an example

# Setting up Coder

docker compose up -d

After spinning up the docker containers, you should install the coder cli:
`curl -fsSL https://coder.com/install.sh | sh`

You could also install this in your docker image and use Coder to admin Coder!

Then run `coder login http://<your-server-ip:7080`

Follow instructions for retreiving the API token to copy and paste into the terminal


### Templates

The currently only focal (ubuntu 20.04) images work. Deploy them in order of dev, staging, and prod. These correspond to Coder UI template names development, beta, and stable. 