# <|PROJECT_NAME|>

#### 🙄 <|PROJECT_NAME|> does something

It works, sometimes.


## Add

Use [mulle-sde](//github.com/mulle-sde) to add <|PROJECT_NAME|> to your project:

``` console
mulle-sde dependency add --c --github <|GITHUB_USER|> <|PROJECT_NAME|>
```

## Install

### mulle-sde

Use [mulle-sde](//github.com/mulle-sde) to build and install <|PROJECT_NAME|>
and all its dependencies:

```
mulle-sde install --prefix /usr/local \
   https://github.com/<|GITHUB_USER|>/<|PROJECT_NAME|>/archive/latest.tar.gz
```

### Manual Installation


Install the requirements:

Requirements                                      | Description
--------------------------------------------------|-----------------------
[some-requirement](//github.com/some/requirement) | Some requirement

Install into `/usr/local`:

```
mkdir build 2> /dev/null
(
   cd build ;
   cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
         -DCMAKE_PREFIX_PATH=/usr/local \
         -DCMAKE_BUILD_TYPE=Release .. ;
   make install
)
```
