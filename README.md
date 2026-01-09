# 🎓 mulle-sde installer + various extensions for mulle-sde

... for Android, BSDs, Linux, macOS, SunOS, Windows (MinGW, WSL)

This is a base collection of [mulle-sde](//github.com/mulle-sde/mulle-sde)
*extensions*. It is also the convenient way to install mulle-sde.

| Release Version                                       | Release Notes
|-------------------------------------------------------|--------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-sde/mulle-sde-developer.svg)  | [RELEASENOTES](RELEASENOTES.md) |

## Extensions

| Extension                     | Type  | Description
|-------------------------------|-------|-----------------------------------
| mulle-sde/c-developer         | meta  | Create plain C projects
| mulle-sde/extension-developer | meta  | Create mulle-sde extesnsions
| mulle-sde/sde                 | extra | Base extension functionality
| mulle-sde/sublime-text        | extra | A sublime project file for editing
| mulle-sde/codacy              | extra | Codacy files
| mulle-sde/github-actions      | extra | Create a github action for mulle-sde
| mulle-sde/idea                | extra | CLion support
| mulle-sde/vscode              | extra | Visual Studio Code support
| mulle-sde/vscode-clang        | extra | Visual Studio Code with Clang support





## Usage

### Check that the (meta) extensions are found:

``` bash
mulle-sde extension show
```

### Create a C executable project

``` bash
mkdir foo
cd foo
mulle-sde init -m mulle-sde/c-developer executable
```

### Create a C library project

``` bash
mulle-sde init -m mulle-sde/c-developer -d foolib library
```


### Create a mulle-sde extension project

``` bash
mulle-sde init -m mulle-sde/extension-developer -d my-sde-extension extension
```








## Install

### Packages

| OS     | Command
|--------|------------------------------------
| macos  | `brew install mulle-kybernetik/software/mulle-sde-developer`
| debian | `sudo apt-get -y install mulle-sde-developer` (but see below)
| ubuntu | same as debian
| arch   | Check [https://aur.archlinux.org/packages/mulle-sde]() for packages. (Not maintained by Mulle kybernetiK)


#### Debian Mulle kybernetiK repository

For apt installation you need to add the Mulle kybernetiK debian repository
first:

``` bash
wget -O - "https://www.mulle-kybernetik.com/dists/debian-admin-pub.asc" \
| sudo apt-key add -
echo "deb [arch=all] http://www.mulle-kybernetik.com `lsb_release -c -s` main" \
| sudo tee "/etc/apt/sources.list.d/mulle-kybernetik.com-main.list" > /dev/null
sudo apt-get update
```


### Script

There are some prerequisites for installation and for C languages
development. Here is a list of debian/ubuntu packages. For other platforms
install similiar packages:

| Debian Package     | Neded for      |Comment
|--------------------|----------------|-------------------------
| `build-essential`  | C development  | The usual compiler tools like cc, ar, nm, make
| `curl` or `wget`   | Package fetch  |
| `git` or `svn`     | Package fetch  | Without `git` you won't have much fun
| `cmake`            | C development  | Shoot for cmake 3.14 or higher
| `sudo`             | Installation   | Or run everything as root
| `bsdmainutils`     | Beauty         | Needed for `column` output


> **Arch Note**
>
> Arch doesn't like `libexec`, so maybe define the environment variable
> `LIBEXEC_DIRNAME="lib" when running the script installer.
>

> **Android Note**
>
> Get termux from the FDroid store.
>
> ``` bash
> pkg install bash binutils curl cmake git openssl openssh
> ```


> **NetBSD Note**
>
> ``` bash
> pkgin install bash clang curl cmake git mozilla-rootcerts-openssl
> git config --global http.sslBackend openssl
> ```


> **Solaris Note**
>
> Get OpenCSW and put `/usr/xpk4/bin` in front of your path, as the default
> `grep` is too gimped:
>

mulle-sde provides an
[installer-all](https://raw.githubusercontent.com/mulle-sde/mulle-sde/master/bin/installer-all)
script to install the required commands and mulle-sde-developer itself into
`/usr/local` by default or some other place.


#### Install into /usr with sudo

``` bash
curl -L -O 'https://raw.githubusercontent.com/mulle-sde/mulle-sde/master/bin/installer-all' && \
chmod 755 installer-all && \
sudo SDE_PROJECTS="mulle-sde-developer;latest" ./installer-all /usr
```

Ensure that `/usr/bin` is in the `PATH` environment variable, otherwise the
scripts won't start.

#### Install into ${HOME} (without sudo)

``` bash
curl -L -O 'https://raw.githubusercontent.com/mulle-sde/mulle-sde/master/bin/installer-all' && \
chmod 755 installer-all && \
SDE_PROJECTS="mulle-sde-developer;latest" ./installer-all ~ no
```

Ensure that the expanded value of `${HOME}/bin` (and not `~/bin`) is in the
`PATH` environment variable, otherwise the scripts won't start.


### Docker

There is a [Dockerfile](https://raw.githubusercontent.com/mulle-sde/mulle-sde-developer/release/Dockerfile) in the project.

This will build and run an ephemeral mulle-sde container:

``` bash
docker build -t mulle-sde 'https://raw.githubusercontent.com/mulle-sde/mulle-sde-developer/release/Dockerfile'
docker run -i -t --rm mulle-sde
```

## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK


