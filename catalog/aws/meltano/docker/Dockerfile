FROM meltano/meltano

WORKDIR /

# Install the latest `gitenv-init` scripts
ENV GITENV_REPO_ROOT=https://raw.githubusercontent.com/dataops-tk/gitenv-init/main
RUN wget ${GITENV_REPO_ROOT}/gitenv-init.sh
RUN wget ${GITENV_REPO_ROOT}/gitenv-bootstrap.sh
RUN chmod +x /gitenv-bootstrap.sh
RUN chmod +x /gitenv-init.sh
ENTRYPOINT [ "/gitenv-bootstrap.sh" ]

# Meltano-specific steps here:

# Install the Meltano boostrap script
COPY ./bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh

WORKDIR /project

# Set our bootstrap script to run within gitenv-bootstrap.sh
ENV BASE_BOOTSTRAP=/bootstrap.sh
CMD ["ui"]
