# # KEYNOTE: Follow the instructions to build, tag this image in WSL:
# docker-compose -f .devcontainer/docker-compose.yml build --no-cache
# docker tag latexdevcontainer okatsn/my-tex-life:latest
# docker push okatsn/my-tex-life:latest
#
# # or in WSL, Ctrl+Shift+P and choose Dev Containers: Rebuild Container Without Cache

# # KEYNOTE: How to use
# - Create a new Dockerfile
# - FROM okatsn/my-tex-life:latest
# - You can refer the .devcontainer to build your vscode environment.


# FROM qmcgaw/latexdevcontainer:latest
FROM qmcgaw/latexdevcontainer:latest-full
# KEYNOTE: Very likely everything is set up with `USER root` in `FROM qmcgaw/latexdevcontainer:latest`.

RUN apt-get update && apt-get -y install \
    libfontconfig libfontconfig1 \
    # libfontconfig1 is for ... I don't know. But without it, my LaTeX compliation failed
    ghostscript \
    # ghostscript for handling eps image files
    curl \
    qpdf \
    # You can use qpdf to add password to pdf, it is small and useful.
    bash-completion\
    # # This fix the annoying chktex warning
    # Which is equivalently in bash,
    # 1. apt-get install chktex
    # 2. cp /usr/bin/chktex /usr/local/bin/chktex
    # Noted that `COPY /usr/bin/chktex /usr/local/bin/chktex` will fail due to "no such file or directory: /usr/bin/chktex"
    chktex && \
    cp /usr/bin/chktex /usr/local/bin/chktex

# Install DVC (please make it synced with MyJuliaSpace)
RUN wget https://dvc.org/deb/dvc.list -O /etc/apt/sources.list.d/dvc.list \
    && wget -qO - https://dvc.org/deb/iterative.asc | gpg --dearmor > packages.iterative.gpg \
    && install -o root -g root -m 644 packages.iterative.gpg /etc/apt/trusted.gpg.d/ \
    && rm -f packages.iterative.gpg \
    && apt update \
    && apt install dvc=3.33.4 \
    && dvc completion -s bash | tee /etc/bash_completion.d/dvc


# Other packages:
# inkscape is for including svg; but ["The smoothest route"](https://danmackinlay.name/notebook/latex.html#svg) that converts SVG into PDF+TeX seems very unsuitable for submitting to an academic journal.


# # FIX PERMISSION
# Previously, I cannot move/delete files in the project in /projects via neither windows file explorer nor vscode WSL interface. Accesses are denied because project are `git cloned` by `root`, not the user `okatsn` (the user of WSL).
#
# ## How I fixed it
# Refering https://hub.docker.com/r/jupyter/base-notebook/dockerfile, I create a new user with its ID the default ID (i.e., "1000"), and use the `fix-permissions` script to change the modification permissions of everything under the "/workspace" folder

## Only root can chmod files/directories that are accessible only to root
USER root

## Copy the file ".devcontainer/fix-permissions" to local machine for later call
# - also see https://www.cnblogs.com/sparkdev/p/9573248.html for "building context"
COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions


ARG NB_USER="to_be_replaced_by_that_in_docker-compose.yml"
ARG NB_UID="to_be_replaced_by_that_in_docker-compose.yml"
ARG NB_GID="to_be_replaced_by_that_in_docker-compose.yml"
ARG PSWD="to_be_replaced_by_that_in_docker-compose.yml"


ARG WORKSPACE_DIR="/workspace/dir/defined/in/docker-compose/yml"
ARG SUB_PROJECT_DIR="/workspace/dir/defined/in/docker-compose/yml"
ARG HOME=/home/$NB_USER


## Configure environment
ENV NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID\
    WORKSPACE_DIR=$WORKSPACE_DIR\
    HOME=$HOME\
    PSWD=$PSWD\
    SUB_PROJECT_DIR=$SUB_PROJECT_DIR

## Add user $NB_USER with its group being $NB_GID
# RUN useradd -m -g $NB_GID $NB_USER

## Add user as in jupyter/base-notebook/
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER
# the -m flag creates /home/$NB_USER

## Change (set) password
# A user cannot use sudo if he has no password set
# See https://stackoverflow.com/questions/2150882/how-to-automatically-add-user-account-and-password-with-a-bash-script
RUN echo $NB_USER:$PSWD | chpasswd
RUN echo root:$PSWD | chpasswd

# Install Fonts and SUDO
# in order to use `fc-cache -f -v` and `fc-list :lang=zh`
# - `fc-cache -f -v`: (copy font files to /usr/share/fonts/ and Update Font Cache)
# - `fc-list :lang=zh`: List all chinese font available
RUN apt update && apt install \
    sudo \
    fontconfig \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    # fonts-arphic-uming \
    # fonts-arphic-ukai \
    # The following lines are required to make jovyan in the sudoer list.
    && echo $NB_USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$NB_USER \
    && chmod 0440 /etc/sudoers.d/$NB_USER \
    && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*


# # Copy files in .devcontainer to HOME for default configurations
#
## Starship configuration
COPY starship.toml /$HOME/.config/starship.toml
## If there is git-completion.bash, you should use it
# - this makes auto-completion after `git branch ...` works properly
# - Requirement: git-completion.bash; see below `RUN ... curl ... git-completion.bash`.
# - zsh seems natively supports auto completion. See https://apple.stackexchange.com/a/55886
COPY .bash_profile /$HOME/.bash_profile

## Fix permissions for NB_USER
# ERROR will occur if:
# - Without `chown $NB_USER:$NB_GID /home/$NB_USER`, subdirectories for vscode cannot be created because "/home/$NB_USER" is created and only owned by root.
RUN chown $NB_USER:$NB_GID $WORKSPACE_DIR && \
    chown $NB_USER:$NB_GID /usr/local/bin && \
    fix-permissions $WORKSPACE_DIR && \
    fix-permissions /home/$NB_USER && \
    # or `chown $NB_USER:$NB_GID /home/$NB_USER`
    fix-permissions /usr/local/bin
# in order to install starship

## Switch to user
USER $NB_UID
WORKDIR $WORKSPACE_DIR


# # User cannot do this unless you use sudo
# - see https://unix.stackexchange.com/questions/39572/allow-non-admin-users-to-install-packages-via-apt-or-rpm
# RUN apt-get -y install \
#     curl


## Install Starship and git-auto completion
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc \
    && mkdir -p ~/.config \
    # auto completion for git: https://ithelp.ithome.com.tw/articles/10227698
    && curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.sh


# # # No error but the warning does not fixed
# # Try to fix chktex warning
# ARG CHKTEX_VERSION=1.7.6
# WORKDIR /tmp/workdir
# RUN apt-get update -y && \
#     apt-get install -y --no-install-recommends g++ make wget
# RUN wget -qO- http://download.savannah.gnu.org/releases/chktex/chktex-${CHKTEX_VERSION}.tar.gz | \
#     tar -xz --strip-components=1
# RUN ./configure && \
#     make && \
#     mv chktex /usr/local/bin/chktex && \
#     rm -r *

# # ERROR: "/tmp/chktex" not found
# COPY /tmp/chktex /usr/local/bin/chktex
# # [With and without "/"](https://docs.docker.com/engine/reference/builder/#copy)
# COPY test.txt /absoluteDir/
# COPY test.txt relativeDir/
