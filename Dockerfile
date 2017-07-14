FROM ubuntu:16.04

ARG branch=master
ARG version

ENV name="imagemaster3000"
ENV spoolDir="/var/spool/${name}" \
    logDir="/var/log/${name}" \
    LIBGUESTFS_BACKEND="direct" \
    TERM="xterm"

LABEL application=${name} \
      description="Downloading and slight modification of cloud images" \
      maintainer="kimle@cesnet.cz" \
      version=${version} \
      branch=${branch}

SHELL ["/bin/bash", "-c"]

# update + dependencies
RUN apt-get update && \
    apt-get --assume-yes upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install ruby ruby-dev libguestfs-tools linux-image-generic bzip2 gcc make git

# imagemaster3000
RUN gem install ${name} -v "${version}" --no-document

# env
RUN useradd --system --shell /bin/false --home /home/${name} --create-home ${name} && \
    usermod -L ${name} && \
    mkdir -p ${logDir} ${spoolDir} && \
    chown -R ${name}:${name} ${spoolDir} ${logDir} && \
    chmod -R +r /boot

USER ${name}

# gpg keys
RUN (gpg --list-keys || true) && \
    # ubuntu
    gpg --recv-keys 1A5D6C4C7DB87C81 && \
    # debian
    gpg --recv-keys 09EA8AC3 64E6EA7D 6294BE9B && \
    # centos
    gpg --recv-keys F4A80EB5

VOLUME ${spoolDir}

ENTRYPOINT ["imagemaster3000"]
