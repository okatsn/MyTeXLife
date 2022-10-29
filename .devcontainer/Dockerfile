FROM qmcgaw/latexdevcontainer:latest-full

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get -y install \
    libfontconfig libfontconfig1 \
    ghostscript
    # libfontconfig1 is for ... I don't know. But without it, my LaTeX compliation failed
    # ghostscript for handling eps image files
