# CMakeList.txt : CMake project for cmake-library, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.19)

# Enable Hot Reload for MSVC compilers if supported.
if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

project ("cmake-library")

# Add source to this project's executable.
add_executable (cmake-library  )

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET cmake-library PROPERTY CXX_STANDARD 20)
endif()

# Fix CMake Issue #18837 
# https://gitlab.kitware.com/cmake/cmake/-/issues/18837
if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1914))
	target_compile_options(cmake-library PUBLIC "/Zc:__cplusplus")
endif()

# TODO: Add tests and install targets if needed.
