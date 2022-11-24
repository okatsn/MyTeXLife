ARG DEBIAN_VERSION=bullseye-slim
ARG BASEDEV_VERSION=v0.9.0

FROM debian:${DEBIAN_VERSION} AS chktex
ARG CHKTEX_VERSION=1.7.6
WORKDIR /tmp/workdir
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends g++ make wget
RUN wget -qO- http://download.savannah.gnu.org/releases/chktex/chktex-${CHKTEX_VERSION}.tar.gz | \
    tar -xz --strip-components=1
RUN ./configure && \
    make && \
    mv chktex /tmp && \
    rm -r *

FROM qmcgaw/basedevcontainer:${BASEDEV_VERSION}-debian
ARG BUILD_DATE
ARG COMMIT
ARG VERSION=local
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$COMMIT \
    org.opencontainers.image.url="https://github.com/qdm12/latexdevcontainer" \
    org.opencontainers.image.documentation="https://github.com/qdm12/latexdevcontainer" \
    org.opencontainers.image.source="https://github.com/qdm12/latexdevcontainer" \
    org.opencontainers.image.title="Latex Dev container Alpine" \
    org.opencontainers.image.description="Latex development container for Visual Studio Code Remote Containers development"
WORKDIR /tmp/texlive
ARG SCHEME=scheme-basic
ARG DOCFILES=0
ARG SRCFILES=0
ARG TEXLIVE_VERSION=2022
ARG TEXLIVE_MIRROR=http://ctan.math.utah.edu/ctan/tex-archive/systems/texlive/tlnet
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends wget gnupg cpanminus && \
    wget -qO- ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz | \
    tar -xz --strip-components=1 && \
    export TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1 && \
    export TEXLIVE_INSTALL_NO_WELCOME=1 && \
    printf "selected_scheme ${SCHEME}\ninstopt_letter 0\ntlpdbopt_autobackup 0\ntlpdbopt_desktop_integration 0\ntlpdbopt_file_assocs 0\ntlpdbopt_install_docfiles ${DOCFILES}\ntlpdbopt_install_srcfiles ${SRCFILES}" > profile.txt && \
    perl install-tl -profile profile.txt --location ${TEXLIVE_MIRROR} && \
    # Cleanup
    cd && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/texlive /usr/local/texlive/${TEXLIVE_VERSION}/*.log
ENV PATH ${PATH}:\
/usr/local/texlive/${TEXLIVE_VERSION}/bin/x86_64-linux:\
/usr/local/texlive/${TEXLIVE_VERSION}/bin/aarch64-linux
WORKDIR /workspace
# Latexindent dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends cpanminus make gcc libc6-dev && \
    cpanm -n -q Log::Log4perl && \
    cpanm -n -q XString && \
    cpanm -n -q Log::Dispatch::File && \
    cpanm -n -q YAML::Tiny && \
    cpanm -n -q File::HomeDir && \
    cpanm -n -q Unicode::GCString && \
    apt-get remove -y cpanminus make gcc libc6-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN tlmgr install latexindent latexmk && \
    texhash && \
    rm /usr/local/texlive/${TEXLIVE_VERSION}/texmf-var/web2c/*.log && \
    rm /usr/local/texlive/${TEXLIVE_VERSION}/tlpkg/texlive.tlpdb.main.*
COPY --from=chktex /tmp/chktex /usr/local/bin/chktex
COPY shell/.zshrc-specific shell/.welcome.sh /root/
# Verify binaries work and have the right permissions
RUN tlmgr version && \
    latexmk -version && \
    texhash --version && \
    chktex --version




RUN apt-get update && apt-get -y install \
    libfontconfig libfontconfig1 \
    ghostscript

    # libfontconfig1 is for ... I don't know. But without it, my LaTeX compliation failed
    # ghostscript for handling eps image files
    # inkscape is for including svg; but ["The smoothest route"](https://danmackinlay.name/notebook/latex.html#svg) that converts SVG into PDF+TeX seems very unsuitable for submitting to an academic journal.

# Install `chktex` does no help the the warning: usr/local/bin/chktex: WARNING -- Could not find global resource file.


# FIXPERM: Fix permissions according to
# - https://hub.docker.com/r/jupyter/base-notebook/dockerfile
USER root
# FIXPERM: copy the file ".devcontainer/fix-permissions" to local machine for later call
# - also see https://www.cnblogs.com/sparkdev/p/9573248.html for "building context"
COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions



# CHECKPOINT: FIX PERMISSION
# Now I'm trying rebuild this container and reclone the projects with a different user.
# KEYNOTE: Currently, I cannot move/delete files in the project in /projects via neither windows file explorer nor vscode WSL interface. Very likely the permissions are denied because project are `git cloned` by `root`, not the user `okatsn` (the user of WSL).
#
#
# Useful commands:
# # List all user/group
# awk -F: '{printf "%s:%s\n",$1,$3}' /etc/passwd
# See https://askubuntu.com/questions/645236/command-to-list-all-users-with-their-uid
#
# # Get Environment Variable from Docker Container
# docker exec container env
# See https://stackoverflow.com/questions/34051747/get-environment-variable-from-docker-container
#
# # Add new user
# groupadd -g 1000 okatsn
#
# # Other resources that might be useful
# - [Linux sysadmin basics: User account management with UIDs and GIDs](https://www.redhat.com/sysadmin/user-account-gid-uid)
#
# - [default user in WSL](https://superuser.com/questions/1266881/how-to-change-the-default-user-name-in-wsl)
#
# - [How to switch between users on one terminal?](https://unix.stackexchange.com/questions/3568/how-to-switch-between-users-on-one-terminal)
#
# - [How to set user of Docker container](https://codeyarns.com/tech/2017-07-21-how-to-set-user-of-docker-container.html#gsc.tab=0)



# FIXPERM
ARG NB_USER="okatsn"
ARG NB_UID="1000"
ARG NB_GID="100"
ARG WORKSPACE_DIR="/workspace/"

# FIXPERM: Configure environment
ENV NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID\
    WORKSPACE_DIR=$WORKSPACE_DIR
## New user; See also
# - https://stackoverflow.com/questions/27701930/how-to-add-users-to-docker-container
# - https://linuxize.com/post/how-to-create-users-in-linux-using-the-useradd-command/
# Add or List Group:
# - https://linuxize.com/post/how-to-create-groups-in-linux/
# - https://linuxize.com/post/how-to-list-groups-in-linux/
# Create NB_USER wtih name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -r -d $WORKSPACE_DIR -g $NB_GID $NB_USER
# Create a system account (-r) with its home directory being WORKSPACE_DIR where the user NB_USER under the group of id NB_GID
## Change owner
# https://linuxize.com/post/linux-chown-command/
# https://blog.gtwang.org/linux/linux-chown-command-tutorial/
RUN chown $NB_USER:$NB_GID $WORKSPACE_DIR && \
    fix-permissions $WORKSPACE_DIR

## Switch to user
USER $NB_UID
WORKDIR $WORKSPACE_DIR
# # Install Starship
# RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y \
#     && echo 'eval "$(starship init bash)"' >> ~/.bashrc \
#     && mkdir -p ~/.config \
#     && echo -e '[conda]\nsymbol = "Conda "\nignore_base = false' > ~/.config/starship.toml
# KENOTE: (2022-11-24) Starship can be installed but it seemly didn't worked; the interface of terminal remains the style of qmcgaw/latexdevcontainer
