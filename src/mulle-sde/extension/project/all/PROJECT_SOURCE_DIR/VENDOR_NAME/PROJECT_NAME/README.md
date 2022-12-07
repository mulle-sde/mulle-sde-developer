# project folder

The project folder holds the files to be installed. Each supported project type
should have a subfolder there of the same name. So if you want to create a
`.travis.yml` file for executable projects you provide a suitable template as
`project/executable/.travis.yml`.

Use subfolder "all" if the project type doesn't matter.

These files will not overwrite existing files. They will be rewritten on update.

# demo folder

The `demo` folder is made up the same as the project folder, but the files are
considered "fluffy" hello-world type files, that a user may not want to have.
These files will be installed only once during init.

# delete folder

The `delete` folder is used to delete folders called "share" in the project.
This is useful to clean and repopulate extension managed files during an
extension upgrade, that are not installed into `.mulle/share/sde`.
The user should be aware, that files in "share" folders are ephemeral.

Example: `cmake/share`.

# share folder

The contents of the `share` folder will be installed into `./mulle-sde/share`.

