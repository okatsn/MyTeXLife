# MyTeXLife
Forked from [Latex Dev Container (qdm12/latexdevcontainer)](https://github.com/qdm12/latexdevcontainer), [okatsn/MyTeXLife](https://github.com/okatsn/MyTeXLife.git) aims for a Docker image of complete TexLive suites and extra functions of vscode and others; thus the image to be build is quite large.



In comparison, [okatsn/MyTeXLife](https://github.com/okatsn/MyTeXLife.git) provides a "texlive-full" environment with default recipes for dealing with the most complex LaTeX documents of academic writing.
In addition, the following apps will also be pre-installed at the building stage:
- `ghostscript` for handling eps files
- `libfontconfig1`

Additional vscode extensions and settings (includes a set of default LaTeX recipes for handling complex LaTeX rendering) were also be pre-installed; see *devcontainer.json*.

## How to use
- Fork this repo; clone it to your local machine.
- Build and reopen in container
- `cd` to *projects*, clone your project there and start your LaTeX life there.
- Anything in *projects* will be git-ignored.

### Permission Issues
In directory `projects`, run `chmod -R a+w *` to make all files and subdirectories under the project folder being writable to other users. If you didn't do this, you cannot modify/delete the contents by users outside the container.

I've tried to solve this problem at the building stage but all attempts failed. See `README.md` in `projects/`.

Go to branch try-fixpermissions-a to continue.

## Hints

### Install other applications in container OS
Based on [qdm12/latexdevcontainer](https://github.com/qdm12/latexdevcontainer), you may install extra applications for example::
```bash
apt-get update
apt-get install libfontconfig1
apt-get -y install ghostscript
```

### Manage git repositories
Clone your project into "workspace/projects"
- `cd projects`
- `git clone https://github.com/yourname/ACertainArticle.git`

Open your project in a new window using GPM
- `Ctrl+Shift+P` and type "GPM" (for [felipecaputo.git-project-manager](https://github.com/felipecaputo/git-project-manager)) to open sub-repositories (detected only if they are under "projects") in a new window.
