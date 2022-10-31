# MyTexLife
This is forked from [Latex Dev Container (qdm12/latexdevcontainer)](https://github.com/qdm12/latexdevcontainer).

In comparison, the docker image to be build is big providing a "texlive-full" environment with default recipes for dealing with the most complex LaTeX rendering of academic writing. 
In addition, the following apps will also be pre-installed at the building stage:
- `ghostscript` for handling eps files
- `libfontconfig1`

Additional vscode extensions and settings (includes a set of default LaTeX recipes for handling complex LaTeX rendering) were also be pre-installed; see *devcontainer.json*. 

The container built according to [okatsn/MyTexLife](https://github.com/okatsn/MyTeXLife.git) aims for a complete functional

## Hints
Based on [qdm12/latexdevcontainer](https://github.com/qdm12/latexdevcontainer), you may install extra applications for example::
```bash
apt-get update
apt-get install libfontconfig1
apt-get -y install ghostscript
```
