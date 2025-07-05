cmake_minimum_required (VERSION 3.19)

# Enable Hot Reload for MSVC compilers if supported.
if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

project ("MyLibrary"
	VERSION 1.0
	DESCRIPTION "A simple CMake library.")

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Add build options to this project.
string(COMPARE EQUAL "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_SOURCE_DIR}" MYLIBRARY_STANDALONE)
option(MYLIBRARY_BUILD_EXAMPLES "Build the ${PROJECT_NAME} example programs" ${MYLIBRARY_STANDALONE})
option(MYLIBRARY_BUILD_TESTS "Build the ${PROJECT_NAME} test programs" ${MYLIBRARY_STANDALONE})
option(MYLIBRARY_BUILD_DOCS "Build the ${PROJECT_NAME} HTML documentation." ON)

# Add CMake modules to this project
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# Add source files (.cpp) to this project.
add_library(${PROJECT_NAME})
add_subdirectory("src")

# Add template header files (.hpp) to this project
file(GLOB_RECURSE TEMPLATE_FILES CONFIGURE_DEPENDS "include/*.hpp")
target_sources(${PROJECT_NAME} PUBLIC ${TEMPLATE_FILES})

# Add normal header files (.h) to this project
file(GLOB_RECURSE HEADER_FILES CONFIGURE_DEPENDS "include/*.h")
target_sources(${PROJECT_NAME} PUBLIC ${HEADER_FILES})
target_include_directories(${PROJECT_NAME} PUBLIC "include")
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)

# Fix CMake Issue #18837 
# https://gitlab.kitware.com/cmake/cmake/-/issues/18837
if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1914))
	target_compile_options(${PROJECT_NAME} PUBLIC "/Zc:__cplusplus")
endif()

# Add example programs to this project.
if (MYLIBRARY_BUILD_EXAMPLES)
	add_subdirectory("examples")
endif()

# Add test programs to this project.
if (MYLIBRARY_BUILD_TESTS)
	include(CTest)
	enable_testing()
	add_subdirectory("tests")
endif()

# Add documentation to this project.
if (MYLIBRARY_BUILD_DOCS)
	add_subdirectory("docs")
endif()