# 🏋🏼 mulle-sde, c, cmake and extension support

This is a base collection of [mulle-sde](//github.com/mulle-sde/mulle-sde)
*extensions*.


Extension                      | Type      | Description
-------------------------------|-----------|-----------------------------------
mulle-sde/c-developer          | meta      | Create plain C projects
mulle-sde/extension-developer  | meta      | Create mulle-sde extesnsions
mulle-sde/sde                  | extra     | Base extension functionality


## Install

OS          | Command
------------|------------------------------------
macos       | `brew install mulle-kybernetik/software/mulle-sde-developer`
other       | Install prerequisite [mulle-sde](//github.com/mulle-sde/mulle-sde) first. Then `./install.sh`


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


