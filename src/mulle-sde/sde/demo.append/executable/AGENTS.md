## Executable

This project produces an executable product.
To run it, use the following command:

```bash
mulle-sde run
```

If you have multiple executables built, use

``` bash
mulle-sde run <productname>
```

You can get a list of products after crafting with

``` bash
mulle-sde product list
```


## Testing Executable Projects (No Code Required)

For executable projects, mulle-test automatically creates output-based
tests:

1. Setup: mulle-sde test init creates test infrastructure
2. Test files: Create .args and .stdout file pairs in test directories
   - hello.args - command line arguments for the executable
   - hello.stdout - expected output (exact match required)
3. Run: mulle-sde test run automatically finds these pairs, runs the executable with the args, and compares output
