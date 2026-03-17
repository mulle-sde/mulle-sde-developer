Test for mulle-sde/electron-developer extension

This test:
1. Initializes a new Electron project with the electron-developer meta extension
2. Checks that all expected files are generated (package.json, main.js, etc.)
3. Runs npm install to verify dependencies can be installed
4. Verifies electron and electron-builder are installed

Run with: ./run-test
