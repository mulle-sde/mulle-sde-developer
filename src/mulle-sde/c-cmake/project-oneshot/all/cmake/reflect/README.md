# DO NOT EDIT THIS FOLDER

If you want to edit any of the files copy them "up" and edit them there.
Though it's probably better to edit `CMakeLists.txt` straight.

```bash
cp share/_Sources.cmake .
vi _Sources.cmake
```

If you do not want any files reflected, turn reflection off with:

```bash
mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_RUN NO
mulle-sde environment set MULLE_MATCH_TO_CMAKE_RUN NO
```
