# 🏋🏼 mulle-sde with C, cmake and mulle-sde extension support


This is a base collection of [mulle-sde](//github.com/mulle-sde/mulle-sde)
*extensions*. It is also a convenient way to install mulle-sde.

See the [mulle-sde Wiki](https://github.com/mulle-sde/mulle-sde/wiki) for
an introduction on what **mulle-sde** is.


Extension                      | Type      | Description
-------------------------------|-----------|-----------------------------------
mulle-sde/c-developer          | meta      | Create plain C projects
mulle-sde/extension-developer  | meta      | Create mulle-sde extesnsions
mulle-sde/sde                  | extra     | Base extension functionality
mulle-sde/sublime-text         | extra     | A sublime project file for editing


## Install

### Packages

OS      | Command
--------|------------------------------------
macos   | `brew install mulle-kybernetik/software/mulle-sde-developer`
debian  | `sudo apt-get -y install mulle-sde-developer` (but see below)
ubuntu  | same as debian


#### Debian Mulle kybernetiK repository

For apt installation you need to add the Mulle kybernetiK debian repository
first:

```
wget -O - "https://www.mulle-kybernetik.com/dists/debian-admin-pub.asc" | sudo apt-key add -
echo "deb [arch=all] http://www.mulle-kybernetik.com `lsb_release -c -s` main" | sudo tee "/etc/apt/sources.list.d/mulle-kybernetik.com-main.list" > /dev/null
sudo apt-get update
```


### Script

mulle-sde provides an `[installer-all](https://raw.githubusercontent.com/mulle-sde/mulle-sde/release/installer-all)` script to installs the required commands and mulle-sde-developer itself into `/usr`.
This is suitable for environments without supported package managers:

```
curl -L -O 'https://raw.githubusercontent.com/mulle-sde/mulle-sde/release/installer-all' && \
chmod 755 installer-all && \
sudo SDE_PROJECTS="mulle-sde-developer;latest" ./installer-all /usr
```

### Docker

There is a [Dockerfile](https://raw.githubusercontent.com/mulle-sde/mulle-sde-developer/release/Dockerfile) in the project.

This will build and run an ephemeral mulle-sde container:

```
docker build -t mulle-sde 'https://raw.githubusercontent.com/mulle-sde/mulle-sde-developer/release/Dockerfile'
docker run -i -t --rm mulle-sde
```


# Usage

#### Check that the (meta) extensions are found:

```
mulle-sde extension list
```

### Create a C executable project

```
mulle-sde init -m mulle-sde/c-developer executable
```

### Create a C library project

```
mulle-sde init -m mulle-sde/c-developer library
```


### Create a mulle-sde extension project

```
mulle-sde init -m mulle-sde/extension-developer extension
```


