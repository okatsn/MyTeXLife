# MyTeXLife
Forked from [Latex Dev Container (qdm12/latexdevcontainer)](https://github.com/qdm12/latexdevcontainer), [okatsn/MyTeXLife](https://github.com/okatsn/MyTeXLife.git) aims for a Docker image of complete TexLive suites and extra functions of vscode and others; thus the image to be build is quite large.

In comparison, [okatsn/MyTeXLife](https://github.com/okatsn/MyTeXLife.git) provides a "texlive-full" environment, with default recipes for dealing with the most complex LaTeX documents of academic writing and additional pre-installed applications.

Additional vscode extensions and settings (includes a set of default LaTeX recipes for handling complex LaTeX rendering) were also be pre-installed; see *devcontainer.json*.

## Build the `my-tex-life` image (for developer)
Follow the instructions to build, tag this image in WSL
```bash
# Open the okatsn/my-workspace repository where my-tex-life resides as a submodule.
cd ./my-tex-life
docker-compose --env-file ../my-build.env -f .devcontainer/docker-compose.yml build --no-cache
# Take the enviroment variable in okatsn/my-workspace/my-build.env
docker tag latexdevcontainer okatsn/my-tex-life:latest
docker push okatsn/my-tex-life:latest
```

or in WSL in the directory of `my-tex-life/`, `Ctrl+Shift+P` and choose `Dev Containers: Rebuild Container Without Cache`

### How to build other image based on `my-tex-life` (for user)
- Create a new Dockerfile
- Add `FROM okatsn/my-tex-life:latest` in the last stage.
- You can refer the .devcontainer to build your vscode environment.

See [okatsn/my-tex-life on Dockerhub](https://hub.docker.com/repository/docker/okatsn/my-tex-life/general) for versions.

## Hints 

- Anything in *projects* will be git-ignored. Clone your latex projects into  *projects* and start your LaTeX life. (for user)


## Others
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

## For building a multi-stage docker image

MyTeXLife designed to serve as the base image of a multi-stage docker image.
That is, `FROM okatsn/my-tex-life` should be the last `FROM` command in the Dockerfile of a multi-stage docker image. 

For apps installed in any earlier intermediate stages, their permission should be transferred to the user that is specified in `MyTeXLife/.devcontainer/.env` file.

In the last stage (after `FROM okatsn/my-tex-life` command), user information variables such as `NB_USER`, `NB_UID` and `NB_GID` can be directly used as `$NB_USER`.
