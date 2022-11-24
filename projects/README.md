# Hello
Clone your work in this folder to exploit the MyTexLife environment.
Everything in the *projects* will be git-ignored; that is, they are not under the version control of the MyTexLife repository.
You should have .git in all repos in *projects* set up; otherwise, changes will be lost after your host machine gone.


For example
```bash
cd projects
clone https://github.com/okatsn/MyArticle.git
```


## The problem of permissions, e.g., `EACCES: permission denied`
The project cloned by user `root` cannot be accessed by other users, which is very inconvenient for example I cannot add a file to project/MyArticle from places outside this container.

### Useful resources and command
Permissions:
- View: `ls -la `
- [Understanding File Permissions](https://www.elated.com/understanding-permissions/)
- [Permissions!](https://ryanstutorials.net/linuxtutorial/permissions.php)

List all user/group
- `awk -F: '{printf "%s:%s\n",$1,$3}' /etc/passwd`
- See [Command to list all users with their UID](https://askubuntu.com/questions/645236/command-to-list-all-users-with-their-uid)






Get Environment Variable from Docker Container
- `docker exec container env`
-  See https://stackoverflow.com/questions/34051747/get-environment-variable-from-docker-container

Add new user
- Example: `groupadd -g 1000 okatsn`
- [Linux sysadmin basics: User account management with UIDs and GIDs](https://www.redhat.com/sysadmin/user-account-gid-uid)
- [default user in WSL](https://superuser.com/questions/1266881/how-to-change-the-default-user-name-in-wsl)
- [How to switch between users on one terminal?](https://unix.stackexchange.com/questions/3568/how-to-switch-between-users-on-one-terminal)
- [How to set user of Docker container](https://codeyarns.com/tech/2017-07-21-how-to-set-user-of-docker-container.html#gsc.tab=0)
- https://stackoverflow.com/questions/27701930/how-to-add-users-to-docker-container
- https://linuxize.com/post/how-to-create-users-in-linux-using-the-useradd-command/


Add or List Group:
- https://linuxize.com/post/how-to-create-groups-in-linux/
- https://linuxize.com/post/how-to-list-groups-in-linux/










### Solving the problem in the stage after container has been built
In terminal (zsh), just set everything under projects to be writable to any user:
- `chmod a+w projects`
- See [chmod的用法 - 痞客興的部落格](https://charleslin74.pixnet.net/blog/post/419874889)
- [How do I change directory permissions](https://www.pluralsight.com/blog/it-ops/linux-file-permissions)

### Solving the problem in the building stage (failed)
I've tried the following settings mostly refering to the dockerfile of [base-notebook](https://hub.docker.com/r/jupyter/base-notebook/dockerfile).
My plan is to set the default user lower or the same level as `okatsn` (the default user of WSL) that I can at least move files in WSL on behave of `okatsn`.
It ends up I can sucessfully create new user and execute the key `fix-permissions` script during the building stage, but failed as error occurred after switching to `USER $NB_UID`.

In Dockerfile:
```
USER root
# Copy the file ".devcontainer/fix-permissions" to local machine for later call
# - also see https://www.cnblogs.com/sparkdev/p/9573248.html for "building context"
COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions

# KEYNOTE: Currently, I cannot move/delete files in the project in /projects via neither windows file explorer nor vscode WSL interface. Very likely the permissions are denied because project are `git cloned` by `root`, not the user `okatsn` (the user of WSL).


ARG NB_USER="okatsn"
ARG NB_UID="1000"
ARG NB_GID="100"
ARG WORKSPACE_DIR="/workspace/"

# Configure environment
ENV NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID\
    WORKSPACE_DIR=$WORKSPACE_DIR

## New user; See also
# Create NB_USER wtih name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -r -d $WORKSPACE_DIR -g $NB_GID $NB_USER
# Create a system account (-r) with its home directory being WORKSPACE_DIR where the user NB_USER under the group of id NB_GID
## Change owner
# https://linuxize.com/post/linux-chown-command/
# https://blog.gtwang.org/linux/linux-chown-command-tutorial/
RUN chown $NB_USER:$NB_GID $WORKSPACE_DIR && \
    fix-permissions $WORKSPACE_DIR

# Install Starship
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc \
    && mkdir -p ~/.config \
    && echo -e '[conda]\nsymbol = "Conda "\nignore_base = false' > ~/.config/starship.toml
# KENOTE: (2022-11-24) Starship can be installed but it seemly didn't worked; the interface of terminal remains the style of qmcgaw/latexdevcontainer


## Switch to user: This causes subsequent error due to USER $NB_UID does not permissions to write .vscode
USER $NB_UID
WORKDIR $WORKSPACE_DIR
```
