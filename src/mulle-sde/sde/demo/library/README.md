# <|PROJECT_NAME|>

#### 🛸 <|PROJECT_NAME|> does something

It works, sometimes.


## mulle-sde

This is a [mulle-sde](//github.com/mulle-sde) project. mulle-sde combines
recursive package management with cross-platform builds via **cmake**:

| Action  | Command                               | Description               |
|---------|---------------------------------------|---------------------------|
| Build   | `mulle-sde craft [--release/--debug]` | Builds into local `kitchen` folder |
| Add     | `mulle-sde dependency add --c --github <|GITHUB_USER|> <|PROJECT_NAME|>` | Add <|PROJECT_NAME|> to another mulle-sde project as a dependency |
| Install | `mulle-sde install --prefix /usr/local https://github.com/<|GITHUB_USER|>/<|PROJECT_NAME|>.git` | Like `make install` |


### Manual Installation


Install the requirements:

| Requirements                                      | Description             |
|---------------------------------------------------|-------------------------|
| [some-requirement](//github.com/some/requirement) | Some requirement        |


Install into `/usr/local`:

``` sh
cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_PREFIX_PATH=/usr/local \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```
