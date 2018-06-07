# project folder

The project folder holds the files to be installed. Each supported project type
should have a subfolder there of the name.

So if you want to create a .travis.yml file for executable projects you provide
a suitable template as `project/executable/.travis.yml`.

Use subfolder "all" if the project type doesn't matter.

These files will not overwrite existing files. They will be rewritten on update.

# demo folder

The `demo` folder is made up the same as the project folder, but the files are
considered "fluff"/helloworld files, that a user may not want to have. These
files will be installed only once during init.

# clobber folder

The `clobber` folder is also made up the same as the project folder. These
files will overwrite whatever is present! Be very sure that the user is aware
of this. By convention place these folders into a folder called 'share'.

# share folder

The contents of the `share` folder will be installed into `./mulle-sde/share`.

