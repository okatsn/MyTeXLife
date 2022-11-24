FROM qmcgaw/latexdevcontainer:latest-full


RUN apt-get update && apt-get -y install \
    libfontconfig libfontconfig1 \
    ghostscript

    # libfontconfig1 is for ... I don't know. But without it, my LaTeX compliation failed
    # ghostscript for handling eps image files
    # inkscape is for including svg; but ["The smoothest route"](https://danmackinlay.name/notebook/latex.html#svg) that converts SVG into PDF+TeX seems very unsuitable for submitting to an academic journal.

# Install `chktex` does no help the the warning: usr/local/bin/chktex: WARNING -- Could not find global resource file.


ARG NB_USER="workspace"


ARG NB_UID="1000"
ARG NB_GID="100"

USER $NB_USER

# Install Starship
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc \
    && mkdir -p ~/.config \
    && echo -e '[conda]\nsymbol = "Conda "\nignore_base = false' > ~/.config/starship.toml

# CHECKPOINT: FIX PERMISSION
# Now I'm trying rebuild this container and reclone the projects with a different user.
#
# Useful commands:
# # List all user/group
# awk -F: '{printf "%s:%s\n",$1,$3}' /etc/passwd
# # Add new user
# groupadd -g 1000 okatsn
#
# KEYNOTE: Currently, I cannot move/delete files in the project in /projects via neither windows file explorer nor vscode WSL interface. Very likely the permissions are denied because project are `git cloned` by `root`, not the user `okatsn` (the user of WSL).

RUN fix-permissions /home/$NB_USER
