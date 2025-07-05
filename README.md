# cmake-library
A C++ library template project using the CMake build system

## Requirements
1. CMake (3.19 or newer)
1. Doxygen

## Getting Started
1. Create a new project using this template by:
    1. Cloning this repository
    1. Clicking the "Use this template" button
1. Replace the default `LICENCE` and `README.md` files.
1. Within the root `CMakeLists.txt` file
    1. Change the default project name (`MyLibrary`) to the name of your project
    1. Replace all instances of `MYLIBRARY_*` to `<PROJECT_NAME>_*`
1. Start coding

## File Directory
```
cmake/                          Contains CMake module files
└── **.cmake        
docs/                           Contains Doxygen input and layout file(s)
├── CMakeLists.txt
└── Doxyfile                    Doxygen input file
examples/                       Contains example executable programs
├── CMakeLists.txt              Configuration file for building example programs
└── **.cpp
include/                        Configuration file for building library include files
├── **.h                        Normal header files
└── **.hpp                      Template header files
lib/                            Contains library dependencies
src/
├── CMakeLists.txt              Configuration file for building library source files
└── **.cpp
tests/                          Contains unit test programs
├── CMakeLists.txt              Configuration file for building unit tests
└── **.cpp                      Unit test files
CMakeLists.txt                  Root configuration file
LICENSE
README.md
```