# FROM qmcgaw/latexdevcontainer:latest
FROM qmcgaw/latexdevcontainer:latest-full




# Install `chktex` does no help the the warning: usr/local/bin/chktex: WARNING -- Could not find global resource file.
# - It is no-error but useless to RUN the following at the second Dockerfile (services: vscode; see docker-compose.yml)
RUN apt-get update && apt-get -y install \
    libfontconfig libfontconfig1 \
    ghostscript \
    chktex

    # libfontconfig1 is for ... I don't know. But without it, my LaTeX compliation failed
    # ghostscript for handling eps image files
    # inkscape is for including svg; but ["The smoothest route"](https://danmackinlay.name/notebook/latex.html#svg) that converts SVG into PDF+TeX seems very unsuitable for submitting to an academic journal.
