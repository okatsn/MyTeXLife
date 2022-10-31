# MyTexLife
Forked from [Latex Dev Container (qdm12/latexdevcontainer)](https://github.com/qdm12/latexdevcontainer), [okatsn/MyTexLife](https://github.com/okatsn/MyTeXLife.git) aims for a Docker image of complete TexLive suites and extra functions of vscode and others; thus the image to be build is quite large.



In comparison, [okatsn/MyTexLife](https://github.com/okatsn/MyTeXLife.git) provides a "texlive-full" environment with default recipes for dealing with the most complex LaTeX documents of academic writing. 
In addition, the following apps will also be pre-installed at the building stage:
- `ghostscript` for handling eps files
- `libfontconfig1`

Additional vscode extensions and settings (includes a set of default LaTeX recipes for handling complex LaTeX rendering) were also be pre-installed; see *devcontainer.json*. 

## How to use
- Fork this repo; clone it to your local machine.
- Build and reopen in container
- `cd` to *workspace*, clone your project there and start your LaTeX life there.
- Anything in workspace will be git-ignored.

## Hints
Based on [qdm12/latexdevcontainer](https://github.com/qdm12/latexdevcontainer), you may install extra applications for example::
```bash
apt-get update
apt-get install libfontconfig1
apt-get -y install ghostscript
```
