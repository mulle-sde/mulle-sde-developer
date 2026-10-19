### 0.31.1


* consumers that only ``target_link_libraries()`` a library now find headers by their installed-style path (e.g. ``<mulle-core/mulle-core.h>``) again
* raise minimum CMake requirement from 3.13 to 3.30 in the project templates
* whole-archive force-link propagation now requires CMake 3.30, fixing the "has already occurred without any feature or 'DEFAULT' feature" generate error seen with 3.24-3.29
















* Prevent fallback from pulling in sibling installs that duplicate headers or escape the selected architecture
* Include, library, and framework fallback paths are now added individually only when missing from the primary SDK path

* revised cmake support for FetchContents and `add_subdirectory`
* fixed fallback code Debug -> Release

## 0.31.0






* Prevent fallback from pulling in sibling installs that duplicate headers or escape the selected architecture
* Include, library, and framework fallback paths are now added individually only when missing from the primary SDK path

* revised cmake support for FetchContents and `add_subdirectory`
* fixed fallback code Debug -> Release


### 0.30.0

* added mulle-sde/kiro extra extension with AI agents and skills
* added mulle-sde/copilot extra extension for AI code generation
* restructured opencode dispatcher for better AI support
* reorganized howtos and added INTERFACE_DEPENDENCY_PROPAGATION documentation
* improved library CMake support

### 0.29.2

Various small improvements
