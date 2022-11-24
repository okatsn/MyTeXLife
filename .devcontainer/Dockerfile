FROM qmcgaw/latexdevcontainer:latest-full


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
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER
## Change owner
# https://linuxize.com/post/linux-chown-command/
# https://blog.gtwang.org/linux/linux-chown-command-tutorial/
RUN chown $NB_USER:$NB_GID $WORKSPACE_DIR && \
    fix-permissions $WORKSPACE_DIR

## Switch to user
USER $NB_UID

# Install Starship
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc \
    && mkdir -p ~/.config
    && echo -e '[conda]\nsymbol = "Conda "\nignore_base = false' > ~/.config/starship.toml
