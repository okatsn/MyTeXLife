# KEYNOTE: Follow the instructions to build, tag this image in WSL:

```bash
cd ./my-tex-life
docker-compose --env-file ../my-build.env -f .devcontainer/docker-compose.yml build --no-cache
# Take the enviroment variable in okatsn/my-workspace/my-build.env
docker tag latexdevcontainer okatsn/my-tex-life:latest
docker push okatsn/my-tex-life:latest
```

or in WSL in the directory of `my-tex-life/`, `Ctrl+Shift+P` and choose `Dev Containers: Rebuild Container Without Cache`

## How to build other image based on `my-tex-life`
- Create a new Dockerfile
- Add `FROM okatsn/my-tex-life:latest` in the last stage.
- You can refer the .devcontainer to build your vscode environment.
