# 🏋🏼 mulle-sde, c, cmake and extension support

This is a base collection of [mulle-sde](//github.com/mulle-sde/mulle-sde)
*extensions*.


Extension                      | Type      | Description
-------------------------------|-----------|-----------------------------------
mulle-sde/c-developer          | meta      | Create plain C projects
mulle-sde/extension-developer  | meta      | Create mulle-sde extesnsions
mulle-sde/sde                  | extra     | Base extension functionality


## Install

### Script

There is an `install-all` script, that installs the pre-requisites and
mulle-sde-developer itself into `/usr`. Suitable for environments without
supported package managers:

```
curl -L -O 'https://raw.githubusercontent.com/mulle-sde/mulle-sde/release/install-all' && \
chmod 755 install-all && \
SDE_PROJECTS="mulle-sde-developer;latest" sudo ./install /usr
```


### Manually

Install the pre-requisite and its pre-requisites:

* [mulle-sde](https://github.com/mulle-sde/mulle-sde)


Install latest version into `/usr` with sudo:

```
curl -L 'https://github.com/mulle-sde-developer/mulle-sde/archive/latest.tar.gz' \
 | tar xfz - && cd 'mulle-sde-developer-latest' && sudo ./install-all /usr
```


### Packages


OS          | Command
------------|------------------------------------
macos       | `brew install mulle-kybernetik/software/mulle-sde-developer`


## Using the extensions

Check that the (meta) extensions are found:

```
mulle-sde extension list
```

Create a C project like so:

```
mulle-sde init -m mulle-sde/c-developer executable
```

Create a mulle-sde extension project like so:

```
mulle-sde init -m mulle-sde/extension-developer extension
```


