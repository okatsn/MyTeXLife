# FROM qmcgaw/latexdevcontainer:latest
FROM qmcgaw/latexdevcontainer:latest-full
ARG CHKTEX_VERSION=1.7.6



# Install `chktex` does no help the the warning: usr/local/bin/chktex: WARNING -- Could not find global resource file.
# - It is no-error but useless to RUN the following at the second Dockerfile (services: vscode; see docker-compose.yml)
RUN apt-get update && apt-get -y install \
    libfontconfig libfontconfig1 \
    ghostscript

    # libfontconfig1 is for ... I don't know. But without it, my LaTeX compliation failed
    # ghostscript for handling eps image files
    # inkscape is for including svg; but ["The smoothest route"](https://danmackinlay.name/notebook/latex.html#svg) that converts SVG into PDF+TeX seems very unsuitable for submitting to an academic journal.

# Try to fix chktex warning
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends g++ make wget

RUN wget -qO- http://download.savannah.gnu.org/releases/chktex/chktex-${CHKTEX_VERSION}.tar.gz | \
    tar -xz --strip-components=1
RUN ./configure && \
    make && \
    mv chktex /usr/local/bin/chktex

# EVENT: 2022-11-24 at my laptop
# Permissions for this Dockerfile (as well as some others) are set to root after an error occurred in the following line (cannot find the path).
# Since container was fail to be built, I can only modify the dockerfile in WSL but permission denied.
# I forgot the password of WSL thus cannot turn to a superuser, and the folder MyTeXLife becomes undeletable.
#
# RUN chmod a+w projects
